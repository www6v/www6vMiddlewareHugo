---
title: Kubernetes 多集群管理
date: 2022-05-08 22:14:17
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes
---

<p></p>
<!-- more -->

## 目标
让用户像使用单集群一样来使用多集群。

## 多集群部署需要解决哪些问题

+ 而多集群管理需要解决以下问题：  
多集群服务的分发部署（deployment、daemonset等）  
跨集群自动迁移与调度（当某个集群异常，服务可以在其他集群自动部署）  
多集群服务发现，网络通信及负载均衡（service，ingress等）  


## 开源和解决方案  
+ KubeFed 或 Federation v2  
	+ [kubefed](https://github.com/kubernetes-sigs/kubefed)  
	+ [集群联邦（Cluster Federation）](https://jimmysong.io/kubernetes-handbook/practice/federation.html)   jimmysong  

+ virtual-kubelet Virtual Kubelet  
	+ [阿里云virtual-kubelet-autoscaler实现ECI作为弹性补充](https://www.modb.pro/db/166209)
	+ [通过 virtual-kubelet-autoscaler 将Pod自动调度到虚拟节点](https://www.alibabacloud.com/help/zh/elastic-container-instance/latest/schedule-pods-to-a-virtual-node-through-the-virtual-kubelet-autoscaler-add-on)  
	+ [自建Kubernetes集群部署Virtual Kubelet（ECI）](https://help.aliyun.com/document_detail/97527.html) 未  
	+ [简介：Virtual Kubelet](https://v.qq.com/x/page/d0816t4u183.html) video 2018 kubecon   未  
	+ [深入了解：Virtual Kubelet](https://v.qq.com/x/page/q0827olfrlx.html) video   2018 kubecon  未 


+ Karmada（Kubernetes Armada）[5]

+ clusternet - 腾讯云

+ OCM(Open Cluster Management) - RedHat 

+ Gardener [3]

+ Crossplane [3]

+ cluster-api [4]

## 参考：
1. [k8s多集群的思考](https://www.huweihuang.com/kubernetes-notes/multi-cluster/k8s-multi-cluster-thinking.html)
2. [混合云下的 Kubernetes 多集群管理与应用部署](https://kubesphere.com.cn/blogs/kubernetes-multicluster-kubesphere/) 未
3. [【PingCAP Infra Meetup】No.141 Kubernetes 开发设计模式在 TiDB Cloud 中的应用](https://www.bilibili.com/video/BV14f4y1T7LY/)
4. [基于 ClusterAPI 的集群管理](https://www.bilibili.com/video/BV12e4y1M7KM?spm_id_from=333.880.my_history.page.click)
5. [Karmada: 开源的云原生多云容器编排引擎](https://www.bilibili.com/video/BV1rX4y1c72s?spm_id_from=333.999.0.0) 华为





