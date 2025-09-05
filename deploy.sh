#!/usr/bin/env bash
set -euo pipefail

# ===== Helpers =====
log() { echo "[$(date +'%F %T')] $*"; }
wait_http() {
  # wait_http <url> <timeout_sec>
  local url="$1" timeout="${2:-60}" start now
  start=$(date +%s)
  while true; do
    if curl -fsS "$url" >/dev/null 2>&1; then return 0; fi
    now=$(date +%s)
    if (( now - start >= timeout )); then return 1; fi
    sleep 2
  done
}

# === Utiliser la clé SSH dédiée pour git ===
KEY_PATH="/home/debian/.ssh/enova_deploy"
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
log "[deploy] Branch=$BRANCH -> ENV=$ENV"

# --- Pré-requis Docker ---
if ! command -v docker >/dev/null 2>&1; then
  log "[ERROR] Docker manquant. Installe-le avant."
  exit 1
fi

# --- Clone / Pull code ---
mkdir -p "$APP_DIR"
if [[ ! -d "${APP_DIR}/.git" ]]; then
  log "[git] clone $APP_REPO -> $APP_DIR"
  git clone "$APP_REPO" "$APP_DIR"
fi
cd "$APP_DIR"
log "[git] fetch/checkout $BRANCH"
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
[[ -f "$COMPOSE_FILE" ]] || { log "[ERROR] Aucun docker compose dans ${SERVER_DIR}"; exit 1; }
log "[docker] using ${COMPOSE_FILE}"

# --- Stop du stack avant install ---
log "[docker] down (stop + remove orphans)"
docker compose -f "$COMPOSE_FILE" down --remove-orphans || true

# --- (Re)générer le .env ---
ENV_FILE="${SERVER_DIR}/.env"
log "[env] (re)création de ${ENV_FILE}"
cat > "$ENV_FILE" <<EOF
# auto-généré par deploy.sh
ENV=${ENV}

# APM
ELASTIC_APM_SERVER_URL=${ELASTIC_APM_SERVER_URL:-}
APM_API_KEY=${APM_API_KEY:-}

# Elasticsearch (Filebeat)
ES_HOST=${ES_HOST:-}
ES_API_KEY=${ES_API_KEY:-}
EOF

# --- Install deps (npm) AVANT le up (bloquant) ---
if [[ -f "${SERVER_DIR}/package.json" ]]; then
  log "[npm] installation dans ${SERVER_DIR}"
  mkdir -p "${SERVER_DIR}/node_modules"
  START=$(date +%s)
  docker run --rm \
    -u "$(id -u)":"$(id -g)" \
    -v "${SERVER_DIR}:/app" -w /app \
    node:20-alpine sh -lc '
      set -e
      npm config set audit false
      npm config set fund false
      if [ -f package-lock.json ]; then
        echo "[npm] package-lock.json trouvé -> npm ci --omit=dev"
        npm ci --omit=dev
      else
        echo "[npm] pas de lock -> npm i --omit=dev"
        npm i --omit=dev
      fi
    '
  D=$(( $(date +%s) - START ))
  log "[npm] terminé en ${D}s"
else
  log "[npm] SKIP: pas de package.json dans ${SERVER_DIR}"
fi

# --- Pull images + Start ---
log "[docker] compose pull"
docker compose -f "$COMPOSE_FILE" pull || true

log "[docker] compose up -d"
docker compose -f "$COMPOSE_FILE" up -d

# --- Attentes santé (si services présents) ---
# Attendre DB (si conteneur s'appelle enova-db avec healthcheck)
if docker ps --format '{{.Names}}' | grep -q '^enova-db$'; then
  log "[wait] MySQL en santé"
  for i in {1..40}; do
    STATUS=$(docker inspect --format '{{json .State.Health.Status}}' enova-db 2>/dev/null || echo '"unknown"')
    [[ "$STATUS" == '"healthy"' ]] && { log "[wait] MySQL healthy"; break; }
    sleep 3
    if [[ $i -eq 40 ]]; then log "[warn] MySQL pas healthy après ~120s (continue)"; fi
  done
fi

# Attendre API /health
IP=$(hostname -I 2>/dev/null | awk '{print $1}')
API_URL="http://${IP:-127.0.0.1}:3000/health"
log "[wait] API $API_URL"
if wait_http "$API_URL" 90; then
  log "[ok] API up"
else
  log "[warn] Timeout: API /health non joignable après 90s"
fi

log "[docker] ps"
docker compose -f "$COMPOSE_FILE" ps

log "✅ Déploiement OK — API: $API_URL"
