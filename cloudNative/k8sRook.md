---
title: Kubernetes Rook
date: 2022-01-12 22:43:17
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes  
---

<p></p>
<!-- more -->

## 目录
<!-- toc -->

## Rook for ceph
#####  Rook建立Ceph集群流程[1]
> rook的crd建立好之后，  
> Rook的operator会把rook的控制面建立出来  
> 然后把storageclass和csi driver都注册好。  
> 用户只要建立pvc，pvc里指定用哪个storageclass，然后csi driver会去工作。  

##### Rook cluster installation [2][3] [I]

##### Ceph存储类型
+ Block 
+ FileSystem
+ Object

##### Block Storage [4][5] [II]
+ install
``` yaml
apiVersion: ceph.rook.io/v1
kind: CephBlockPool
metadata:
  name: replicapool
  namespace: rook-ceph
spec:
  failureDomain: host
  replicated:
    size: 3
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
   name: rook-ceph-block
# Change "rook-ceph" provisioner prefix to match the operator namespace if needed
provisioner: rook-ceph.rbd.csi.ceph.com
parameters:
    # clusterID is the namespace where the rook cluster is running
    clusterID: rook-ceph
    # Ceph pool into which the RBD image shall be created
    pool: replicapool

    ... 

# Delete the rbd volume when a PVC is deleted
reclaimPolicy: Delete
```

+ Consume Block[II]
eg 1.     [StatefulSet](k8sStatefulSet.md)  通过StorageClass动态申请pv  
``` yaml
    volumeClaimTemplates:
    -metadata:
      ...
      spec:
      ...
        storageClassName: rook-ceph-block
        volumeMode: Filesystem
```
eg 2. pvc动态申请pv， deployment申请pvc
``` yaml
       volumes: ...
         ...
         - name: pvc-test
           persistentVolumeClaim:
             claimName: rook-ceph-test-pvc
```

##### FileSystem[6][7] [III]

##### PVC在线扩容，PVC快照和回滚

## 参考

1. 云原生训练营 第0期-模块七
2. [Ceph Cluster CRD](https://rook.io/docs/rook/v1.2/ceph-cluster-crd.html) ***
3. [Ceph Storage Quickstart](https://rook.io/docs/rook/v1.2/ceph-quickstart.html)
4. [Block Storage](https://rook.github.io/docs/rook/v1.2/ceph-block.html)
5. [Ceph Block Pool CRD](https://rook.github.io/docs/rook/v1.2/ceph-pool-crd.html#spec)
6. [Shared Filesystem](https://rook.github.io/docs/rook/v1.2/ceph-filesystem.html)
7. [Ceph Shared Filesystem CRD](https://rook.github.io/docs/rook/v1.2/ceph-filesystem-crd.html)

99. [kubernetes架构师课程](https://www.bilibili.com/video/BV16t4y1w7r6?p=111) 杜宽 ***
    [I]P112-P114 installation, [II]P115-P117 block, [III]  P118 FileSystem