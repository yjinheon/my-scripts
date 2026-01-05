#!/usr/bin/env bash

source ./.env

echo "RG=$RG"
echo "COMMONSA=$COMMONSA"
echo "REGION=$REGION"

# StorageV2  (common object storage 용)

az storage account create -g $RG -n $COMMONSA -l $REGION \
  --sku Standard_LRS --kind StorageV2 --https-only true
