#!/usr/bin/env bash

az network nat gateway create \
  -g "$RG" \
  -n "${CLUSTER}-natgw" \
  --public-ip-addresses "${CLUSTER}-nat-pip" \
  --idle-timeout 10
