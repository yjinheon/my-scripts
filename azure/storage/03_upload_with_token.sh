#!/usr/bin/env bash

set -euo pipefail

source .env

AZ_SAS_TOKEN="some-az-sas-token"

az storage blob upload-batch \
  --account-name "$SA" \
  -d '$web' \
  -s $DIST_DIR \
  --overwrite true \
  --sas-token "$AZ_SAS_TOKEN"
