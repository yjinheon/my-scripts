#!/usr/bin/env bash

set -euo pipefail

export HIVE_PORT="9083"

PID=$(lsof -ti:$HIVE_PORT 2>/dev/null)

if [ -n "$PID" ]; then
  echo "Running (PID: $PID)"
  if netstat -tlnp 2>/dev/null | grep ":9083 " >/dev/null; then
    echo "Port 9083: listening"
  else
    echo "Port 9083: not listening"
  fi
else
  echo "Not running"
  rm -f ./hive-metastore.pid
fi
