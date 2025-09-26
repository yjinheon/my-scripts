#!/usr/bin/env bash

set -eo pipefail

source .env

VM_NAME="${1:?Usage: $0 <vm-name>}"
IMG="${IMG:-Ubuntu2204}"
SIZE="${SIZE:-Standard_D2s_v3}"
NIC_NAME="${VM_NAME}-nic"
PIP_NAME="${VM_NAME}-pip"

# Public IP
az network public-ip create \
  --resource-group "$RG" \
  --name "$PIP_NAME" \
  --location "$LOC" \
  --sku Standard \
  --allocation-method Static >/dev/null

# NIC (Public Subnet + nsg-public)
az network nic create \
  --resource-group "$RG" \
  --name "$NIC_NAME" \
  --vnet-name "$VNET" \
  --subnet "$SUBNET_PUBLIC_NAME" \
  --network-security-group "$NSG_PUBLIC" \
  --public-ip-address "$PIP_NAME" >/dev/null

# VM
az vm create \
  --resource-group "$RG" \
  --name "$VM_NAME" \
  --location "$LOC" \
  --image "$IMG" \
  --size "$SIZE" \
  --admin-username "$ADMIN_USER" \
  --ssh-key-values "$SSH_PUBKEY_PATH" \
  --nics "$NIC_NAME" >/dev/null

# show result
az vm show -g "$RG" -n "$VM_NAME" -d \
  --query "{name:name,publicIp:publicIps,privateIp:privateIps}" -o table
