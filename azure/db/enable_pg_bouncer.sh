#!/usr/bin/env bash

az postgres flexible-server parameter set \
  --resource-group $RG \
  --server-name $PG_NAME \
  --name pgbouncer.enabled \
  --value true
