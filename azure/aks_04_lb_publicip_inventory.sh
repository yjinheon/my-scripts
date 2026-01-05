#!/usr/bin/env bash
set -euo pipefail
#source ./env.sh
source ./lib.sh

require_cmd az
#az_sub

MC_RG=$(get_mc_rg)
echo "MC_RG=$MC_RG"

echo "=== Azure Public IPs in MC_RG ==="
az network public-ip list -g "$MC_RG" -o table || true

echo
echo "=== Azure Load Balancers in MC_RG (frontends) ==="
az network lb list -g "$MC_RG" \
  --query "[].{name:name,frontends:frontendIpConfigurations[].{name:name,privateIp:privateIpAddress,publicIpId:publicIPAddress.id}}" -o jsonc || true
