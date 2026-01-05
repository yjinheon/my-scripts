#!/usr/bin/env bash

source ./.env

# get account key
ACCOUNT_KEY=$(az storage account keys list \
  --resource-group "$RG" \
  --account-name "$COMMONSA" \
  --query "[0].value" -o tsv)

# get connection string

CONNECTION_STRING=$(az storage account show-connection-string \
  --name "$COMMONSA" \
  --resource-group "$RG" \
  -o tsv)

echo ACCOUNT_KEY : $ACCOUNT_KEY
echo CONNECTION_STRING : $CONNECTION_STRING

az storage container create \
  --name "$COMMONBLOBSC" \
  --account-name "$COMMONSA" \
  --account-key "$ACCOUNT_KEY"
