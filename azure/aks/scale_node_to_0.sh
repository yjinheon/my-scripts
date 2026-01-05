#!/usr/bin/env bash

az aks nodepool scale \
  --resource-group $RG \
  --cluster-name $CLUSTER \
  --name userpool \
  --node-count 0

az aks nodepool scale \
  --resource-group $RG \
  --cluster-name $CLUSTER \
  --name memorypool \
  --node-count 0

az aks nodepool scale \
  --resource-group $RG \
  --cluster-name $CLUSTER \
  --name syspool \
  --node-count 0
