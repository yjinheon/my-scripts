#!/bin/bash

# Check if fcitx5 is running
if pgrep -x "fcitx5" >/dev/null; then
  echo "Fcitx5 is running. Stopping it now."
  pkill -x "fcitx5"
else
  echo "Fcitx5 is not running. Starting it now."
  nohup fcitx5 >/dev/null 2>&1 &
fi
