#!/usr/bin/env bash

ENV_FILE="./.env"
if [ -f "$ENV_FILE" ]; then
    set -o allexport
    source "$ENV_FILE"
    set +o allexport
else
    echo "[Error] .env 파일이 없습니다."
    exit 1
fi

JENKINS_URL=${JENKINS_URL%/}

echo "--------------------------------------------------"
echo "[Step 1] Crumb(토큰) 발급 시도..."
# 1. Crumb 데이터만 깔끔하게 가져오기
CRUMB_DATA=$(curl -s -u "$JENKINS_USER:$JENKINS_PASS" \
    "$JENKINS_URL/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")

# Crumb 성공 여부 체크
if [[ "$CRUMB_DATA" == *"Jenkins-Crumb"* ]]; then
    echo "       Crumb 획득 성공."
    HEADER_FLAG="-H"
    HEADER_VAL="$CRUMB_DATA"
else
    echo "       [Warning] Crumb 획득 실패 또는 필요 없음."
    # 빈 값으로 설정하여 curl 명령어가 깨지지 않게 함
    HEADER_FLAG="-H"
    HEADER_VAL="X-Jenkins-Placeholder: true" 
fi

echo "--------------------------------------------------"
echo "[Step 2] 빌드 요청 전송"
echo "       Target: $JENKINS_URL/job/$JOB_NAME/buildWithParameters"

# 2. Jenkins call
curl -v -f -X POST \
    -u "$JENKINS_USER:$JENKINS_PASS" \
    "$HEADER_FLAG" "$HEADER_VAL" \
    --data "$PARAM_KEY=$PARAM_VAL" \
    "$JENKINS_URL/job/$JOB_NAME/buildWithParameters"

EXIT_CODE=$?
if [ $EXIT_CODE -eq 0 ]; then
    echo ""
    echo "[Success] 빌드 요청 성공!"
else
    echo ""
    echo "[Fail] 요청 실패 (Code: $EXIT_CODE)"
    echo "       만약 이번에도 403이라면, 비밀번호 대신 'API Token'을 써야 합니다."
fi
