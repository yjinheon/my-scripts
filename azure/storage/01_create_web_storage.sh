#!/usr/bin/env bash

#set -euo pipefail

source ./.env

echo "RG=$RG"
echo "SA=$SA"
echo "REGION=$REGION"
echo "INDEX_DOC=$INDEX_DOC"
echo "ERROR_DOC=$ERROR_DOC"

# StorageV2  (static web hosting 용)

az storage account create -g $RG -n $SA -l $REGION \
  --sku Standard_LRS --kind StorageV2 --https-only true

# ===== Static website 활성화 (index/404 지정) =====
az storage blob service-properties update \
  --account-name "$SA" \
  --static-website \
  --index-document "$INDEX_DOC" \
  --404-document "$ERROR_DOC"
