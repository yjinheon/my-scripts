#!/usr/bin/env bash

set -euo pipefail

# Namespace argument or default
NAMESPACE="${1:-default}"

# Pod selection
POD=$(
  kubectl get pods -n "$NAMESPACE" |
    awk 'NR>1 {print $1}' | # NR>1 Number of Record 가 1보다 큰 경우 첫번째 줄 건너뛰고  두번째 부터
    fzf --prompt="Select Pod> "
)

if [[ -z "$POD" ]]; then
  echo "No Pod selected."
  exit 1
fi

echo "Selected Pod: $POD"
echo "Streaming logs..."
echo "-------------------------------------------"

kubectl logs -f -n "$NAMESPACE" "$POD"
