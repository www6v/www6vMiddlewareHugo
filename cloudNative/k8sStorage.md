---
title: Kubernetes存储
date: 2019-09-01 17:39:12
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes  
---

<p></p>
<!-- more -->
![Kubernetes存储](.\k8sStorage\k8sStorage.jpg)

## 一. Kubernetes 存储的绑定流程 
### 1.1
![Kubernetes存储的绑定流程](https://user-images.githubusercontent.com/5608425/68108028-9593b600-ff21-11e9-8623-5c719772317e.jpg)

**三个阶段**
+ 第一个**create**阶段，主要是创建存储；
+ 第二个**attach**阶段，就是将那块存储挂载到 node 上面(通常为将存储load到node的/dev下面)；
+ 第三个**mount**阶段，将对应的存储进一步挂载到 pod 可以使用的路径。


## 二. Static Provisioning && Dynamic Provisioning

### 2.1 Static Provisioning
![Static Provisioning](.\k8sStorage\static-provision.PNG)

### 2.2 Dynamic Provisioning
![Dynamic Provisioning](.\k8sStorage\dynamic-provision.PNG)

<div style="text-align: center;">
</div>
![relationship](https://user-images.githubusercontent.com/5608425/64247540-aafc5c00-cf41-11e9-83af-64199e79ded7.JPG)
**Kubernetes pvc 动态绑定流程**


> 只有同属于一个 StorageClass 的PV 和 PVC，才可以绑定在一起

+ CSI driver动态创建pv ， CSI Driver 可以动态创建PV [5]  
  创建pvc之后，provisioner 会创建pv ，并做pvc和pv的绑定关系

## 本地存储[5]
+ emptyDir   
  不是overlayFS ，和写主机的性能是一样的  
  和容器的生命周期一致，如果容器销毁， emptyDir也被销毁。  
+ hostPath   
  需要的注意点，不建议用  

## 最佳实践[5]
+ 用户去查询集群中有哪些storageclass  
  可能有本地的hostpath，或者远程的nfs， ceph 等等  
    - 在storageClass中, provisioner很重要  
+ pod中声明一个pvc  
  csi  plugin把pv attach到对应的node，mount到对应的pod  
+ pvc和pv是一一对应的关系    


## 参考:

1. [《Kubenetes in Action》七牛容器云团队](http://product.dangdang.com/26439199.html?ref=book-65152-9168_1-529800-3)
2. <<深入剖析Kubernetes - 28  PV、PVC、StorageClass，这些到底在说啥？>> 张磊
3. <<深入剖析Kubernetes - 29  PV、PVC体系是不是多此一举？从本地持久化卷谈起>> 张磊
4. [第9 章 ： 应用存储和持久化数据卷：核心知识](https://edu.aliyun.com/lesson_1651_13085#_13085) 
5. 云原生训练营 第0期-模块七