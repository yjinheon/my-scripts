#!/usr/bin/env bash
set -euo pipefail

# NIC 기준 Effective NSG를 CLI로 보는 대표 명령이 az network nic list-effective-nsg

#source ./env.sh
source ./lib.sh

require_cmd az

MC_RG=$(get_mc_rg)
echo "MC_RG=$MC_RG"

# 노드 NIC(대부분 VMSS NIC)가 MC_RG에 있음
NICS=$(az network nic list -g "$MC_RG" --query "[].name" -o tsv)

for NIC in $NICS; do
  echo "=== Effective NSG on NIC: $NIC ==="
  az network nic list-effective-nsg -g "$MC_RG" -n "$NIC" -o table || true
  echo
done
