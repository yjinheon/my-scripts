#!/usr/bin/env bash

# set -euo pipefail
# -e : 명령어가 하나라도 실패(exit code ≠ 0)하면 스크립트 전체 즉시 종료
# -u : 선언되지 않은 변수를 사용하려고 하면 에러로 처리
# -o pipefail : 파이프라인(|) 안에서 앞쪽 명령어가 실패하면 전체 파이프라인도 실패로 간주
#               (기본은 마지막 명령어의 exit code만 반환하므로 오류 누락 방지)

set -euo pipefail

APP_DIR="${APP_DIR:-/app}"
APP_NAME="${APP_NAME:-myapp}"
PROFILE="${PROFILE:-dev}"
JAVA_OPTS="${JAVA_OPTS:-"-Xmx512m -Xms256m"}"

JAR_FILE="${APP_DIR}/${APP_NAME}.jar"
LOG_FILE="${APP_DIR}/log/${APP_NAME}-${PROFILE}.log"

echo "[INFO] App restart script starting..."
echo "[INFO] APP_DIR: $APP_DIR"
echo "[INFO] APP_NAME: $APP_NAME"
echo "[INFO] PROFILE: $PROFILE"
echo "[INFO] JAVA_OPTS: $JAVA_OPTS"
echo "[INFO] JAR_FILE: $JAR_FILE"

# JAR 파일 존재 확인
if [ ! -f "$JAR_FILE" ]; then
  echo "[ERROR] JAR file not found: $JAR_FILE"
  exit 1
fi

# 1. 기존 프로세스 종료
echo "[INFO] Stopping processes matching $APP_NAME ..."
pkill -f "$APP_NAME.*\.jar" || true

# 2. 프로세스 정리 확인
sleep 2
if pgrep -f "$APP_NAME.*\.jar" >/dev/null; then
  echo "[WARN] Some processes still alive, force killing..."
  pkill -9 -f "$APP_NAME.*\.jar" || true
  sleep 1

  # 강제 종료 후에도 살아있는지 재확인
  if pgrep -f "$APP_NAME.*\.jar" >/dev/null; then
    echo "[ERROR] Failed to kill processes"
    exit 1
  fi
fi

echo "[OK] All processes stopped"

# 3. 로그 디렉토리 생성 (필요시)
mkdir -p "$(dirname "$LOG_FILE")"

# 4. 새 프로세스 시작
echo "[INFO] Starting $APP_NAME ..."
cd "$APP_DIR"

# nohup으로 백그라운드 실행
nohup java $JAVA_OPTS -Dspring.profiles.active=$PROFILE -jar "$JAR_FILE" >"$LOG_FILE" 2>&1 &
NEW_PID=$!

# 프로세스 시작 확인
sleep 3
if kill -0 $NEW_PID 2>/dev/null; then
  echo "[OK] $APP_NAME started successfully with profile '$PROFILE' (PID: $NEW_PID)"
  echo "[INFO] Log file: $LOG_FILE"
else
  echo "[ERROR] Failed to start $APP_NAME with profile '$PROFILE'"
  echo "[INFO] Check log file: $LOG_FILE"
  exit 1
fi

echo "[INFO] App restart completed successfully (profile: $PROFILE)"
