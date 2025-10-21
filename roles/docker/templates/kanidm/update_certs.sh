#!/bin/bash
set -euo pipefail

# --- Configuration ---
LOG_FILE="/var/log/kanidm-cert-update.log"
KANIDM_USER="kanidm"
KANIDM_GROUP="kanidm"
KANIDM_DATA="/opt/kanidm/data"
KANIDM_CERT="$KANIDM_DATA/cert.crt"
KANIDM_KEY="$KANIDM_DATA/key.pem"
KANIDM_CHAIN="$KANIDM_DATA/chain.pem"
ROOT_CA="/etc/pki/ca-trust/source/anchors/pnl-stepca-1_Root_CA_116506436772906500322892527620728168687.pem"
DOCKER_COMPOSE_FILE="/opt/kanidm/docker-compose.yml"

# --- Logging function ---
DATE="$(date '+%Y-%m-%d %H:%M:%S')"
log() {
    echo "$DATE $1" | tee -a "$LOG_FILE"
}

log "Starting Kanidm certificate update."

# --- Renew certificate ---
if ! sudo step ca renew --force --expires-in 24h "$KANIDM_CERT" "$KANIDM_KEY" 2>&1 | tee -a "$LOG_FILE"; then
    log "ERROR: Certificate renewal failed."
    exit 1
fi

# --- Create certificate chain atomically ---
TMP_CHAIN="${KANIDM_CHAIN}.tmp"
if ! sudo sh -c "cat '$KANIDM_CERT' '$ROOT_CA' > '$TMP_CHAIN'"; then
    log "ERROR: Failed to create certificate chain."
    exit 1
fi
sudo mv "$TMP_CHAIN" "$KANIDM_CHAIN"

# --- Set permissions ---
log "Setting permissions."
sudo chown -R "$KANIDM_USER:$KANIDM_GROUP" "$KANIDM_DATA"
sudo chmod 600 "$KANIDM_KEY"
sudo chmod 644 "$KANIDM_CERT" "$KANIDM_CHAIN"

# --- Restart Kanidm server (docker compose) ---
log "Restarting Kanidm server."
if ! sudo docker compose -f "$DOCKER_COMPOSE_FILE" down 2>&1 | tee -a "$LOG_FILE"; then
    log "ERROR: Docker compose down failed."
    exit 1
fi
if ! sudo docker compose -f "$DOCKER_COMPOSE_FILE" up -d 2>&1 | tee -a "$LOG_FILE"; then
    log "ERROR: Docker compose up failed."
    exit 1
fi

log "Kanidm certificates updated and server restarted successfully."

