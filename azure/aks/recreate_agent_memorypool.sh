#!/usr/bin/env bash

az aks nodepool delete \
  --resource-group scv \
  --cluster-name scv-aks \
  --name memorypool \
  --no-wait

az aks nodepool list \
  --resource-group scv \
  --cluster-name scv-aks \
  --query "[].{Name:name, State:provisioningState}" \
  --output table

#또는 실시간 확인
#watch -n 5 'az aks nodepool list --resource-group scv --cluster-name scv-aks -o table'

az aks nodepool add \
  --resource-group scv \
  --cluster-name scv-aks \
  --name memorypool \
  --node-count 1 \
  --node-vm-size Standard_E4s_v5 \
  --mode User \
  --labels workload=memory-intensive

az aks nodepool show \
  --resource-group scv \
  --cluster-name scv-aks \
  --name memorypool \
  --query "{Name:name, VmSize:vmSize, Count:count, State:provisioningState}" \
  --output table
