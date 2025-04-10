#!/bin/bash

echo "=== Kernel Parameters for Kafka Performance ==="
echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

echo "=== Network Parameters ==="
echo "net.core.wmem_default : "
sysctl -n net.core.wmem_default
echo "net.core.wmem_max : "
sysctl -n net.core.wmem_max
sysctl -n net.core.rmem_default
sysctl -n net.core.rmem_max
sysctl -n net.ipv4.tcp_wmem
sysctl -n net.ipv4.tcp_rmem
sysctl -n net.ipv4.tcp_max_syn_backlog

echo ""
echo "=== VM Parameters ==="
sysctl -n vm.swappiness
echo "=== dirty_ratio : ==="
sysctl -n vm.dirty_ratio
echo "=== dirty_background_ratio : ==="
sysctl -n vm.dirty_background_ratio

echo ""
echo "=== Filesystem Parameters ==="
sysctl -n fs.file-max

echo ""
echo "=== Dirty Pages Information ==="
grep -E "nr_dirty|nr_writeback|nr_writeback_temp" /proc/vmstat
