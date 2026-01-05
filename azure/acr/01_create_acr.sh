#!/usr/bin/env bash

az acr create \
  --resource-group $RG \
  --name $ACR \
  --sku Basic \
  --admin-enabled true
