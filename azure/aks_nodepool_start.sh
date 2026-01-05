#!/usr/bin/env bash
set -euo pipefail

POOLS=$(az aks nodepool list -g "$RG" --cluster-name "$AKS_NAME" --query "[].name" -o tsv)

for p in $POOLS; do
  echo "Starting nodepool: $p"
  az aks nodepool start -g "$RG" --cluster-name "$AKS_NAME" --nodepool-name "$p" || true
done
