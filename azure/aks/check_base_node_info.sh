#!/bin/bash

RESOURCE_GROUP="scv"
CLUSTER_NAME="scv-aks"
LOCATION="koreacentral"

echo "=== PostgreSQL Flexible Server 정보 ==="
az postgres flexible-server list --resource-group $RESOURCE_GROUP --output table
echo ""

PG_SERVERS=$(az postgres flexible-server list --resource-group $RESOURCE_GROUP --query "[].name" -o tsv)
for server in $PG_SERVERS; do
  echo "--- PostgreSQL Server: $server ---"
  az postgres flexible-server show \
    --resource-group $RESOURCE_GROUP \
    --name $server \
    --query '{Name:name, SKU:sku.name, Tier:sku.tier, vCores:sku.capacity, StorageGB:storage.storageSizeGb, Version:version, State:state, Location:location}' \
    --output table
  echo ""
done

echo "=== AKS 노드풀 정보 ==="
NODEPOOLS=$(az aks nodepool list --resource-group $RESOURCE_GROUP --cluster-name $CLUSTER_NAME --query "[].name" -o tsv)

for pool in $NODEPOOLS; do
  echo "--- 노드풀: $pool ---"

  # 노드풀 기본 정보
  NODEPOOL_INFO=$(az aks nodepool show \
    --resource-group $RESOURCE_GROUP \
    --cluster-name $CLUSTER_NAME \
    --name $pool)

  VM_SIZE=$(echo $NODEPOOL_INFO | jq -r '.vmSize')
  COUNT=$(echo $NODEPOOL_INFO | jq -r '.count')
  OS_TYPE=$(echo $NODEPOOL_INFO | jq -r '.osType')
  OS_DISK_SIZE=$(echo $NODEPOOL_INFO | jq -r '.osDiskSizeGb')

  echo "VM Size: $VM_SIZE"
  echo "노드 수: $COUNT"
  echo "OS: $OS_TYPE"
  echo "OS Disk: ${OS_DISK_SIZE}GB"

  # VM 사이즈 상세 정보
  echo "VM 사양:"
  az vm list-sizes --location $LOCATION --query "[?name=='$VM_SIZE'].{vCPU:numberOfCores, MemoryMB:memoryInMb, MaxDataDisks:maxDataDiskCount}" --output table
  echo ""
done

echo ""
echo "=== VM 사이즈별 상세 스펙 요약 ==="
echo ""

# PostgreSQL VM 스펙
echo "PostgreSQL: Standard_D2s_v3"
az vm list-sizes --location $LOCATION --query "[?name=='Standard_D2s_v3']" --output table
echo ""

# AKS 노드풀 VM 스펙
echo "AKS syspool & userpool: Standard_D2s_v5"
az vm list-sizes --location $LOCATION --query "[?name=='Standard_D2s_v5']" --output table
echo ""

echo "AKS memorypool: Standard_D4s_v5"
az vm list-sizes --location $LOCATION --query "[?name=='Standard_D4s_v5']" --output table
echo ""
