#!/usr/bin/env bash

set -euo pipefail
command -v az >/dev/null || {
  echo "Need Azure CLI (az)"
  exit 1
}

: "${RG:?Set RG (resource group name)}"

SUB_ID="${SUB_ID:-$(az account show --query id -o tsv)}"
SCOPE_RG="/subscriptions/${SUB_ID}/resourceGroups/${RG}"

# Resolve assignee Object ID
if [[ -n "${PRINCIPAL_ID:-}" ]]; then
  ASSIGNEE_OID="$PRINCIPAL_ID"
elif [[ -n "${USER_UPN:-}" ]]; then
  ASSIGNEE_OID="$(az ad user show --id "$USER_UPN" --query id -o tsv)"
else
  ASSIGNEE_OID="$(az ad signed-in-user show --query id -o tsv)"
fi
[[ -n "$ASSIGNEE_OID" ]] || {
  echo "Cannot resolve principal Object ID"
  exit 2
}

echo "SUB_ID       : $SUB_ID"
echo "RG           : $RG"
echo "ASSIGNEE_OID : $ASSIGNEE_OID"

assign_role() {
  local role="$1" scope="$2"
  # idempotent check (no --assignee-principal-type)
  local has
  has="$(az role assignment list \
    --assignee-object-id "$ASSIGNEE_OID" \
    --scope "$scope" \
    --query "[?roleDefinitionName=='$role'] | length(@)" -o tsv || echo 0)"
  if [[ "$has" == "0" ]]; then
    echo "Granting '$role' @ $scope"
    az role assignment create \
      --assignee-object-id "$ASSIGNEE_OID" \
      --role "$role" \
      --scope "$scope" >/dev/null
  else
    echo "Already has '$role' @ $scope"
  fi
}

# 1) RG-level Contributor
assign_role "Contributor" "$SCOPE_RG"

# 2) Storage Blob Data Contributor (optional)
if [[ -n "${ST_ACCOUNT:-}" ]]; then
  SCOPE_STORAGE="/subscriptions/${SUB_ID}/resourceGroups/${RG}/providers/Microsoft.Storage/storageAccounts/${ST_ACCOUNT}"
  assign_role "Storage Blob Data Contributor" "$SCOPE_STORAGE"
else
  echo "Skip Storage (ST_ACCOUNT not set)"
fi

# # 3) Key Vault Secrets User (optional)
# if [[ -n "${KV_NAME:-}" ]]; then
#   SCOPE_KV="/subscriptions/${SUB_ID}/resourceGroups/${RG}/providers/Microsoft.KeyVault/vaults/${KV_NAME}"
#   assign_role "Key Vault Secrets User" "$SCOPE_KV"
# else
#   echo "Skip Key Vault (KV_NAME not set)"
# fi

# 4) AKS Cluster User Role (optional)
if [[ -n "${AKS_NAME:-}" ]]; then
  SCOPE_AKS="/subscriptions/${SUB_ID}/resourceGroups/${RG}/providers/Microsoft.ContainerService/managedClusters/${AKS_NAME}"
  assign_role "Azure Kubernetes Service Cluster User Role" "$SCOPE_AKS"
else
  echo "Skip AKS (AKS_NAME not set)"
fi

# # 5) Private Network scope (optional) – prefer subnet over vnet
# if [[ -n "${SUBNET_ID:-}" ]]; then
#   assign_role "Network Contributor" "$SUBNET_ID"
# elif [[ -n "${VNET_ID:-}" ]]; then
#   assign_role "Network Contributor" "$VNET_ID"
# else
#   echo "Skip Network (SUBNET_ID/VNET_ID not set)"
# fi

echo "Done."
