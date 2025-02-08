#!/bin/bash

# 결과를 저장할 임시 파일 생성
output_file=$(mktemp)

# 헤더 추가
echo "=== Kernel Parameters for Kafka Performance ===" >$output_file
echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')" >>$output_file
echo "" >>$output_file

# 네트워크 파라미터 확인
echo "=== Network Parameters ===" >>$output_file
parameters=(
  "net.core.wmem_default"
  "net.core.wmem_max"
  "net.core.rmem_default"
  "net.core.rmem_max"
  "net.ipv4.tcp_wmem"
  "net.ipv4.tcp_rmem"
  "net.ipv4.tcp_max_syn_backlog"
)

for param in "${parameters[@]}"; do
  value=$(sysctl -n $param 2>/dev/null)
  if [ $? -eq 0 ]; then
    printf "%-35s = %s\n" "$param" "$value" >>$output_file
  else
    printf "%-35s = Not found\n" "$param" >>$output_file
  fi
done

# VM 파라미터 확인
echo -e "\n=== VM Parameters ===" >>$output_file
vm_parameters=(
  "vm.swappiness"
  "vm.dirty_ratio"
  "vm.dirty_background_ratio"
)

for param in "${vm_parameters[@]}"; do
  value=$(sysctl -n $param 2>/dev/null)
  if [ $? -eq 0 ]; then
    printf "%-35s = %s\n" "$param" "$value" >>$output_file
  else
    printf "%-35s = Not found\n" "$param" >>$output_file
  fi
done

# 파일시스템 파라미터 확인
echo -e "\n=== Filesystem Parameters ===" >>$output_file
fs_parameters=(
  "fs.file-max"
)

for param in "${fs_parameters[@]}"; do
  value=$(sysctl -n $param 2>/dev/null)
  if [ $? -eq 0 ]; then
    printf "%-35s = %s\n" "$param" "$value" >>$output_file
  else
    printf "%-35s = Not found\n" "$param" >>$output_file
  fi
done

# /proc/vmstat에서 더티 페이지 정보 추출
echo -e "\n=== Dirty Pages Information ===" >>$output_file
if [ -f /proc/vmstat ]; then
  echo "Current dirty pages:" >>$output_file
  grep -E "nr_dirty|nr_writeback|nr_writeback_temp" /proc/vmstat |
    while read line; do
      name=$(echo $line | cut -d' ' -f1)
      value=$(echo $line | cut -d' ' -f2)
      # Convert pages to KB (assuming 4KB page size)
      kb=$((value * 4))
      mb=$(echo "scale=2; $kb/1024" | bc)
      printf "%-20s = %10d pages (%8.2f MB)\n" "$name" "$value" "$mb" >>$output_file
    done
else
  echo "Cannot access /proc/vmstat" >>$output_file
fi

# bat으로 출력 (bat이 설치되어 있지 않은 경우 cat으로 폴백)
if command -v bat &>/dev/null; then
  bat --style=plain $output_file
else
  cat $output_file
fi

# 임시 파일 삭제
rm $output_file
