#!/usr/bin/env bash

# 사용할 리소스 그룹명
RESOURCE_GROUP="scv"
# 리전 (필요시 Korea Central 로 변경 가능)
LOCATION="koreacentral"
# Loki용 Storage Account 이름 (소문자만, 3~24자, 전역 유니크)
STORAGE_ACCOUNT="scvlokistorage"
# 컨테이너명들
CONTAINERS=("chunks" "ruler" "admin")

# ============================================================
echo " Loki Azure Blob 환경 설정 시작..."
echo "-------------------------------------"

# (1) Resource Group 존재 여부 확인
if az group show --name "$RESOURCE_GROUP" &>/dev/null; then
  echo " Resource Group [$RESOURCE_GROUP] 이미 존재함"
else
  echo " Resource Group [$RESOURCE_GROUP] 생성 중..."
  az group create --name "$RESOURCE_GROUP" --location "$LOCATION"
fi

# (2) Storage Account 존재 여부 확인
if az storage account show -g "$RESOURCE_GROUP" -n "$STORAGE_ACCOUNT" &>/dev/null; then
  echo "Storage Account [$STORAGE_ACCOUNT] 이미 존재함"
else
  echo "🪄 Storage Account [$STORAGE_ACCOUNT] 생성 중..."
  az storage account create \
    --name "$STORAGE_ACCOUNT" \
    --resource-group "$RESOURCE_GROUP" \
    --location "$LOCATION" \
    --sku Standard_LRS \
    --kind StorageV2 \
    --allow-blob-public-access false
fi

# (3) Access Key 가져오기
ACCOUNT_KEY=$(az storage account keys list \
  --resource-group "$RESOURCE_GROUP" \
  --account-name "$STORAGE_ACCOUNT" \
  --query "[0].value" -o tsv)

# (4) Connection String 가져오기
CONNECTION_STRING=$(az storage account show-connection-string \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  -o tsv)

# (5) Blob Container 존재 여부 확인 및 생성
for c in "${CONTAINERS[@]}"; do
  echo "📦 컨테이너 [$c] 확인 중..."
  if az storage container show \
    --name "$c" \
    --account-name "$STORAGE_ACCOUNT" \
    --account-key "$ACCOUNT_KEY" &>/dev/null; then
    echo "   ✅ [$c] 이미 존재함"
  else
    echo "   🪄 [$c] 생성 중..."
    az storage container create \
      --name "$c" \
      --account-name "$STORAGE_ACCOUNT" \
      --account-key "$ACCOUNT_KEY" \
      --public-access off
  fi
done

# (6) 결과 출력
echo
echo "생성/확인 완료!"
echo "-------------------------------------"
echo "🔹 Resource Group : $RESOURCE_GROUP"
echo "🔹 Location        : $LOCATION"
echo "🔹 Storage Account : $STORAGE_ACCOUNT"
echo
echo "Access Key:"
echo "$ACCOUNT_KEY"
echo
echo "Connection String:"
echo "$CONNECTION_STRING"
echo
echo "Loki Helm values.yaml 예시:"
cat <<EOF
loki:
  auth_enabled: false
  storage:
    type: azure
    azure:
      accountName: $STORAGE_ACCOUNT
      accountKey: $ACCOUNT_KEY
      connectionString: $CONNECTION_STRING
      useManagedIdentity: false
      endpointSuffix: core.windows.net
    bucketNames:
      chunks: "chunks"
      ruler: "ruler"
      admin: "admin"
EOF

echo
echo "🎯 위 정보를 loki/values.yaml에 반영하세요."
echo "-------------------------------------"
