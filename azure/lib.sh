#!/usr/bin/env bash
set -euo pipefail

require_cmd() { command -v "$1" >/dev/null 2>&1 || {
  echo "Missing: $1"
  exit 1
}; }
#az_sub() { az account set --subscription "$SUBSCRIPTION_ID" >/dev/null; }

get_mc_rg() {
  az aks show -g "$RG" -n "$AKS_NAME" --query nodeResourceGroup -o tsv
}

jsonc() { az "$@" -o jsonc; }
table() { az "$@" -o table; }
