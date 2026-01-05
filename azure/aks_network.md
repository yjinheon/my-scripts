차이는 한 줄로 이거야:

- **실제 서브넷(VNet Subnet)** = Azure VNet 안의 “진짜 L3 네트워크 구간” (NIC가 붙는 곳, NSG/UDR/NAT/방화벽이 적용되는 곳)
- **가상 CIDR(Service CIDR / Pod CIDR 등)** = Kubernetes가 **클러스터 내부에서만** 쓰는 “논리적 주소대역” (Azure VNet 라우팅/서브넷과는 별개)

네 출력은 그래서 아주 정합적이야:

- 노드풀 3개(syspool/userpool/memorypool)의 **노드 NIC는 전부 `vnet-main/subnet-app(10.10.0.64/26)`** 에 붙어 있고
- 그런데 Kubernetes 내부에서는
  - **Service CIDR = 10.0.0.0/16 (ClusterIP)**
  - **Pod CIDR = 10.244.0.0/16 (Pod IP, overlay)**
    를 별도로 쓰는 구조

---

## 정확히 뭐가 다른가

### 1) 실제 서브넷: `10.10.0.64/26 (subnet-app)`

여기에 “실제 Azure 리소스의 NIC”가 붙어.

- AKS 노드 VMSS NIC
- (있다면) Private Endpoint NIC
- (기타 VM, NIC)

여기엔 **NSG/UDR/방화벽/NAT** 같은 Azure 네트워크 정책이 걸림.

### 2) 가상 대역: `Service CIDR 10.0.0.0/16`

이건 Kubernetes Service의 **ClusterIP**가 나오는 공간.

- 예: `kube-dns`가 10.0.0.10 같은 IP를 가짐
- 하지만 이 IP는 **Azure VNet에 존재하는 NIC가 가진 IP가 아님**
- Azure 입장에선 “그 IP를 가진 장비가 없음(논리 IP)”

### 3) 가상 대역: `Pod CIDR 10.244.0.0/16 (overlay)`

`networkPluginMode: overlay`라서 Pod IP는

- VNet IP를 직접 쓰지 않고(= Pod마다 10.10.\*을 안줌)
- 노드 간에 **오버레이(터널)** 로 전달됨

즉, Pod IP(10.244.\*)는 **클러스터 내부 라우팅에서만 의미가 있고**, Azure VNet 라우팅 테이블/서브넷에는 직접 등장하지 않아.

---

## Markdown으로 구성도(텍스트 다이어그램)

```text
Internet / Client
      |
      |  (Public IP or Internal IP)
      v
+------------------------------+
| Azure Load Balancer (Std)    |   <-- ingress-nginx Service(type=LoadBalancer)
|  - Frontend IP: x.x.x.x      |
+------------------------------+
                |
                | forwards to NodePorts on AKS nodes
                v
+------------------------------------------------------------------+
| Azure VNet: vnet-main                                            |
| Address Space: 10.10.0.0/24, 10.0.0.0/16, 10.1.0.0/16             |
|                                                                  |
|  Subnet: subnet-app (10.10.0.64/26)  <-- "실제 서브넷"            |
|   - NSG: nsg-app                                                 |
|   - AKS NodePools NICs attach here                               |
|     * syspool nodes (System)                                     |
|     * userpool nodes (User)                                      |
|     * memorypool nodes (User)                                    |
|                                                                  |
|  Subnet: subnet-public (10.10.0.0/27)  (다른 리소스용)            |
|  Subnet: subnet-db (10.10.0.128/27)  (PG delegation)             |
|  Subnet: subnet-powerbi-gateway (10.10.0.160/27)                 |
+------------------------------------------------------------------+
                |
                | (node 내부에서 kube-proxy/iptables/IPVS + overlay)
                v
+------------------------------------------------------------------+
| AKS Cluster: scv-aks                                              |
|  Network plugin: Azure CNI (overlay mode)                         |
|                                                                  |
|  "가상 CIDR #1" Service CIDR: 10.0.0.0/16                         |
|    - ClusterIP들이 이 대역을 사용                                |
|    - 예: kube-dns = 10.0.0.10                                     |
|    - Azure NIC/서브넷과 무관(논리 IP)                             |
|                                                                  |
|  "가상 CIDR #2" Pod CIDR: 10.244.0.0/16                           |
|    - Pod들이 이 대역 IP를 사용                                   |
|    - overlay로 노드간 전달 (Pod IP는 VNet에 직접 라우팅 안 됨)    |
+------------------------------------------------------------------+
```

---

## 네 상황에서 “10.0.0.0/16을 VNet에도 넣어둔 이유”는?

정답은: **지금 시점에선 ‘용도 미정/예약’일 가능성이 큼**.
AKS의 `serviceCidr`가 10.0.0.0/16인 건 “K8s 내부 논리망” 설정이고, **VNet에 10.0.0.0/16을 넣었다고 해서 AKS 서비스CIDR과 자동으로 연결되지 않아.**

오히려 추천 관점에선:

- **Service CIDR / Pod CIDR은 VNet 주소대역과 겹치지 않게** 잡는 게 보통 안전해(피어링/온프레 연동 때 혼선 방지).

---
