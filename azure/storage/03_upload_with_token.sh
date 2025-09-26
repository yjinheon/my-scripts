#!/usr/bin/env bash

set -euo pipefail

source .env

AZ_SAS_TOKEN="se=2027-09-01T00%3A00%3A00Z&sp=rwdlac&spr=https&sv=2022-11-02&ss=b&srt=sco&sig=Bptt7iorJbPedRkwL0aihSTAHsX9zoFSLS6baZF%2BUbs%3D"

az storage blob upload-batch \
  --account-name "$SA" \
  -d '$web' \
  -s $DIST_DIR \
  --overwrite true \
  --sas-token "$AZ_SAS_TOKEN"
