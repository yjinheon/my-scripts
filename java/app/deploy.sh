#!/usr/bin/env bash

set -euo pipefail

### ===== 환경 변수 설정 =====
APP_NAME="test"
APP_VERSION="1.0.0"
APP_PROFILE="dev"

SRC_DIR="../build/libs"
DEST_DIR="/app/"
TMP_DIR="../app"

JAR_NAME="${APP_NAME}-${APP_VERSION}.jar"
JAR_PATH="${DEST_DIR}/${JAR_NAME}"
LOG_FILE="${DEST_DIR}/app.log"

TIMEOUT=10
### ==========================

echo "=== 배포 시작: $(date) ==="

echo "=== 기존 프로세스 종료 ==="
pkill -f "${JAR_NAME}" || true
echo "=== 프로세스 종료 대기 ==="

if pgrep -f "${JAR_NAME}" >/dev/null; then
  echo "아직 종료 안 됨 → 강제 종료"
  pkill -KILL -f "${JAR_NAME}"
fi

echo "=== 기존 프로세스 종료 완료 ==="

echo "=== JAR 파일 이동 ==="
mv "${SRC_DIR}/${JAR_NAME}" "${JAR_PATH}"

echo "=== 임시 디렉토리 정리 ==="
rm -rf "${TMP_DIR}"

echo "=== 애플리케이션 실행 ==="
nohup java -jar -Dspring.profiles.active="${APP_PROFILE}" "${JAR_PATH}" >"${LOG_FILE}" 2>&1 &

echo "=== 실행 확인 ==="
sleep 2

if pgrep -f "${JAR_NAME}" >/dev/null; then
  echo "프로세스 정상 실행 확인"
  echo "=== 배포 완료: $(date) ==="
else
  echo "프로세스 실행 실패!"
  ps aux | grep "${APP_NAME}" | grep -v grep || echo '관련 프로세스 없음'
  exit 1
fi

echo "=== 배포 완료: $(date) ==="
