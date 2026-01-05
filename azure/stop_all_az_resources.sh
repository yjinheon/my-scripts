#!/usr/bin/env bash

set -euo pipefail
#source ./env.sh
#az account set --subscription "$SUBSCRIPTION_ID"

echo "[1/2] Stop AKS cluster: $AKS_NAME"
az aks stop -g "$RG" -n "$AKS_NAME" || true

echo "[2/2] Stop PostgreSQL Flexible Server: $PG_NAME"
az postgres flexible-server stop -g "$RG" -n "$PG_NAME" || true

echo "Done. (PG는 7일 후 자동 Start 제한 있음)"
