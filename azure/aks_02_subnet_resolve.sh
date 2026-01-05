#!/usr/bin/env bash

#AKS가 쓰는 VNet/서브넷(IDs) 실제 리소스 조회
set -euo pipefail
#source ./env.sh
source ./lib.sh

require_cmd az
#az_sub

SUBNET_ID=$(az aks show -g "$RG" -n "$AKS_NAME" --query "agentPoolProfiles[0].vnetSubnetId" -o tsv || true)
POD_SUBNET_ID=$(az aks show -g "$RG" -n "$AKS_NAME" --query "networkProfile.podSubnetId" -o tsv || true)

echo "NODE_SUBNET_ID=$SUBNET_ID"
if [[ -n "${SUBNET_ID:-}" && "${SUBNET_ID:-null}" != "null" ]]; then
  az network vnet subnet show --ids "$SUBNET_ID" -o jsonc
fi

echo "POD_SUBNET_ID=$POD_SUBNET_ID"
if [[ -n "${POD_SUBNET_ID:-}" && "${POD_SUBNET_ID:-null}" != "null" ]]; then
  az network vnet subnet show --ids "$POD_SUBNET_ID" -o jsonc
fi
