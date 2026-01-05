#!/usr/bin/env bash
set -euo pipefail

#VNet/서브넷 주소대역 + NSG/RouteTable 조회

#source ./env.sh
source ./lib.sh

require_cmd az

echo "=== VNets ==="
if [[ -n "${NET_SCOPE_RG:-}" ]]; then
  jsonc network vnet list -g "$NET_SCOPE_RG" --query "[].{rg:resourceGroup,name:name,location:location,addr:addressSpace.addressPrefixes}"
else
  jsonc network vnet list --query "[].{rg:resourceGroup,name:name,location:location,addr:addressSpace.addressPrefixes}"
fi

echo
echo "=== Subnets (addr + NSG + routeTable + delegation) ==="
if [[ -n "${NET_SCOPE_RG:-}" ]]; then
  VNets=$(az network vnet list -g "$NET_SCOPE_RG" --query "[].{rg:resourceGroup,name:name}" -o tsv)
else
  VNets=$(az network vnet list --query "[].{rg:resourceGroup,name:name}" -o tsv)
fi

# tsv는 2열씩 나오므로 read로 처리
while read -r RG VNET; do
  [[ -z "${RG:-}" ]] && continue
  echo "--- $RG / $VNET ---"
  az network vnet subnet list -g "$RG" --vnet-name "$VNET" \
    --query "[].{subnet:name,prefix:addressPrefix,nsg:networkSecurityGroup.id,routeTable:routeTable.id,delegations:delegations[].serviceName}" -o jsonc
done <<<"$VNets"
