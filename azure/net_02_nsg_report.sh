#!/usr/bin/env bash

set -euo pipefail
#source ./env.sh
source ./lib.sh

require_cmd az
#az_sub

echo "=== NSG list (associations) ==="
if [[ -n "${NET_SCOPE_RG:-}" ]]; then
  az network nsg list -g "$NET_SCOPE_RG" \
    --query "[].{rg:resourceGroup,name:name,subnets:subnets[].id,nics:networkInterfaces[].id}" -o jsonc
else
  az network nsg list \
    --query "[].{rg:resourceGroup,name:name,subnets:subnets[].id,nics:networkInterfaces[].id}" -o jsonc
fi

echo
echo "=== NSG rules (each NSG) ==="
NSGS=$(az network nsg list ${NET_SCOPE_RG:+-g "$NET_SCOPE_RG"} --query "[].{rg:resourceGroup,name:name}" -o tsv)
while read -r RG NSG; do
  [[ -z "${RG:-}" ]] && continue
  echo "--- $RG / $NSG ---"
  az network nsg rule list -g "$RG" --nsg-name "$NSG" -o table
done <<<"$NSGS"
