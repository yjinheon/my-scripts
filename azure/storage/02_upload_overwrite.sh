#!/usr/bin/env bash

set -euo pipefail

source .env

AK=$(az storage account keys list -g "$RG" -n "$SA" --query "[0].value" -o tsv)

# ===== front 산출물 업로드 ($web 컨테이너) =====

az storage blob upload-batch \
  --account-name "$SA" --account-key "$AK" \
  -s "$DIST_DIR" -d '$web' --overwrite
