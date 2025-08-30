#!/usr/bin/env bash

echo "Stopping Hive Metastore..."

export HIVE_PORT="9083"

PID=$(lsof -ti:$HIVE_PORT 2>/dev/null)

if [ -n "$PID" ]; then
  echo "Stopping process with PORT (PID: $PID)"
  kill $PID
  sleep 2

  if kill -0 $PID 2>/dev/null; then
    echo "force kill.."
    kill -9 $PID
  fi
  echo "Hive Metastore server stopped successfully"
else
  echo "No Hive Metastore server running on port $HIVE_PORT"
fi
