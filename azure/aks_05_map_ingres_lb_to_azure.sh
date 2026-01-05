#!/usr/bin/env bash

#네가 이전에 원했던 “서브넷/방화벽 상태 + 서비스가 어느 망에 붙었는지”를 Ingress 진입점 기준으로 추적

set -euo pipefail
source ./lib.sh
require_cmd az
require_cmd kubectl

MC_RG=$(get_mc_rg)
echo "MC_RG=$MC_RG"

# 1) ingress controller external ip
ING_IP=$(kubectl -n ingress-nginx get svc nginx-ingress-ingress-nginx-controller \
  -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || true)

if [[ -z "${ING_IP:-}" ]]; then
  echo "Cannot find ingress-nginx-controller EXTERNAL-IP. Check service name/namespace."
  exit 1
fi

echo "Ingress Controller IP: $ING_IP"
echo

# 2) find matching Public IP (if any)
echo "=== Matching Azure Public IP resource (if external) ==="
PIP_ID=$(az network public-ip list -g "$MC_RG" \
  --query "[?ipAddress=='$ING_IP'].id | [0]" -o tsv || true)

if [[ -n "${PIP_ID:-}" && "${PIP_ID:-null}" != "null" ]]; then
  az network public-ip show --ids "$PIP_ID" -o jsonc
else
  echo "No Public IP found matching $ING_IP in $MC_RG (maybe internal LB / private IP)."
fi

echo
echo "=== Azure Load Balancers (frontends) in MC_RG ==="
az network lb list -g "$MC_RG" \
  --query "[].{name:name,frontends:frontendIpConfigurations[].{name:name,privateIp:privateIpAddress,publicIpId:publicIPAddress.id,subnetId:subnet.id}}" -o jsonc

echo
echo "=== AKS node subnet / pod subnet (from AKS settings) ==="
NODE_SUBNET_ID=$(az aks show -g "$AKS_RG" -n "$AKS_NAME" --query "agentPoolProfiles[0].vnetSubnetId" -o tsv || true)
POD_SUBNET_ID=$(az aks show -g "$AKS_RG" -n "$AKS_NAME" --query "networkProfile.podSubnetId" -o tsv || true)
echo "NODE_SUBNET_ID=$NODE_SUBNET_ID"
echo "POD_SUBNET_ID=$POD_SUBNET_ID"

echo
echo "=== Subnet details (NSG/RouteTable) ==="
if [[ -n "${NODE_SUBNET_ID:-}" && "${NODE_SUBNET_ID:-null}" != "null" ]]; then
  az network vnet subnet show --ids "$NODE_SUBNET_ID" \
    --query "{name:name,prefix:addressPrefix,nsg:networkSecurityGroup.id,routeTable:routeTable.id,vnet:id}" -o jsonc
fi
if [[ -n "${POD_SUBNET_ID:-}" && "${POD_SUBNET_ID:-null}" != "null" ]]; then
  az network vnet subnet show --ids "$POD_SUBNET_ID" \
    --query "{name:name,prefix:addressPrefix,nsg:networkSecurityGroup.id,routeTable:routeTable.id,vnet:id}" -o jsonc
fi
