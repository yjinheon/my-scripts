#!/usr/bin/env bash

source .gw.env

LOCAL_FILE=${1:-$HOME}
TARGET_PORT=${PORT:-22}

# -p: 비밀번호 직접 주입 (환경변수 PASS 사용)
# -o StrictHostKeyChecking=no: 호스트 키 확인 건너뛰기
sshpass -p "$PASS" scp -P "$TARGET_PORT" -r -o StrictHostKeyChecking=no "$USER@$HOST:$REMOTE_PATH" "$LOCAL_FILE"


