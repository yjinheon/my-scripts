#!/usr/bin/env bash

az resource list \
  --resource-group $RG \
  --query "[].{name:name, type:type}" \
  -o table
