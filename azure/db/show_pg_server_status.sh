#!/usr/bin/env bash

az postgres flexible-server show \
  --resource-group $RG \
  --name $PG_NAME \
  --query state
