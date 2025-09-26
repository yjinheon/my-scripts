#!/usr/bin/env bash

set -euo pipefail

APP_NAME="SOME_APP_NAME"

echo "[INFO] stopping processes matching $APP_NAME ..."
pkill -f "$APP_NAME.*\.jar" || true

# 프로세스 정리 확인
sleep 2
if pgrep -f "$APP_NAME.*\.jar" >/dev/null; then
  echo "[WARN] some processes still alive, force killing..."
  pkill -9 -f "$APP_NAME.*\.jar" || true
else
  echo "[OK] stopped"
fi
