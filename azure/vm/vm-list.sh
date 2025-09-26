#!/usr/bin/env bash
set -euo pipefail

source .env

# (선택) .env 에 RG, LOC 등을 두고 쓰는 경우
if [[ -f .env ]]; then source .env; fi

USAGE="Usage: $0 [--all]  # default: current RG only"
ALL="${1:-}"

if [[ "$ALL" == "--all" ]]; then
  # 구독 내 모든 리소스그룹의 VM
  az vm list -d \
    --query '[].{name:name, rg:resourceGroup, location:location, size:hardwareProfile.vmSize, power:powerState, privateIp:privateIps, publicIp:publicIps}' \
    -o table
else
  : "${RG:?Set RG in .env or export RG=<resource-group>}"
  az vm list -g "$RG" -d \
    --query '[].{name:name, rg:resourceGroup, location:location, size:hardwareProfile.vmSize, power:powerState, privateIp:privateIps, publicIp:publicIps}' \
    -o table
fi
