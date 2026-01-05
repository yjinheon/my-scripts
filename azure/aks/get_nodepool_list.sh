#!/usr/bin/env bash

az aks nodepool list \
  --resource-group scv \
  --cluster-name scv-aks \
  --query "[].{Name:name, Mode:mode}" \
  -o table
