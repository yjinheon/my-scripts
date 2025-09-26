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

# 현재 상태 한 번 출력
az postgres flexible-server show -g "$RG" -n "$PG_NAME" \
  --query "{state:state,host:fullyQualifiedDomainName}" -o table

# state == Ready 될 때까지 대기
az postgres flexible-server wait -g "$RG" -n "$PG_NAME" \
  --custom "state=='Ready'" \
  --interval 5 --timeout 900 || {
  warn "state==Ready 대기 타임아웃 — 현재 상태 표시 후 종료"
  az postgres flexible-server show -g "$RG" -n "$PG_NAME" -o jsonc
  exit 1
}

# 최종 상태 출력
az postgres flexible-server show -g "$RG" -n "$PG_NAME" \
  --query "{name:name,state:state,ha:highAvailability.mode,version:version,host:fullyQualifiedDomainName,network:network.publicNetworkAccess}"

info "Private DNS A 레코드 확인 (${PG_DNS_ZONE})"
az network private-dns record-set a list -g "$RG" -z "$PG_DNS_ZONE"

# 3) Private DNS A 레코드 확인
#info "Private DNS A 레코드 확인 (${PG_DNS_ZONE})"

# 레코드 개수 확인
A_COUNT=$(az network private-dns record-set a list -g "$RG" -z "$PG_DNS_ZONE" \
  --query "length(@)" -o tsv 2>/dev/null || echo 0)

if [[ "${A_COUNT}" -gt 0 ]]; then
  # table 형식으로 핵심 필드만 출력
  az network private-dns record-set a list -g "$RG" -z "$PG_DNS_ZONE" \
    --query "[].{name:name,fqdn:fqdn,ip:aRecords[0].ipv4Address,ttl:ttl}" -o table
else
  echo "[INFO] A 레코드가 없습니다. (존/링크 상태를 확인하세요)"
  # 상세 확인이 필요하면 JSON 보기:
  az network private-dns record-set a list -g "$RG" -z "$PG_DNS_ZONE" -o jsonc
fi
