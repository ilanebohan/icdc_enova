#!/usr/bin/env bash
set -euo pipefail

# === Utiliser la clé SSH dédiée ===
KEY_PATH="/home/debian/.ssh/enova_deploy"      # adapte si besoin
SSH_CMD="ssh -i ${KEY_PATH} -o IdentitiesOnly=yes"
export GIT_SSH_COMMAND="${SSH_CMD}"
mkdir -p ~/.ssh
ssh-keyscan -t rsa,ecdsa,ed25519 github.com >> ~/.ssh/known_hosts 2>/dev/null || true
chmod 644 ~/.ssh/known_hosts || true

# === Paramètres ===
BRANCH="${1:-main}"
APP_REPO="${APP_REPO_SSH:-git@github.com:ilanebohan/enova.git}"
APP_DIR="${APP_DIR:-/opt/enova}"
SERVER_DIR="${SERVER_DIR:-/opt/enova/server}"

# ENV selon la branche
if [[ "$BRANCH" == "main" ]]; then ENV="production"; else ENV="development"; fi
echo "[deploy] Branch=$BRANCH -> ENV=$ENV"

# --- Pré-requis Docker ---
if ! command -v docker >/dev/null 2>&1; then
  echo "[ERROR] Docker manquant. Installe-le avant."
  exit 1
fi

# --- Clone / Pull code ---
mkdir -p "$APP_DIR"
if [[ ! -d "${APP_DIR}/.git" ]]; then
  echo "[git] clone $APP_REPO -> $APP_DIR"
  git clone "$APP_REPO" "$APP_DIR"
fi
cd "$APP_DIR"
echo "[git] fetch/checkout $BRANCH"
git fetch origin "$BRANCH"
git checkout "$BRANCH"
git pull --ff-only origin "$BRANCH"

# --- Résoudre le fichier Compose ---
COMPOSE_FILE="${SERVER_DIR}/docker-compose.yml"
if [[ ! -f "$COMPOSE_FILE" ]]; then
  for alt in "docker-compose.yaml" "compose.yaml"; do
    [[ -f "${SERVER_DIR}/${alt}" ]] && COMPOSE_FILE="${SERVER_DIR}/${alt}" && break
  done
fi
[[ -f "$COMPOSE_FILE" ]] || { echo "[ERROR] Aucun docker compose dans ${SERVER_DIR}"; exit 1; }
echo "[docker] using ${COMPOSE_FILE}"

# --- (Re)générer le .env ---
ENV_FILE="${SERVER_DIR}/.env"
echo "[env] (re)création de ${ENV_FILE}"
cat > "$ENV_FILE" <<EOF
# auto-généré par deploy.sh
ENV=${ENV}

# APM
ELASTIC_APM_SERVER_URL=${ELASTIC_APM_SERVER_URL:-}
APM_API_KEY=${APM_API_KEY:-}

# Elasticsearch (Filebeat)
ES_HOST=${ES_HOST:-}
ES_API_KEY=${ES_API_KEY:-}

# MySQL (si utilisé)
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-root}
MYSQL_DATABASE=${MYSQL_DATABASE:-enova}
MYSQL_USER=${MYSQL_USER:-enova}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-enova}
EOF

# --- Lancer / mettre à jour les services ---
echo "[docker] compose pull + up -d"
docker compose -f "$COMPOSE_FILE" pull || true
docker compose -f "$COMPOSE_FILE" up -d

echo "[docker] ps"
docker compose -f "$COMPOSE_FILE" ps

IP=$(hostname -I 2>/dev/null | awk '{print $1}')
echo "✅ Déploiement OK — API: http://${IP:-localhost}:3000/health"

