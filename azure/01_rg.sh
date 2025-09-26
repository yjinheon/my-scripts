#!/usr/bin/env bash
set -euo pipefail

source .env

source helper.sh

info "리소스 그룹 생성/확인: $RG ($LOC)"
if az group exists -n "$RG" >/dev/null; then
  ok "이미 존재: $RG"
else
  az group create -n "$RG" -l "$LOC" >/dev/null
  wait_succeeded "az group show -n \"$RG\""
fi
az group show -n "$RG" -o table
