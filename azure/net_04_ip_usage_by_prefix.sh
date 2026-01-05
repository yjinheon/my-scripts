#!/usr/bin/env bash
set -euo pipefail

# 사용 예:
RG="${RG:-scv}"
AKS_RG="${AKS_RG:-scv}"
AKS_NAME="${AKS_NAME:-}"

need() { command -v "$1" >/dev/null 2>&1 || {
  echo "Missing command: $1"
  exit 1
}; }
need az
need python3

if [[ -z "${AKS_NAME}" ]]; then
  echo "ERROR: AKS_NAME 환경변수가 필요합니다. 예) AKS_NAME=myaks $0"
  exit 1
fi

# 1) MC RG 탐색
MC_RG="$(az aks show -g "$RG" -n "$AKS_NAME" --query nodeResourceGroup -o tsv 2>/dev/null || true)"

echo "RG=$RG"
echo "MC_RG=${MC_RG:-<none>}"
echo

collect_nic_ips() {
  local rg="$1"
  az network nic list -g "$rg" \
    --query "[].ipConfigurations[].privateIpAddress" -o tsv 2>/dev/null || true
}

# 2) IP 수집
TMP_IPS="$(mktemp)"
trap 'rm -f "$TMP_IPS"' EXIT

collect_nic_ips "$RG" >>"$TMP_IPS"
if [[ -n "${MC_RG:-}" && "${MC_RG:-null}" != "null" ]]; then
  collect_nic_ips "$MC_RG" >>"$TMP_IPS"
fi

# 공백 라인 제거 + 정렬/중복 제거
sort -u "$TMP_IPS" | sed '/^\s*$/d' >"$TMP_IPS.sorted"

echo "Collected IP count: $(wc -l <"$TMP_IPS.sorted")"
echo

# 3) 분류(파이썬 파일 호출)
python3 ./classify_ips.py <"$TMP_IPS.sorted"
