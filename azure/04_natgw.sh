#!/usr/bin/env bash

set -euo pipefail
set -x

source .env
source ./helper.sh

info "NAT GW용 Public IP 생성/확인: $PIP_NAT"
if az network public-ip show -g "$RG" -n "$PIP_NAT" >/dev/null 2>&1; then
  ok "이미 존재: $PIP_NAT"
else
  az network public-ip create -g "$RG" -n "$PIP_NAT" -l "$LOC" \
    --sku Standard --allocation-method Static --version IPv4
fi

# Public IP 프로비저닝 완료까지 대기
az network public-ip wait -g "$RG" -n "$PIP_NAT" --created --interval 5 --timeout 300
az network public-ip show -g "$RG" -n "$PIP_NAT" \
  --query "{name:name,ip:ipAddress,sku:sku.name}" -o table

info "NAT Gateway 생성/확인: $NATGW"
if az network nat gateway show -g "$RG" -n "$NATGW" >/dev/null 2>&1; then
  ok "이미 존재: $NATGW"
else
  az network nat gateway create -g "$RG" -n "$NATGW" -l "$LOC" \
    --public-ip-addresses "$PIP_NAT" \
    --idle-timeout 10
fi

# NAT GW 프로비저닝 완료까지 대기
az network nat gateway wait -g "$RG" -n "$NATGW" --created --interval 5 --timeout 600
az network nat gateway show -g "$RG" -n "$NATGW" \
  --query "{name:name,sku:sku.name,pips:publicIpAddresses[].id}" -o table

info "서브넷에 NAT GW 연결 (App/DB)"
az network vnet subnet update -g "$RG" --vnet-name "$VNET" -n "$SUBNET_APP_NAME" \
  --nat-gateway "$NATGW" >/dev/null
az network vnet subnet update -g "$RG" --vnet-name "$VNET" -n "$SUBNET_DB_NAME" \
  --nat-gateway "$NATGW" >/dev/null

# 연결 결과 확인 (table)
info "NAT GW 연결 결과 확인"
az network vnet subnet show -g "$RG" --vnet-name "$VNET" -n "$SUBNET_APP_NAME" \
  --query "{subnet:name,cidr:addressPrefix,natgw:natGateway.id}" -o table
az network vnet subnet show -g "$RG" --vnet-name "$VNET" -n "$SUBNET_DB_NAME" \
  --query "{subnet:name,cidr:addressPrefix,natgw:natGateway.id}" -o table

ok "NAT Gateway 설정 완료"
