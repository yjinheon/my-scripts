#!/usr/bin/env bash

ACR_NAME=scvacr
SP_APP_ID=284b66c1-d41e-44c8-8a69-359546c0ead4
SP_PASSWORD=some_sp_pass

docker login $ACR_NAME.azurecr.io \
  -u $SP_APP_ID \
  -p $SP_PASSWORD
