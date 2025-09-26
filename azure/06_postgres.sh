#!/usr/bin/env bash

set -euo pipefail
source .env

source ./helper.sh

info "PostgreSQL Flexible Server 생성(Private access)"
if az postgres flexible-server show -g "$RG" -n "$PG_NAME" >/dev/null 2>&1; then
  ok "이미 존재: $PG_NAME"
else
  az postgres flexible-server create -g "$RG" -n "$PG_NAME" -l "$LOC" \
    --version "$PG_VERSION" \
    --vnet "$VNET" --subnet "$SUBNET_DB_NAME" \
    --private-dns-zone "$PG_DNS_ZONE" \
    --tier Burstable --sku-name Standard_B1ms \
    --storage-size "$PG_STORAGE_SIZE" \
    --backup-retention 7 \
    --admin-user "$PG_ADMIN_USER" --admin-password "$PG_ADMIN_PASSWORD"
fi

# 1) 생성/업데이트 완료까지 대기
az postgres flexible-server wait -g "$RG" -n "$PG_NAME" --created --interval 5 --timeout 900
# (이미 있던 서버를 업데이트한 경우라면 --updated 도 활용 가능)
# az postgres flexible-server wait -g "$RG" -n "$PG_NAME" --updated --interval 5 --timeout 900

# 2) 상태 요약 출력 (state/FQDN 등)
az postgres flexible-server show -g "$RG" -n "$PG_NAME" \
  --query "{name:name,state:state,ha:highAvailability.mode,version:version,host:fullyQualifiedDomainName,network:network.publicNetworkAccess}" -o table

# 3) Private DNS A 레코드 확인
info "Private DNS A 레코드 확인 (${PG_DNS_ZONE})"
az network private-dns record-set a list -g "$RG" -z "$PG_DNS_ZONE" -o table
