#!/usr/bin/env bash

source ./.env

echo "RG=$RG"
echo "COMMONSA=$COMMONSA"

az storage account show-connection-string \
  --name $COMMONSA \
  --resource-group $RG \
  --query connectionString \
  --output tsv
