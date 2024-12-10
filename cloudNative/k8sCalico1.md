---
title: Calico
date: 2022-08-12 11:55:44
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes
---

<p></p>
<!-- more -->


## Best Practice
##### At a high-level, the key recommendations are:
+ Use the Kubernetes datastore.
  使用K8S datastore
+ Install Typha to ensure datastore scalability.
  安装Typha
+ Use no encapsulation for single subnet clusters.
  在单一子网的集群中，不要封装   
+ Use IP-in-IP in CrossSubnet mode for multi-subnet clusters.
  在多子网集群中，使用IP-in-IP的跨子网模式
+ Configure Calico MTU based on the network MTU and the chosen routing mode.
  MTU
+ Add global route reflectors for clusters capable of growing above 50 nodes.
  50个nodes以上使用RR(route reflectors)
+ Use GlobalNetworkPolicy for cluster-wide ingress and egress rules. Modify the policy by adding namespace-scoped NetworkPolicy.

## Calico Component Overview
![Calico Component Overview](.\k8sCalico1\calico-components.png)


##### calico-node
  + Route programming: Based on known routes to pods in the Kubernetes cluster, configure the Linux host to facilitate routing accordingly.   [路由配置  Flex]
  + Route sharing: Based on pods running on this host, provide a mechanism to share known routes with other hosts. Typically accomplished with (BGP) Border Gateway Protocol.  [路由共享  BIRD] 

##### calico-kube-controller 
+ The calico-kube-controller is responsible for recognizing changes in Kubernetes objects that impact routing.   
  识别影响路由变化。且包含多个控制器
+ multiple controllers
   - policy-controller
   - ns-controller
   - sa-controller
   - pod-controller
   - node-controller

##### Typha

## Calico Datastore
+ Calico supports 2 datastore modes, Kubernetes and etcd.
  + Kubernetes Datastore Mode (Recommended)
  + etcd Datastore Mode


## Routing Configuration
##### Routing Methods
+ 3 routing modes 
    + Native: Packets routed as-is, no encapsulation.
    + IP-in-IP: Minimal encapsulation; outer header includes host source/destination IPs and inner header includes pod source/destination.
      [tunl]
    + VXLAN: Robust encapsulation using UDP over IP; outer header includes host source/destination IP addresses and inner header includes pod source/destination IP addresses as well as Ethernet headers.
      [on udp, ]

+ 1.注意VxLAN模式不需要BGP协议参与！！！但是IPIP模式是需要的。
Calico supports two types of encapsulation: VXLAN and IP in IP. VXLAN is supported in some environments where IP in IP is not (for example, Azure). VXLAN has a slightly higher per-packet overhead because the header is larger, but unless you are running very network intensive workloads the difference is not something you would typically notice. The other small difference between the two types of encapsulation is that Calico’s VXLAN implementation does not use BGP, whereas Calico’s IP in IP implementation uses BGP between Calico nodes.   # From Calico Docs  

##### Single Subnet Configuration
![calico-single-subnet](.\k8sCalico1\calico-single-subnet.png)


##### Multi-Subnet Configuration
![calico-multi-subnet](.\k8sCalico1\calico-multi-subnet.png)



## Route Distribution
+ BGP Full Mesh
  node-to-node mesh
+ Global Route Reflection(RR)
+ Node-Specific Route Reflection
  Peering can be configured for **BGP-capable hardware** in a datacenter’s network. Most commonly setup with **top of rack (ToR)** switches. 
  

## 参考
1. [Calico Reference Architecture](https://tanzu.vmware.com/developer/guides/container-networking-calico-refarch/)
2. [20210808-Calico IPIP Mode](https://www.yuque.com/wei.luo/cni/agyl5i)