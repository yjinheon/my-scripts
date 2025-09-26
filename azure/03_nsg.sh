#!/usr/bin/env bash

set -euo pipefail

source .env
source ./helper.sh

info "NSG(PUBLIC) 생성/확인: $NSG_PUBLIC"
az network nsg show -g "$RG" -n "$NSG_PUBLIC" >/dev/null 2>&1 ||
  az network nsg create -g "$RG" -n "$NSG_PUBLIC" -l "$LOC" >/dev/null

# 80/443 허용, 22는 myip
az network nsg rule show -g "$RG" --nsg-name "$NSG_PUBLIC" -n allow-http >/dev/null 2>&1 ||
  az network nsg rule create -g "$RG" --nsg-name "$NSG_PUBLIC" -n allow-http \
    --priority 100 --access Allow --direction Inbound --protocol Tcp --destination-port-ranges 80 >/dev/null

az network nsg rule show -g "$RG" --nsg-name "$NSG_PUBLIC" -n allow-https >/dev/null 2>&1 ||
  az network nsg rule create -g "$RG" --nsg-name "$NSG_PUBLIC" -n allow-https \
    --priority 110 --access Allow --direction Inbound --protocol Tcp --destination-port-ranges 443 >/dev/null

az network nsg rule show -g "$RG" --nsg-name "$NSG_PUBLIC" -n allow-ssh-myip >/dev/null 2>&1 ||
  az network nsg rule create -g "$RG" --nsg-name "$NSG_PUBLIC" -n allow-ssh-myip \
    --priority 120 --access Allow --direction Inbound --protocol Tcp --destination-port-ranges 22 \
    --source-address-prefixes "$MYIP" >/dev/null

info "NSG(APP) 생성/확인: $NSG_APP"
az network nsg show -g "$RG" -n "$NSG_APP" >/dev/null 2>&1 ||
  az network nsg create -g "$RG" -n "$NSG_APP" -l "$LOC" >/dev/null

# App 8080/8443 (소스: subnet-public)
# 기존 규칙이 존재 하는지 확인 후 없을 경우 신규 규칙 생성

az network nsg rule show -g "$RG" --nsg-name "$NSG_APP" -n allow-from-public-8080 >/dev/null 2>&1 ||
  az network nsg rule create -g "$RG" --nsg-name "$NSG_APP" -n allow-from-public-8080 \
    --priority 100 --access Allow --direction Inbound --protocol Tcp --destination-port-ranges 8080 \
    --source-address-prefixes "$SUBNET_PUBLIC_CIDR" >/dev/null

az network nsg rule show -g "$RG" --nsg-name "$NSG_APP" -n allow-from-public-8443 >/dev/null 2>&1 ||
  az network nsg rule create -g "$RG" --nsg-name "$NSG_APP" -n allow-from-public-8443 \
    --priority 110 --access Allow --direction Inbound --protocol Tcp --destination-port-ranges 8443 \
    --source-address-prefixes "$SUBNET_PUBLIC_CIDR" >/dev/null

# 서브넷에 NSG 연결
info "서브넷에 NSG 연결"
az network vnet subnet update -g "$RG" --vnet-name "$VNET" -n "$SUBNET_PUBLIC_NAME" \
  --network-security-group "$NSG_PUBLIC" >/dev/null
az network vnet subnet update -g "$RG" --vnet-name "$VNET" -n "$SUBNET_APP_NAME" \
  --network-security-group "$NSG_APP" >/dev/null

# 확인
az network nsg show -g "$RG" -n "$NSG_PUBLIC" -o table
az network nsg show -g "$RG" -n "$NSG_APP" -o table
az network vnet subnet show -g "$RG" --vnet-name "$VNET" -n "$SUBNET_PUBLIC_NAME" \
  --query "{subnet:name,nsg:id}" -o table
az network vnet subnet show -g "$RG" --vnet-name "$VNET" -n "$SUBNET_APP_NAME" \
  --query "{subnet:name,nsg:id}" -o table

info "NSG 규칙 요약 (PUBLIC)"
az network nsg rule list -g "$RG" --nsg-name "$NSG_PUBLIC" \
  --query "[].{name:name,prio:priority,dir:direction,access:access,proto:protocol,ports:destinationPortRanges,source:sourceAddressPrefix}" -o table

info "NSG 규칙 요약 (APP)"
az network nsg rule list -g "$RG" --nsg-name "$NSG_APP" \
  --query "[].{name:name,prio:priority,dir:direction,access:access,proto:protocol,ports:destinationPortRanges,source:sourceAddressPrefix}" -o table
