#!/usr/bin/env bash
# 네트워크 플러그인은 Azure CNI Overlay

set -euo pipefail
source ./.env

# APP 서브넷 ID 로드
APP_SUBNET_ID=$(az network vnet subnet show -g "$RG" --vnet-name "$VNET" \
  -n "$SUBNET_APP_NAME" --query id -o tsv)

echo $APP_SUBNET_ID

echo "== AKS 생성 시작 =="
az aks create \
  -g "$RG" -n "$CLUSTER" \
  --enable-managed-identity \
  --network-plugin azure \
  --network-plugin-mode overlay \
  --vnet-subnet-id "$APP_SUBNET_ID" \
  --nodepool-name "$SYSPOOL" \
  --node-vm-size "$NODE_SIZE" \
  --node-count 1 \
  --enable-cluster-autoscaler --min-count 1 --max-count 3 \
  --node-osdisk-size 64 \
  --generate-ssh-keys

echo "== kubeconfig 머지 =="
az aks get-credentials -g "$RG" -n "$CLUSTER" --overwrite-existing

echo "== 시스템 풀에 '시스템 전용' taint 부여 =="
# 시스템 파드만 들어오도록 taint 설정 app pod 는 user/spot pool로
kubectl taint nodes -l agentpool="$SYSPOOL" node-role.kubernetes.io/system=true:NoSchedule || true

echo "== 클러스터 생성 완료 =="
kubectl get nodes -o wide
