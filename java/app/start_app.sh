#!/usr/bin/env bash

# set -euo pipefail
# -e : 명령어가 하나라도 실패(exit code ≠ 0)하면 스크립트 전체 즉시 종료
# -u : 선언되지 않은 변수를 사용하려고 하면 에러로 처리
# -o pipefail : 파이프라인(|) 안에서 앞쪽 명령어가 실패하면 전체 파이프라인도 실패로 간주
#               (기본은 마지막 명령어의 exit code만 반환하므로 오류 누락 방지)

set -euo pipefail

APP_NAME="app"

echo "[INFO] stopping processes matching $APP_NAME ..."
# 실행중인 JAR 프로세스를 pkill로 종료
pkill -f "$APP_NAME.*\.jar" || true

# 프로세스 정리 확인
sleep 2
if pgrep -f "$APP_NAME.*\.jar" >/dev/null; then
  echo "[WARN] some processes still alive, force killing..."
  pkill -9 -f "$APP_NAME.*\.jar" || true
else
  echo "[OK] stopped"
fi
