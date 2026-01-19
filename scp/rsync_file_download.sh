#!/usr/bin/env bash

source .gw.env

LOCAL_TARGET=${1:-.}
TARGET_PORT=${PORT:-22}

# rsync 실행 (원격지 -> 로컬)
# --exclude: .gw.env에서 지정한 폴더 제외
# -e "ssh -p ...": SSH 포트 지정
sshpass -p "$PASS" rsync -av \
    --exclude "$EXCLUDE_DIR" \
    -e "ssh -p $TARGET_PORT -o StrictHostKeyChecking=no" \
    "$USER@$HOST:$REMOTE_PATH" \
    "$LOCAL_TARGET"
