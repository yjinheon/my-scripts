#!/usr/bin/env bash

az postgres flexible-server stop \
  --resource-group $RG \
  --name $PG_NAME
