#!/usr/bin/env bash

# AKS가 쓸 Subnet ID를 확보

set -euo pipefail
source ./.env

echo "== 리소스 그룹 확인 =="
az group show -n "$RG" -o table

echo "== VNet/Subnets 확인 =="
az network vnet show -g "$RG" -n "$VNET" -o table
az network vnet subnet list -g "$RG" --vnet-name "$VNET" -o table

echo "== NSG 확인 =="
az network nsg show -g "$RG" -n "$NSG_PUBLIC" -o table || true
az network nsg show -g "$RG" -n "$NSG_APP" -o table || true

# AKS 노드용으로 사용할 APP Subnet의 리소스 ID 확보
APP_SUBNET_ID=$(az network vnet subnet show -g "$RG" --vnet-name "$VNET" \
  -n "$SUBNET_APP_NAME" --query id -o tsv)

echo "APP_SUBNET_ID=$APP_SUBNET_ID"
