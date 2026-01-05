#!/usr/bin/env bash
set -euo pipefail
source ./lib.sh

require_cmd az
#az_sub

echo "=== AKS network profile ==="
az aks show -g "$RG" -n "$AKS_NAME" \
  --query "{name:name, location:location, nodeResourceGroup:nodeResourceGroup, networkProfile:networkProfile, apiServerAccessProfile:apiServerAccessProfile}" -o jsonc
