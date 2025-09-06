#!/usr/bin/env bash
set -euo pipefail

log() { echo "[$(date +'%F %T')] $*"; }
wait_http() { local u="$1" t="${2:-60}" s=$(date +%s); while ! curl -fsS "$u" >/dev/null 2>&1; do [[ $(( $(date +%s)-s )) -ge $t ]] && return 1; sleep 2; done; }

# === Git (clé SSH) ===
KEY_PATH="/home/debian/.ssh/enova_deploy"
export GIT_SSH_COMMAND="ssh -i ${KEY_PATH} -o IdentitiesOnly=yes"
mkdir -p ~/.ssh && ssh-keyscan -t rsa,ecdsa,ed25519 github.com >> ~/.ssh/known_hosts 2>/dev/null || true
chmod 644 ~/.ssh/known_hosts || true

# === Paramètres ===
BRANCH="${1:-main}"
APP_REPO="${APP_REPO_SSH:-git@github.com:ilanebohan/enova.git}"
APP_DIR="${APP_DIR:-/opt/enova}"
SERVER_DIR="${SERVER_DIR:-/opt/enova/server}"

# ENV selon la branche
if [[ "$BRANCH" == "main" ]]; then ENV="production"; else ENV="development"; fi
log "[deploy] branch=$BRANCH env=$ENV"

command -v docker >/dev/null || { log "[ERROR] Docker manquant"; exit 1; }

# === Code à jour
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

# === Compose file
COMPOSE_FILE="${SERVER_DIR}/docker-compose.yml"
if [[ ! -f "$COMPOSE_FILE" ]]; then
  for alt in docker-compose.yaml compose.yaml; do
    [[ -f "${SERVER_DIR}/${alt}" ]] && COMPOSE_FILE="${SERVER_DIR}/${alt}" && break
  done
fi
[[ -f "$COMPOSE_FILE" ]] || { log "[ERROR] Aucun docker compose dans ${SERVER_DIR}"; exit 1; }
log "[docker] compose file: $COMPOSE_FILE"

# === Stop stack avant install
log "[docker] down --remove-orphans"
docker compose -f "$COMPOSE_FILE" down --remove-orphans || true

# --- Génère / met à jour le .env sans toucher aux DB_* ---
ENV_FILE="${SERVER_DIR}/.env"
log "[env] upsert ${ENV_FILE}"

mkdir -p "$(dirname "$ENV_FILE")"
touch "$ENV_FILE"

# sauvegarde
cp -f "$ENV_FILE" "${ENV_FILE}.bak.$(date +%s)" || true

# upsert: met à jour une clef si valeur non vide, sinon ne change rien
upsert_if_nonempty() {
  local key="$1" val="$2"
  [[ -z "${val}" ]] && return 0    # ne remplace pas avec vide
  if grep -qE "^${key}=" "$ENV_FILE"; then
    sed -i "s|^${key}=.*|${key}=${val//|/\\|}|" "$ENV_FILE"
  else
    echo "${key}=${val}" >> "$ENV_FILE"
  fi
}

# ⚠️ on met à jour SEULEMENT ces clés (les DB_* restent tels quels dans le fichier)
upsert_if_nonempty ENV "${ENV}"
upsert_if_nonempty ELASTIC_APM_SERVER_URL "${ELASTIC_APM_SERVER_URL:-}"
upsert_if_nonempty APM_API_KEY "${APM_API_KEY:-}"
upsert_if_nonempty ES_HOST "${ES_HOST:-}"
upsert_if_nonempty ES_API_KEY "${ES_API_KEY:-}"

# si DB_HOST absent et tu veux un défaut côté serveur (optionnel) :
if ! grep -qE '^DB_HOST=' "$ENV_FILE"; then
  echo "DB_HOST=host.docker.internal" >> "$ENV_FILE"
  echo "DB_PORT=3306" >> "$ENV_FILE"
fi

log "[env] preview (non sensible) :"
grep -E '^(ENV|ELASTIC_APM_SERVER_URL|ES_HOST|DB_HOST|DB_PORT)=' "$ENV_FILE" || true

# Diag rapide (.env non vide)
APM_URL=$(grep -E '^ELASTIC_APM_SERVER_URL=' "$ENV_FILE" | cut -d= -f2-)
[[ -z "${APM_URL}" ]] && log "[WARN] ELASTIC_APM_SERVER_URL est vide → l’agent APM pointera sur 127.0.0.1:8200"

# === NPM INSTALL bloquant AVANT tout démarrage
if [[ -f "${SERVER_DIR}/package.json" ]]; then
  log "[npm] install dans ${SERVER_DIR}"
  mkdir -p "${SERVER_DIR}/node_modules"
  START=$(date +%s)
  docker run --rm \
    -u "$(id -u)":"$(id -g)" \
    -v "${SERVER_DIR}:/app" -w /app \
    node:20-alpine sh -lc '
      set -e
      npm config set audit false
      npm config set fund false
      if [ -f package-lock.json ]; then npm ci --omit=dev; else npm i --omit=dev; fi
    '
  log "[npm] terminé en $(( $(date +%s) - START ))s"
else
  log "[npm] SKIP: pas de package.json dans ${SERVER_DIR}"
fi

# === Compose avec --env-file (clé du problème APM)
COMPOSE_CMD=(docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE")

log "[docker] pull"
"${COMPOSE_CMD[@]}" pull || true

log "[docker] up -d"
"${COMPOSE_CMD[@]}" up -d

# === Sanity checks

# 1) Vérifier que l'API voit bien les variables APM
log "[check] printenv (api) | grep ELASTIC_APM"
if "${COMPOSE_CMD[@]}" exec -T api sh -lc 'printenv | grep -E "^ELASTIC_APM|^ENV="' ; then
  :
else
  log "[WARN] impossible d’inspecter l’API (pas encore prête ?)"
fi

# 2) Optionnel: si tu utilises host.docker.internal sous Linux, check la résolution dans le conteneur
if "${COMPOSE_CMD[@]}" ps | grep -q 'api'; then
  if ! "${COMPOSE_CMD[@]}" exec -T api sh -lc 'getent hosts host.docker.internal >/dev/null 2>&1'; then
    log "[WARN] host.docker.internal non résolu dans le conteneur. Sous Linux, ajoute dans docker-compose.yml:
      extra_hosts:
        - \"host.docker.internal:host-gateway\""
  fi
fi

# 3) Health de l’API
IP=$(hostname -I 2>/dev/null | awk '{print $1}')
API_URL="http://${IP:-127.0.0.1}:3000/health"
log "[wait] $API_URL"
if wait_http "$API_URL" 90; then
  log "[ok] API up"
else
  log "[warn] API /health non joignable après 90s"
fi

log "[docker] ps"
"${COMPOSE_CMD[@]}" ps

log "✅ Déploiement OK — API: $API_URL"
