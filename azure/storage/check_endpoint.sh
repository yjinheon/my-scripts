#!/usr/bin/env bash

source .env

# ===== 엔드포인트 확인 =====
ENDPOINT=$(az storage account show -g "$RG" -n "$SA" --query "primaryEndpoints.web" -o tsv)
echo "Static website endpoint: $ENDPOINT"
