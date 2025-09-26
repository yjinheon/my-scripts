#!/usr/bin/env bash

set -euo pipefail

# 사용법: ./gen-selfsigned.sh [출력경로] [도메인]
# - 출력경로(default: 현재 디렉토리)
# - 도메인(Common Name, default: localhost)

OUT_DIR="${1:-$(pwd)}"
DOMAIN="${2:-localhost}"

CRT_FILE="$OUT_DIR/selfsigned.crt"
KEY_FILE="$OUT_DIR/selfsigned.key"

mkdir -p "$OUT_DIR"

echo "[INFO] Generating self-signed certificate"
echo " - Output Dir : $OUT_DIR"
echo " - Domain     : $DOMAIN"
echo " - CRT File   : $CRT_FILE"
echo " - KEY File   : $KEY_FILE"

# 3650일 = 10년짜리 self-signed 인증서
openssl req -x509 -nodes -days 3650 \
  -newkey rsa:2048 \
  -keyout "$KEY_FILE" \
  -out "$CRT_FILE" \
  -subj "/CN=$DOMAIN"

echo "[OK] Certificate and key generated:"
ls -l "$CRT_FILE" "$KEY_FILE"
