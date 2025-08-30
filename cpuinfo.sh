#!/usr/bin/env bash

# Simple CPU Frequency Performance Monitor
# Usage: ./cpu_monitor.sh [duration_seconds]

DURATION=${1:-30} # Default 30 seconds
LOG_FILE="cpu_freq_$(date +%Y%m%d_%H%M%S).log"

# Check if cpupower exists
if ! command -v cpupower &>/dev/null; then
  echo "Error: cpupower not found. Install with:"
  echo "  Ubuntu: sudo apt install linux-tools-common linux-tools-generic"
  echo "  CentOS: sudo yum install kernel-tools"
  exit 1
fi

# Get basic CPU info
echo "=== CPU Information ==="
echo "CPU Model: $(lscpu | grep 'Model name' | cut -d: -f2 | xargs)"
echo "CPU Cores: $(nproc)"
echo "Current Governor: $(cpupower frequency-info -p 2>/dev/null | grep -o '[a-z]*' | tail -1)"
echo "Frequency Range: $(cpupower frequency-info -l 2>/dev/null)"
echo ""

# Start monitoring
echo "=== Monitoring CPU Frequency for ${DURATION} seconds ==="
echo "Time,CPU,Frequency_MHz" >"$LOG_FILE"

START_TIME=$(date +%s)
END_TIME=$((START_TIME + DURATION))

while [ $(date +%s) -lt $END_TIME ]; do
  TIMESTAMP=$(date '+%H:%M:%S')

  # Get frequency for each CPU core
  for ((cpu = 0; cpu < $(nproc); cpu++)); do
    FREQ=$(cpupower -c $cpu frequency-info -f 2>/dev/null | grep -o '[0-9]*\.[0-9]* MHz\|[0-9]* MHz' | sed 's/ MHz//')

    if [ -n "$FREQ" ]; then
      echo "$TIMESTAMP,CPU$cpu,$FREQ" >>"$LOG_FILE"

      # Show only CPU0 on screen
      if [ $cpu -eq 0 ]; then
        printf "\r$TIMESTAMP - CPU0: $FREQ MHz"
      fi
    fi
  done

  sleep 1
done

echo ""
echo ""

# Calculate basic statistics
echo "=== Statistics ==="
awk -F',' 'NR>1 {
    freq = $3
    if (freq ~ /^[0-9]+\.?[0-9]*$/) {
        total += freq
        count++
        if (freq > max || max == "") max = freq
        if (freq < min || min == "") min = freq
    }
}
END {
    if (count > 0) {
        printf "Samples: %d\n", count
        printf "Average: %.1f MHz\n", total/count
        printf "Maximum: %.1f MHz\n", max
        printf "Minimum: %.1f MHz\n", min
        printf "Range: %.1f MHz\n", max-min
    }
}' "$LOG_FILE"

echo ""
echo "Data saved to: $LOG_FILE"
