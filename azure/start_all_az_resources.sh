#!/usr/bin/env bash

set -euo pipefail

#source ./env.sh
#az account set --subscription "$SUBSCRIPTION_ID"

echo "[1/2] Start AKS cluster: $AKS_NAME"
az aks start -g "$RG" -n "$AKS_NAME" || true

echo "[2/2] Start PostgreSQL Flexible Server: $PG_NAME"
az postgres flexible-server start -g "$RG" -n "$PG_NAME" || true

echo "Done."
