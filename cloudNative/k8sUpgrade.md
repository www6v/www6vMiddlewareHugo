---
title: Kubernetes 升级upgrade
date: 2022-01-16 23:15:30
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes  
---

<p></p>
<!-- more -->


## 宏观升级流程
1、升级主master节点  
2、升级其他master节点  
3、升级node节点  

## 微观升级步骤
1、先升级kubeadm版本  
2、升级第一个主控制平面节点Master组件  
3、升级第一个主控制平面节点上的Kubelet和kubectl  
4、升级其他控制平面节点  
5、升级Node节点  
6、验证集群  

## 升级注意事项

+ 确定升级前的的kubeadm集群版本。  
+ kubeadm upgrade不会影响到工作负载，仅涉及k8s内部的组件，但是备份etcd数据库是最佳实践。  
+ 升级后，所有容器都会重启动，因为容器的hash值已更改。  
+ 由于版本的兼容性，只能从一个次要版本升级到另外一个次要版本，不能跳跃升级。  
+ 集群控制平面应使用静态Pod和etcd pod或外部etcd。  

## 参考：
[Kubernetes版本升级实践](https://zhuanlan.zhihu.com/p/358338665)
[Kubernetes升级：自己动手的权威指南](https://developer.aliyun.com/article/888380)