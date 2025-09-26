#!/usr/bin/env bash
set -euo pipefail

source ./helper.sh
source .env

info "Private DNS Zone 생성/확인: $PG_DNS_ZONE"
az network private-dns zone show -g "$RG" -n "$PG_DNS_ZONE" >/dev/null 2>&1 ||
  az network private-dns zone create -g "$RG" -n "$PG_DNS_ZONE" >/dev/null
az network private-dns zone show -g "$RG" -n "$PG_DNS_ZONE" -o table

info "VNet 링크 생성/확인: $DNS_LINK_NAME"
az network private-dns link vnet show -g "$RG" -n "$DNS_LINK_NAME" -z "$PG_DNS_ZONE" >/dev/null 2>&1 ||
  az network private-dns link vnet create -g "$RG" -n "$DNS_LINK_NAME" -z "$PG_DNS_ZONE" \
    -v "$VNET" -e false >/dev/null

# 확인: 링크 상태
az network private-dns link vnet show -g "$RG" -n "$DNS_LINK_NAME" -z "$PG_DNS_ZONE" \
  --query "{name:name,registrationEnabled:registrationEnabled,virtualNetwork:virtualNetwork.id}" -o table
