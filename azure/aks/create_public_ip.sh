#!/usr/bin/env bash

# create NAT-Gateway
az network public-ip create \
  -g "$RG" \
  -n "${CLUSTER}-nat-pip" \
  --sku Standard --allocation-method Static
