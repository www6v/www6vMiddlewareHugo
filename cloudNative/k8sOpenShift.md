---
title: Kubernetes OpenShift
date: 2022-01-05 21:45:05
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes
---

<p></p>
<!-- more -->

![OpenShift](.\k8sOpenShift\openshift.png)



## Interface
+ CNI  
  OpenFlow(OVS)(使用的， 更通用，场景适合的更多)   
  Calico  
+ CRI  
  - OpenShift3.0 用的  
      Docker（有守护进程，守护进程宕掉后，运行时会有问题）   
      Red Hat Enterprise Linux - 4G大小  
  - OpenShift4.0 用的  
      CRI-O（没有守护进程）  
      Ret Hat CoreOS - 不到800M大小  
+ CSI  
  CEPH(ROOK)   
  NFS  
+ 入口 ingress  
   - openshift 默认是haproxy的ingress（首选建议使用， dns解析， mTLS）  
   - 也可以装nginx ingress  
   - 也可以装istio ingress gateway（4层选， istio ingress gateway）  


## PaaS  
 角色 - RBAC  
 配置管理 - LimitRanage， Quota  
 联邦集群 - kubefed   


## 对K8S的增强
![enhancement](.\k8sOpenShift\enhancement.png)

+ Operator  
+ Multus多个虚拟网卡（用的多）  
  一个pod有多个虚拟网卡， ovs管理网络 + macvlan网络（性能比较好）   
+ kube-virt 虚拟机管理  

![openshift-vs-k8s1](.\k8sOpenShift\openshift-vs-k8s1.png)

![openshift-vs-k8s2](.\k8sOpenShift\openshift-vs-k8s2.png)

## 应用迁移
![appMigrate](.\k8sOpenShift\appMigrate.png)


+ 应用改造的难度比较大


## 多云
##### 基于多云的CI/CD
![cicd-multiCluster](.\k8sOpenShift\cicd-multiCluster.png)  
+ 基于jenkins  
  容易编写，耗内存  
+ 基于Tekton  
  不容易编写， 不耗内存  

##### 应用发布到多个集群
  RHACM 本来是IBM的，后来给了RedHat   
  RHACM基于CNCF的Open Cluster Management孵化项目   


## 竞品分析
+ 占有率30%， 早2018年，   
   生态做的好（开源项目operator， marketplace， istio， serverlesss）  
   IBM AI，中间件相关的东西挪到OpenShift  


## 市场   
银行， 企业级客户  
[社区版本 OKD](https://quay.io/repository/openshift/okd)   


## 参考 
+ [基于 Red Hat OpenShift 4 构建 Paas、DevOps 平台](https://www.bilibili.com/video/BV19p4y1k7yA?spm_id_from=333.880.my_history.page.click&vd_source=f6e8c1128f9f264c5ab8d9411a644036) v
+ [15分钟搞定 OpenShift 多云管理，并统一部署应用](https://www.bilibili.com/video/BV1FL4y1c767?spm_id_from=333.880.my_history.page.click&vd_source=f6e8c1128f9f264c5ab8d9411a644036)
+ [用 Kubernetes Operator 管理 OpenShift 应用生命周期](https://www.bilibili.com/video/BV1nZ4y1b71F?spm_id_from=333.880.my_history.page.click&vd_source=f6e8c1128f9f264c5ab8d9411a644036)
