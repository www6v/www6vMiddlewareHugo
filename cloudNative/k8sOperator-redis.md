---
title: Kubernetes Operator-Redis
date: 2022-02-17 22:25:07
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes
---

<p></p>
<!-- more -->

## Deploy redis cluster operator

```
kubectl create -f deploy/crds/redis.kun_distributedredisclusters_crd.yaml
kubectl create -f deploy/crds/redis.kun_redisclusterbackups_crd.yaml

// cluster-scoped
$ kubectl create -f deploy/service_account.yaml
$ kubectl create -f deploy/cluster/cluster_role.yaml
$ kubectl create -f deploy/cluster/cluster_role_binding.yaml
$ kubectl create -f deploy/cluster/operator.yaml
```

## Deploy a sample Redis Cluster
```
## Custom Resource
$ kubectl create -f deploy/example/custom-resources.yaml

## Persistent Volume
$ kubectl create -f deploy/example/persistent.yaml
```

## 参考
[redis-cluster-operator](https://github.com/ucloud/redis-cluster-operator) 
[kubernetes架构师课程](https://www.bilibili.com/video/BV16t4y1w7r6?p=129)  129 V *** 

