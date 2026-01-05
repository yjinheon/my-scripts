#!/usr/bin/env bash
set -euo pipefail
command -v kubectl >/dev/null

# ingress-nginx-controller Service가 type: LoadBalancer면 → Azure LB(공인/사설) 프론트 IP가 생김
# 어노테이션에 service.beta.kubernetes.io/azure-load-balancer-internal: "true" 같은 게 있으면 Internal LB(사설망 진입) 임

echo "=== Ingresses (all namespaces) ==="
kubectl get ingress -A -o wide

echo
echo "=== IngressClass ==="
kubectl get ingressclass -o wide || true

echo
echo "=== NGINX Ingress Controller Service candidates ==="
# 보통 ingress-nginx 네임스페이스에 존재
kubectl get svc -A -o wide | egrep -i 'ingress-nginx|nginx.*controller' || true

echo
echo "=== Try common svc names (ingress-nginx-controller) ==="
kubectl -n ingress-nginx get svc ingress-nginx-controller -o yaml 2>/dev/null || true
kubectl -n ingress-nginx get svc ingress-nginx-controller -o wide 2>/dev/null || true

echo
echo "=== LB annotations (internal/external 여부) ==="
kubectl -n ingress-nginx get svc ingress-nginx-controller -o jsonpath='{.metadata.annotations}{"\n"}' 2>/dev/null || true

echo
echo "=== External IP of controller LB ==="
kubectl -n ingress-nginx get svc ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}{"\n"}' 2>/dev/null || true
