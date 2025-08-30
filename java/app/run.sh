#!/bin/bash

APP_JAR="EXAMPLE-1.0.0"
JAR_NAME="$APP_JAR.jar"

# 현재 디렉토리
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMON_ENV="$BASE_DIR/../common.env"

# 1. 공통 환경변수 로딩
[ -f "$COMMON_ENV" ] && source "$COMMON_ENV"

# 2. 디렉토리 생성
[ -n "$LOG_PATH" ] && mkdir -p "$LOG_PATH"
[ -n "$UPLOAD_PATH" ] && mkdir -p "$UPLOAD_PATH"
[ -n "$IMG_PATH" ] && mkdir -p "$IMG_PATH"

# 1. 기존 프로세스 종료
PIDS=$(ps -ef | grep "[j]ava -jar $JAR_NAME" | awk '{print $2}')

if [ -n "$PIDS" ]; then
  echo "기존 프로세스 종료 중..."
  for PID in $PIDS; do
    echo "  → kill PID=$PID"
    kill $PID
    sleep 2
    if ps -p $PID >/dev/null; then
      echo "  → SIGKILL 강제 종료: PID=$PID"
      kill -9 $PID
    fi
  done
else
  echo "기존 실행 중인 프로세스 없음"
fi

# 2. 새 프로세스 실행
nohup java -jar "$JAR_NAME" >./nohup/app.log 2>&1 &
NEW_PID=$!
echo "[$APP_JAR] 새 프로세스 실행: PID=$NEW_PID"

# 3. 실행 확인
sleep 1
if ps -p $NEW_PID >/dev/null; then
  echo "[$APP_JAR] 프로세스 정상 실행 확인"
else
  echo "[$APP_JAR] 프로세스 실행 실패!"
fi

#testuser1@aedata.co.kr
testuser1!
