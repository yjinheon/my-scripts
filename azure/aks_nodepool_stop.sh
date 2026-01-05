#!/usr/bin/env bash

# stop aks_nodpools

set -euo pipefail

POOLS=$(az aks nodepool list -g "$AKS_RG" --cluster-name "$AKS_NAME" --query "[].name" -o tsv)

for p in $POOLS; do
  echo "Stopping nodepool: $p"
  az aks nodepool stop -g "$AKS_RG" --cluster-name "$AKS_NAME" --nodepool-name "$p" || true
done
