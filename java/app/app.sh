#!/usr/bin/env bash
set -euo pipefail

############################################
# USER SETTINGS
############################################
PROFILE="local"
APP_NAME="app"
JAR_PATH=""
JAVA_BIN="${JAVA_BIN:-java}" # jdk path
JAVA_OPTS="${JAVA_OPTS:-"-Xms512m -Xmx1024m -XX:+UseG1GC"}"

ENV_FILE="${ENV_FILE:-./common.env}"

############################################
# INTERNALS
############################################
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUN_DIR="$BASE_DIR/run"
LOG_DIR="$BASE_DIR/logs"
OUT_LOG="$LOG_DIR/${APP_NAME}.out"
PID_FILE="$RUN_DIR/${APP_NAME}.pid"

mkdir -p "$RUN_DIR" "$LOG_DIR"

load_env() {
  if [[ -f "$ENV_FILE" ]]; then
    # KEY=VALUE 형식 자동 export
    set -a
    # shellcheck disable=SC1090
    source "$ENV_FILE"
    set +a
    echo "[INFO] loaded env from $ENV_FILE"
  else
    echo "[INFO] env file not found ($ENV_FILE) — skipping"
  fi
}

resolve_jar() {
  if [[ -n "${JAR_PATH}" && -f "${JAR_PATH}" ]]; then
    echo "$JAR_PATH"
    return
  fi
  # 가장 최근 수정순
  local jar
  jar="$(ls -t "$BASE_DIR"/*.jar 2>/dev/null | head -n1 || true)"
  if [[ -z "$jar" ]]; then
    echo "[ERROR] No JAR found in $BASE_DIR and JAR_PATH is empty." >&2
    exit 1
  fi
  echo "$jar"
}

is_running() {
  if [[ -f "$PID_FILE" ]]; then
    local pid
    pid="$(cat "$PID_FILE" 2>/dev/null || true)"
    if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
      return 0
    fi
  fi
  return 1
}

start_app() {
  if is_running; then
    echo "[INFO] already running (pid=$(cat "$PID_FILE"))"
    return
  fi
  load_env
  local jar
  jar="$(resolve_jar)"

  # Spring 옵션
  local spring_opts=(
    "-Dspring.profiles.active=${PROFILE}"
  )

  # 서버 포트/컨텍스트 경로를 env에서 spring args로 넘기고 싶으면 아래 유지
  # (앱이 환경변수만 읽는다면 이 부분은 생략 가능)
  #  [[ -n "${SERVER_PORT:-}" ]] && spring_opts+=("--server.port=${SERVER_PORT}")
  #  [[ -n "${SERVER_CONTEXT_PATH:-}" ]] && spring_opts+=("--server.servlet.context-path=${SERVER_CONTEXT_PATH}")

  echo "[INFO] starting: $jar (profile=$PROFILE)"
  echo "[INFO] logs -> $OUT_LOG"

  nohup "$JAVA_BIN" $JAVA_OPTS "${spring_opts[@]}" -jar "$jar" \
    >>"$OUT_LOG" 2>&1 &

  echo $! >"$PID_FILE"
  sleep 0.5
  if is_running; then
    echo "[OK] started (pid=$(cat "$PID_FILE"))"
  else
    echo "[ERROR] start failed. Check logs: $OUT_LOG" >&2
    exit 1
  fi
}

stop_app() {
  if ! is_running; then
    echo "[INFO] not running"
    rm -f "$PID_FILE"
    return
  fi
  local pid
  pid="$(cat "$PID_FILE")"
  echo "[INFO] stopping pid=$pid ..."
  kill "$pid" 2>/dev/null || true

  # grace period
  for i in {1..30}; do
    if ! kill -0 "$pid" 2>/dev/null; then
      break
    fi
    sleep 1
  done
  if kill -0 "$pid" 2>/dev/null; then
    echo "[WARN] force kill pid=$pid"
    kill -9 "$pid" 2>/dev/null || true
    sleep 1
  fi
  rm -f "$PID_FILE"
  echo "[OK] stopped"
}

status_app() {
  if is_running; then
    echo "[OK] running (pid=$(cat "$PID_FILE"))"
  else
    echo "[INFO] not running"
  fi
}

tail_log() {
  touch "$OUT_LOG"
  tail -n 200 -f "$OUT_LOG"
}

print_env() {
  load_env
  echo "======== EFFECTIVE ENV ========"
  echo "PROFILE=$PROFILE"
  echo "JAVA_BIN=$JAVA_BIN"
  echo "JAVA_OPTS=$JAVA_OPTS"
  echo "SERVER_PORT=${SERVER_PORT:-}"
  echo "SERVER_CONTEXT_PATH=${SERVER_CONTEXT_PATH:-}"
  echo "LOGGING_PATH=${LOGGING_PATH:-$LOG_DIR}"
  echo "ALLOWED=${ALLOWED:-}"
  echo "UPLOAD_DIR=${UPLOAD_DIR:-}"
  echo "MANAGEMENT_ENDPOINTS=${MANAGEMENT_ENDPOINTS:-}"
  echo "================================"
}

usage() {
  cat <<EOF
Usage: $(basename "$0") {start|stop|restart|status|tail|env}
  start     Start application (loads $ENV_FILE if present)
  stop      Stop application
  restart   Stop then Start
  status    Show running status
  tail      Tail logs (last 200 lines)
  env       Print effective env (after loading $ENV_FILE)
Tips:
  - Change PROFILE at the top to set spring.profiles.active
  - Put/modify environment variables in $ENV_FILE
  - Override JAVA_BIN/JAVA_OPTS/ENV_FILE/JAR_PATH via environment
    ex) ENV_FILE=/path/custom.env JAR_PATH=./myapp.jar ./app.sh start
EOF
}

cmd="${1:-}"
case "${cmd}" in
start) start_app ;;
stop) stop_app ;;
restart)
  stop_app
  start_app
  ;;
status) status_app ;;
tail) tail_log ;;
env) print_env ;;
*)
  usage
  exit 1
  ;;
esac
