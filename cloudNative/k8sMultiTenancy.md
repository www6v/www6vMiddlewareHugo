---
title: Kubernetes 多租户 
date: 2021-10-18 21:51:13
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes
---

<p></p>
<!-- more -->


## 一. 概念和原则
1. 租户是指一组拥有访问特定软件资源权限的用户集合，在多租户环境中，它还包括共享的应用、服务、数据和各项配置等。  
2. 多租户集群必须将租户彼此隔离  
3. 集群须在租户之间公平的分配集群资源。  


## 二. Overview

+ 软隔离：在这种情况下，我们有一个企业，不同的团队访问同一个集群，这需要较少的安全开销，因为用户可以相互信任。  

+ 硬隔离：当 Kubernetes 暴露给具有独立且完全不受信任的用户的多个企业时，这是必需的。  
![多租户Overview](.\k8sMultiTenancy\k8sMultiTenancy1.png)  

+ 方案B  软隔离 - hierarchical-namespaces  
https://github.com/kubernetes-sigs/hierarchical-namespaces
[Kubernetes 的层级命名空间介绍](https://icloudnative.io/posts/introducing-hierarchical-namespaces/)  

+ 方案C  硬隔离 - virtualcluster  
  https://github.com/kubernetes-sigs/cluster-api-provider-nested/tree/main/virtualcluster   

   
## 三. 方案B 解决方案
##### 1. 认证  
   + 识别访问的用户是谁  
   + K8s可管理2类用户   
     - ServiceAccount  
        是存在于K8s中的虚拟账户;   
        原生支持的动态认证;  
     - 用户认证  
        webhook是和企业认证平台集成的重要手段  

##### 2. 授权  
![授权](.\k8sMultiTenancy\k8sMultiTenancy.png)  

##### 3. 隔离

   + 节点隔离   
     Taints和Toleration机制  
     [Kubernetes 调度 - 污点和容忍度详解]  (https://mp.weixin.qq.com/s/rza4euQCLuMLTI5fHdj67Q)  
     [Taint 和 Toleration（污点和容忍）](https://jimmysong.io/kubernetes-handbook/concepts/taint-and-toleration.html)  
     
   + 网路隔离
     NetworkPolicy 网路策略 - 实质上也是iptables规则  
     网络策略通过网络插件来实现，所以必须使用一种支持 NetworkPolicy 的网络方案（如 calico）—— 非 Controller 创建的资源，是不起作用的。  

   + 容器隔离  
       5种隔离机制  
       - Mount Namespace 隔离  
       - PID Namespace 隔离  
       - Network Namespace 隔离  
       - IPC Namespace 隔离  
       - UTS Namespace 隔离  
```
      4个打破隔离的机制 
         - spec.hostNetwork
         - spec.volumes
         - spec.shareProcessNamespace
         - spec.containers[].securityContext.privileged
```

##### 4. 配额
ResourceQuota    

##### 5. 开源方案
[kiosk](https://github.com/loft-sh/kiosk)  
[Set up soft multi-tenancy with Kiosk on Amazon Elastic Kubernetes Service](https://aws.amazon.com/de/blogs/containers/set-up-soft-multi-tenancy-with-kiosk-on-amazon-elastic-kubernetes-service/)  

### 参考：
1. [Kubernetes 多租户简介](https://mp.weixin.qq.com/s/YBxsZ5a_K6AWnOISTtiX3g)
    https://static.sched.com/hosted_files/kccnceu19/74/kubecon-eu-multitenancy-wg-deepdive.pdf
    官方 https://github.com/kubernetes-sigs/multi-tenancy

2. [解决 K8s 落地难题的方法论提炼](https://mp.weixin.qq.com/s/PobybjwmzOdbLcx53onJZQ)

3. [NetworkPolicy](https://jimmysong.io/kubernetes-handbook/concepts/network-policy.html) jimmysong

4. [轻量级 Kubernetes 多租户方案的探索与实践](https://mp.weixin.qq.com/s/Y-dUtp1yqRxpd40YwjyE0Q) 火山引擎云原生
   本质上来说 KubeZoo 的方案和 Virtual Cluster 有点类似，是一种 Serverless 的 Kubernetes 方案。

5. [KubeSphere 多租户与认证鉴权实践：使用 GitLab 账号登陆 KubeSphere](https://kubesphere.com.cn/blogs/gitlab-kubesphere/) 未

