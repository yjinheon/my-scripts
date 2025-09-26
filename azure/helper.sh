#!/usr/bin/env bash

# 쉘 안전 옵션
set -euo pipefail

# 공용 헬퍼: 상태 출력
function ok() { echo -e "\e[32m[OK]\e[0m $*"; }
function info() { echo -e "\e[34m[INFO]\e[0m $*"; }
function warn() { echo -e "\e[33m[WARN]\e[0m $*"; }

# 공용 헬퍼: 리소스 프로비저닝 상태 대기
# $1 = az show 명령 (따옴표 포함), 예: 'az group show -n "$RG"'
function wait_succeeded() {
  local show_cmd="$1"
  local timeout="${2:-300}" # default 5m
  local start t=0 state="Unknown"
  start=$(date +%s)
  while true; do
    # shellcheck disable=SC2086
    state=$(eval $show_cmd --query "properties.provisioningState" -o tsv 2>/dev/null || echo "Unknown")
    [[ "$state" == "Succeeded" ]] && {
      ok "ProvisioningState=Succeeded"
      return 0
    }
    t=$(($(date +%s) - start))
    [[ $t -ge $timeout ]] && {
      warn "Timeout waiting for Succeeded (last=$state)"
      return 1
    }
    sleep 5
  done
}
