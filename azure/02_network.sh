#!/usr/bin/env bash
set -euo pipefail

source .env
source ./helper.sh

info "VNet 생성/확인: $VNET ($ADDR)"
if az network vnet show -g "$RG" -n "$VNET" >/dev/null 2>&1; then
  ok "이미 존재: $VNET"
else
  az network vnet create -g "$RG" -n "$VNET" -l "$LOC" --address-prefixes "$ADDR" >/dev/null
  az network vnet show -g "$RG" -n "$VNET" -o table
fi

info "서브넷: $SUBNET_PUBLIC_NAME ($SUBNET_PUBLIC_CIDR)"
az network vnet subnet show -g "$RG" --vnet-name "$VNET" -n "$SUBNET_PUBLIC_NAME" >/dev/null 2>&1 ||
  az network vnet subnet create -g "$RG" --vnet-name "$VNET" -n "$SUBNET_PUBLIC_NAME" \
    --address-prefixes "$SUBNET_PUBLIC_CIDR" >/dev/null
az network vnet subnet show -g "$RG" --vnet-name "$VNET" -n "$SUBNET_PUBLIC_NAME" -o table

info "서브넷: $SUBNET_APP_NAME ($SUBNET_APP_CIDR)"
az network vnet subnet show -g "$RG" --vnet-name "$VNET" -n "$SUBNET_APP_NAME" >/dev/null 2>&1 ||
  az network vnet subnet create -g "$RG" --vnet-name "$VNET" -n "$SUBNET_APP_NAME" \
    --address-prefixes "$SUBNET_APP_CIDR" >/dev/null
az network vnet subnet show -g "$RG" --vnet-name "$VNET" -n "$SUBNET_APP_NAME" -o table

info "DB 서브넷(위임 포함): $SUBNET_DB_NAME ($SUBNET_DB_CIDR)"
if az network vnet subnet show -g "$RG" --vnet-name "$VNET" -n "$SUBNET_DB_NAME" >/dev/null 2>&1; then
  # 위임 적용 여부 확인
  DELEG=$(az network vnet subnet show -g "$RG" --vnet-name "$VNET" -n "$SUBNET_DB_NAME" \
    --query "delegations[].serviceName" -o tsv)
  if [[ "$DELEG" != *"Microsoft.DBforPostgreSQL/flexibleServers"* ]]; then
    info "위임 업데이트 적용"
    az network vnet subnet update -g "$RG" --vnet-name "$VNET" -n "$SUBNET_DB_NAME" \
      --delegations Microsoft.DBforPostgreSQL/flexibleServers >/dev/null
  fi
else
  az network vnet subnet create -g "$RG" --vnet-name "$VNET" -n "$SUBNET_DB_NAME" \
    --address-prefixes "$SUBNET_DB_CIDR" \
    --delegations Microsoft.DBforPostgreSQL/flexibleServers >/dev/null
fi
az network vnet subnet show -g "$RG" --vnet-name "$VNET" -n "$SUBNET_DB_NAME" \
  --query "{name:name,delegations:delegations[].serviceName,address:addressPrefix}" -o table
