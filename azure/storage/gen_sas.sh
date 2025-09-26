#!/bin/bash

az storage account generate-sas \
  --account-name $SA \
  --services b \
  --resource-types sco \
  --permissions rwdlac \
  --expiry 2026-09-01T00:00Z \
  --https-only \
  --output tsv
