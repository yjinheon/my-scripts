set -euo pipefail
source ./.env

# APP 서브넷 ID 로드
APP_SUBNET_ID=$(az network vnet subnet show -g "$RG" --vnet-name "$VNET" \
  -n "$SUBNET_APP_NAME" --query id -o tsv)

echo $APP_SUBNET_ID

echo "== AKS 생성 시작 =="

az aks nodepool add \
  --resource-group "$RG" \
  --cluster-name "$CLUSTER" \
  --name "${USERPOOL:-userpool}" \
  --mode User \
  --node-count 2 \
  --node-vm-size "${NODE_SIZE:-Standard_D2s_v5}" \
  --enable-cluster-autoscaler --min-count 1 --max-count 5 \
  --labels workload=gateway \
  --max-pods 110
echo "== kubeconfig 머지 =="

az aks get-credentials -g "$RG" -n "$CLUSTER" --overwrite-existing

echo "== 클러스터 생성 완료 =="
kubectl get nodes -o wide
