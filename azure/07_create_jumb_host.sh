#!/usr/bin/env bash

set -euo pipefail
source .env

# 내 공인 IP만 SSH 허용하도록 nsg-public 규칙(이미 있으면 생략)
MYIP="$(curl -s ifconfig.me)/32"
az network nsg rule show -g "$RG" --nsg-name nsg-public -n allow-ssh-myip >/dev/null 2>&1 ||
  az network nsg rule create -g "$RG" --nsg-name nsg-public -n allow-ssh-myip \
    --priority 120 --access Allow --direction Inbound --protocol Tcp \
    --destination-port-ranges 22 --source-address-prefixes "$MYIP" >/dev/null

echo "Setting nsg public done"

# 가장 저렴한 스펙: B2ts + Spot(가격상한 무제한) + Standard HDD
az vm create \
  -g "$RG" -n "$JUMP_VM" -l "$LOC" \
  --image "Ubuntu2204" \
  --size "Standard_B2ts_v2" \
  --priority "Spot" --eviction-policy "Deallocate" \
  --public-ip-sku "Standard" \
  --vnet-name "$VNET" --subnet "$SUBNET_PUBLIC_NAME" \
  --admin-username "$ADMIN_USER" \
  --ssh-key-values @"$SSH_PUBKEY_PATH" \
  --os-disk-size-gb 30 --storage-sku Standard_LRS

# 결과 출력
az vm show -g "$RG" -n "$JUMP_VM" -d \
  --query "{name:name,publicIp:publicIps,privateIp:privateIps,size:hardwareProfile.vmSize}" -o table

# # VM의 NIC 이름 가져오기
# nic=$(az vm show -g "$RG" -n "$JUMP_VM" \
#   --query "networkProfile.networkInterfaces[0].id" -o tsv | awk -F/ '{print $NF}')
#
# # NSG 붙이기
# az network nic update -g "$RG" -n "$nic" \
#   --network-security-group nsg-public

# SUBNET_PUBLIC_NAME 서브넷 안의  모든 VM NIC가 nsg-public을 따르게 업데이트
nic_id=$(az vm show -g "$RG" -n "$JUMP_VM" \
  --query "networkProfile.networkInterfaces[0].id" -o tsv)
nic_name=$(basename "$nic_id")

# 2. NIC에 붙은 NSG 이름 확인
nsg_id=$(az network nic show -g "$RG" -n "$nic_name" \
  --query "networkSecurityGroup.id" -o tsv)
nsg_name=$(basename "$nsg_id")

# 3. NIC에서 NSG 연결 해제
az network nic update -g "$RG" -n "$nic_name" \
  --remove networkSecurityGroup

# 4. 자동생성된 NSG 삭제
az network nsg delete -g "$RG" -n "$nsg_name"

# 5. Subnet에 NSG 연결 (원하는 nsg-public 사용)
az network vnet subnet update \
  -g "$RG" \
  --vnet-name "$VNET" \
  --name "$SUBNET_PUBLIC_NAME" \
  --network-security-group nsg-public

echo "Removed auto-created NSG ($nsg_name) and attached nsg-public to subnet"
