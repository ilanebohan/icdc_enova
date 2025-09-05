#!/usr/bin/env bash
set -euo pipefail

# === Force utilisation d'une clé SSH spécifique ===
KEY_PATH="/home/ubuntu/.ssh/enova_deploy"
SSH_CMD="ssh -i ${KEY_PATH} -o IdentitiesOnly=yes"
export GIT_SSH_COMMAND="${SSH_CMD}"

# Assurer que github.com est connu (évite les prompts)
mkdir -p ~/.ssh
ssh-keyscan -t rsa,ecdsa,ed25519 github.com >> ~/.ssh/known_hosts 2>/dev/null || true
chmod 644 ~/.ssh/known_hosts || true


# Chargement config deploy
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config.env"

BRANCH="${1:-$DEFAULT_BRANCH}"
BACKUP_PATH="${2:-}"   # optionnel: chemin absolu vers un backup.sql

# ENV selon la branche
if [[ "$BRANCH" == "main" ]]; then
  ENV="production"
else
  ENV="development"
fi

echo "[deploy] Branch=$BRANCH -> ENV=$ENV"

# Vérif Docker
if ! command -v docker >/dev/null 2>&1; then
  echo "[ERROR] Docker manquant. Installe-le avant (voir tuto)."
  exit 1
fi

# Cloner/mettre à jour le repo APP
mkdir -p "$APP_DIR"
if [[ ! -d "${APP_DIR}/.git" ]]; then
  echo "[git] clone $APP_REPO_SSH -> $APP_DIR"
  git clone "$APP_REPO_SSH" "$APP_DIR"
fi
cd "$APP_DIR"
echo "[git] fetch/checkout $BRANCH"
git fetch origin "$BRANCH"
git checkout "$BRANCH"
git pull --ff-only origin "$BRANCH"

# Forcer ENV dans le .env du serveur
ENV_FILE="${SERVER_DIR}/.env"
if [[ ! -f "$ENV_FILE" ]]; then
  echo "[ERROR] ${ENV_FILE} introuvable. Crée-le avec tes secrets avant de déployer."
  exit 1
fi
sed -i "s/^ENV=.*/ENV=${ENV}/" "$ENV_FILE"

# Copier un backup si fourni
if [[ -n "$BACKUP_PATH" ]]; then
  if [[ ! -f "$BACKUP_PATH" ]]; then
    echo "[ERROR] backup introuvable: $BACKUP_PATH"; exit 1
  fi
  mkdir -p "${SERVER_DIR}/db-backups"
  cp -f "$BACKUP_PATH" "${SERVER_DIR}/db-backups/backup.sql"
  echo "[db] backup copié -> ${SERVER_DIR}/db-backups/backup.sql"
fi

# Démarrer compose
cd "$SERVER_DIR"
echo "[docker] compose up -d"
docker compose pull || true
docker compose up -d

# Importer le backup si présent
if [[ -f "./db-backups/backup.sql" ]]; then
  echo "[db] Import backup.sql"
  # attendre MySQL healthy (si tu as un service db dans compose)
  if docker ps --format '{{.Names}}' | grep -q '^enova-db$'; then
    for i in {1..30}; do
      STATUS=$(docker inspect --format '{{json .State.Health.Status}}' enova-db 2>/dev/null || echo '"unknown"')
      [[ "$STATUS" == '"healthy"' ]] && break
      sleep 3
    done
    docker exec -i enova-db sh -lc \
      "exec mysql -u\"\$MYSQL_USER\" -p\"\$MYSQL_PASSWORD\" -D\"\$MYSQL_DATABASE\"" \
      < ./db-backups/backup.sql
  else
    echo "[warn] Service 'enova-db' introuvable, skip import."
  fi
  echo "[db] Import terminé"
fi

echo "[docker] ps"
docker compose ps

IP=$(hostname -I 2>/dev/null | awk '{print $1}')
echo "✅ Déploiement OK — API: http://${IP:-localhost}:3000/health"
