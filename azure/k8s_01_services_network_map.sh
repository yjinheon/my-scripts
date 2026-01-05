#!/usr/bin/env bash

# 서비스타입별 + LB External/Internal IP 요약
set -euo pipefail

echo "=== Services (all namespaces) ==="
kubectl get svc -A -o wide

echo
echo "=== LoadBalancer services (with annotations) ==="
kubectl get svc -A --field-selector spec.type=LoadBalancer -o jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\t"}{.status.loadBalancer.ingress[0].ip}{"\t"}{.spec.clusterIP}{"\t"}{.metadata.annotations}{"\n"}{end}'
