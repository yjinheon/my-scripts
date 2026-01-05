#!/usr/bin/env bash

source .env

az storage account update \
  --name $COMMONSA \
  --resource-group $RG \
  --allow-blob-public-access true

# 2. Container를 공개로 변경
# az storage container set-permission \
#   --name $COMMONBLOBSC \
#   --account-name $COMMONSA \
#   --public-access blob
