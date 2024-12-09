---
title: K8S 弃用Docker
date: 2021-06-01 21:57:51
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes  
---

<p></p>
<!-- more -->

### 1. 
   ![CRI](.\k8sAbandonDocker\img1.png)

如果以 kubelet 调用 CRI 为起点，OCI 的 runC 调用为终点，三种模式经历的可执行程序分别是：


+ dockershim 模式：dockershim(*)->dockd->containerd->containerd-shim
+ cri-containerd 模式：cri-containerd(*)-> containerd->containerd-shim
+ cri-o 模式：cri-o

+ K8S弃用Docker是指弃用Docker daemon
+ RedHat 推崇的 cri-o  → Podman


### 2.
   ![CRI](.\k8sAbandonDocker\img2.jpeg)

容器引擎可选的替代方案大概有以下几种：

+ containerd 
+ CRI-O  → Podman, Red Hat
+ gVisor  → “guest 内核”层
+ kata-containers  →  安全
+ Nabla

## 参考：
+ https://www.infoq.cn/article/VasFWOChD6JoL5avhfAz
+ https://www.zhihu.com/question/433184969

