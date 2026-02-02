#!/bin/bash

ENV_FILE="./.env"
if [ -f "$ENV_FILE" ]; then
    set -o allexport
    source "$ENV_FILE"
    set +o allexport
else
    echo "[Error] .env 파일이 없습니다."
    exit 1
fi

# jar 파일 존재 확인
if [ ! -f "$JAR_PATH" ]; then
    echo "[Error] $JAR_PATH 파일이 없습니다."
    exit 1
fi

echo "--------------------------------------------------"
echo "[Info] Jenkins Build & Log Stream"
echo "       Target: $JENKINS_URL"
echo "       Job   : $JOB_NAME"
echo "--------------------------------------------------"

# ==============================================================================
# [실행]
# 주의: 줄바꿈을 할 때는 반드시 줄 끝에 '\' (역슬래시)가 있어야 합니다.
#       주석(#)은 명령어 중간에 넣으면 끊길 수 있으니 주의하세요.
# ==============================================================================

java -jar "$JAR_PATH" \
    -s "$JENKINS_URL" \
    -auth "$JENKINS_USER:$JENKINS_PASS" \
    build "$JOB_NAME" \
    -s \
    -v \
    -p "$PARAM_KEY=$PARAM_VAL"

# 결과 처리
EXIT_CODE=$?
if [ $EXIT_CODE -eq 0 ]; then
    echo "--------------------------------------------------"
    echo "[Success] 빌드 성공"
else
    echo "--------------------------------------------------"
    echo "[Fail] 빌드 실패 (Code: $EXIT_CODE)"
fi
