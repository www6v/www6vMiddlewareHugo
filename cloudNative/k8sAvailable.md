---
title: K8S高可用-零停机[自主中断]
date: 2022-04-05 15:09:31
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes
---

<p></p>
<!-- more -->


# 自主中断和非自主中断[4]
![自主中断和非自主中断](.\k8sAvailable\interrupt.png)

# PodDisruptionBudged [4]
  1. 无状态应用： 
     maxUnavailable = 40%
  2. 单实例有状态应用: 
  3. 多实例有状态应用： 
     etcd N, maxUnavailable=1 或者 minAvailable=N

# 参考
4. 模块十一： 将应用迁移至Kubernetes平台
101. [使用 PDB 避免 Kubernetes 集群中断](https://zhuanlan.zhihu.com/p/360521649) 未

