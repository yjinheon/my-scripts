#!/usr/bin/env bash

#az aks update -g "$RG" -n "$AKS" --attach-acr "$ACR"

KUBELET_OID=$(az aks show -g "$RG" -n "$CLUSTER" --query 'identityProfile.kubeletidentity.objectId' -o tsv)
ACR_ID=$(az acr show -n "$ACR" --query id -o tsv)

echo "kubelet OID: $KUBELET_OID"
echo "ACR ID:      $ACR_ID"

az role assignment create \
  --assignee "$KUBELET_OID" \
  --role "AcrPull" \
  --scope "$ACR_ID"
