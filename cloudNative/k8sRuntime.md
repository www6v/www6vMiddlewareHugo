---
title: Kubernetes Runtime
date: 2019-11-19 15:21:19
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes  
---

<p></p>
<!-- more -->

   ![Kubernetes Runtime](.\k8sRuntime\k8sRuntime.jpg)

## 一. 虚拟化技术
   ![虚拟化技术](.\k8sRuntime\k8sRuntime1.jpg)
<div style="text-align: center;">
</div>

+ runc： OSContainerRuntime（基于进程隔离技术）
+ kvm:   HyperRuntime（基于Hypervisor技术）
+ runv： UnikernelRuntime（基于unikernel）

## 二. CRI架构

![CRI架构](.\k8sRuntime\k8sRuntime2.jpg)

![cni-arch](https://user-images.githubusercontent.com/5608425/69022893-c67eeb00-09f7-11ea-9203-fd96b90dfbef.jpg)
CRI架构

<div style="text-align: center;">
</div>


+ docker调用的链路：dockershim => dockerd => Containerd => runc
+ Containerd调用的链路：Containerd --> shim v2 --> runtimes


+ Docker 作为 K8S 容器运行时，调用关系如下：
  kubelet --> docker shim （在 kubelet 进程中） --> dockerd --> containerd
+ Containerd 作为 K8S 容器运行时，调用关系如下：
  kubelet --> cri plugin（在 containerd 进程中） --> containerd



+ high level运行时： Dockershim， containerd， CRI-O
+ low level运行时： 
  - runc， kata， gVisor
  - runc：运行可信容器（弱隔离但性能好）;  
  - runv: 运行不可信容器（强隔离安全性好）; 


## 参考:
1. [CRI - Container Runtime Interface（容器运行时接口）](https://jimmysong.io/kubernetes-handbook/concepts/cri.html)
2. [为Kubernetes选择合适的容器运行时](https://mp.weixin.qq.com/s/sshrTSsUfqjja6g4-Lb42g)
3. 模块七 
3. [](https://cloud.tencent.com/document/product/457/35747) 腾讯云