#!/usr/bin/env python3
import ipaddress
import sys

prefixes = [
    ipaddress.ip_network("10.10.0.0/24"),
    ipaddress.ip_network("10.0.0.0/16"),
    ipaddress.ip_network("10.1.0.0/16"),
]

labels = {str(n): [] for n in prefixes}
labels["OTHER"] = []

ips = [line.strip() for line in sys.stdin if line.strip()]

for ip in ips:
    try:
        addr = ipaddress.ip_address(ip)
    except ValueError:
        labels["OTHER"].append(ip)
        continue

    hit = False
    for n in prefixes:
        if addr in n:
            labels[str(n)].append(ip)
            hit = True
            break
    if not hit:
        labels["OTHER"].append(ip)

# 출력 순서 고정
order = [str(n) for n in prefixes] + ["OTHER"]
for k in order:
    print(f"=== {k} ({len(labels[k])}) ===")
    for ip in sorted(set(labels[k])):
        print(ip)
    print()
