#!/usr/bin/env bash

# 서브넷 라우팅(방화벽,NVA 경유 여부) 점검
# 라우팅 테이블 리스트확인
set -euo pipefail
source ./lib.sh

require_cmd az

echo "=== Route tables (summary) ==="
if [[ -n "${NET_SCOPE_RG:-}" ]]; then
  az network route-table list -g "$NET_SCOPE_RG" \
    --query "[].{rg:resourceGroup,name:name,subnets:subnets[].id}" -o jsonc
else
  az network route-table list \
    --query "[].{rg:resourceGroup,name:name,subnets:subnets[].id}" -o jsonc
fi

echo
echo "=== Routes that forward to VirtualAppliance (NVA/AzureFirewall) ==="
RTS=$(az network route-table list ${NET_SCOPE_RG:+-g "$NET_SCOPE_RG"} --query "[].{rg:resourceGroup,name:name}" -o tsv)
while read -r RG RT; do
  [[ -z "${RG:-}" ]] && continue
  echo "--- $RG / $RT ---"
  az network route-table route list -g "$RG" --route-table-name "$RT" \
    --query "[?nextHopType=='VirtualAppliance'].{name:name,prefix:addressPrefix,nextHopIp:nextHopIpAddress}" -o table || true
done <<<"$RTS"

echo
echo "=== Azure Firewall resources (if any) ==="
az resource list --resource-type "Microsoft.Network/azureFirewalls" --query "[].{rg:resourceGroup,name:name,location:location}" -o table || true
