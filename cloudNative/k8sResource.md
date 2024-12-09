---
title: Kubernetes Workload
date: 2019-06-09 22:13:52
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes  
---

<p></p>
<!-- more -->


## Workload


![Kubenetes Workload](.\k8sResource\k8sResource.jpg)

##### Basic
- [Node](https://feisky.xyz/kubernetes-handbook/concepts/node.html)
- [Namespace](https://feisky.xyz/kubernetes-handbook/concepts/namespace.html)
- [Pod](https://feisky.xyz/kubernetes-handbook/concepts/pod.html) [8]
- [ServiceAccount](https://feisky.xyz/kubernetes-handbook/concepts/serviceaccount.html)

##### Config
- [ConfigMap](https://feisky.xyz/kubernetes-handbook/concepts/configmap.html)
- [Secret](https://feisky.xyz/kubernetes-handbook/concepts/secret.html)

类型   | 用途  |  使用方式 | 安全
:-:      |  :-:     |  :-:             |   :-:  
ConfigMap |普通配置 |  环境变量 <br> 文件挂载（卷 Volume）[7] | 纯文本
Secret| 敏感数据|  环境变量 <br>文件挂载 | Base64

##### Core
- [StatefulSet](https://feisky.xyz/kubernetes-handbook/concepts/statefulset.html) +
- [Deployment](https://feisky.xyz/kubernetes-handbook/concepts/deployment.html) +
- [ReplicaSet](https://feisky.xyz/kubernetes-handbook/concepts/replicaset.html)
- [CronJob](https://feisky.xyz/kubernetes-handbook/concepts/cronjob.html)
- [Job](https://feisky.xyz/kubernetes-handbook/concepts/job.html)
- [DaemonSet](https://feisky.xyz/kubernetes-handbook/concepts/daemonset.html)
- [CustomResourceDefinition](https://feisky.xyz/kubernetes-handbook/concepts/customresourcedefinition.html)

##### Service
- [Ingress](https://feisky.xyz/kubernetes-handbook/concepts/ingress.html)
- [Service](https://feisky.xyz/kubernetes-handbook/concepts/service.html) +

###### Volume 
- [LocalVolume](https://feisky.xyz/kubernetes-handbook/concepts/local-volume.html)
- [PersistentVolume](https://feisky.xyz/kubernetes-handbook/concepts/persistent-volume.html)
- [Volume](https://feisky.xyz/kubernetes-handbook/concepts/volume.html)

#####  limit  限制
- [NetworkPolicy](https://feisky.xyz/kubernetes-handbook/concepts/network-policy.html)  网络隔离与互通
- [Resource Quota](https://feisky.xyz/kubernetes-handbook/concepts/quota.html)  资源限制
- [SecurityContext](https://feisky.xyz/kubernetes-handbook/concepts/security-context.html)   安全策略

###### other
- [Autoscaling (HPA)](https://feisky.xyz/kubernetes-handbook/concepts/autoscaling.html)
- [PodPreset](https://feisky.xyz/kubernetes-handbook/concepts/podpreset.html)

## 参考

1. [《Kubenetes in Action》](http://product.dangdang.com/26439199.html?ref=book-65152-9168_1-529800-3)  七牛容器云团队
2. [资源对象](https://feisky.xyz/kubernetes-handbook/concepts/objects.html)    feisky ***
3. [面向 Kubernetes 编程： Kubernetes 是下一代操作系统](https://mp.weixin.qq.com/s/E5-agHtMvW_X7znVJDkTKA) ***
4. [第4 章 ： 理解 Pod 和容器设计模式](https://edu.aliyun.com/lesson_1651_13079?spm=5176.254948.1334973.10.2c12cad2AHzzTw#_13079) 阿里
5. [第3 章 ： Kubernetes 核心概念](https://edu.aliyun.com/lesson_1651_13078?spm=5176.254948.1334973.8.2c12cad2AHzzTw#_13078) 阿里 
6. [第5 章 ： 应用编排与管理：核心原理](https://edu.aliyun.com/lesson_1651_13080?spm=5176.254948.1334973.12.2c12cad2AHzzTw#_13080) 阿里
7. [K8s 中 ConfigMap 使用介绍](https://blog.csdn.net/weixin_46902396/article/details/121143037)  
8. [详解 Kubernetes Pod 的实现原理](https://draveness.me/kubernetes-pod/)  未



%accordion%附: ConfigMap 使用%accordion%

 
```
apiVersion: v1
kind: Pod
metadata:
  name: zhangsan
spec:
  containers:
  - name: zhangsan
    image: busybox:1.28.4
    imagePullPolicy: IfNotPresent
    command: ['/bin/sh','-c','env']
    env:									# 配置环境变量
    - name: HostName						# 变量名
      valueFrom:
        configMapKeyRef:
          name: cm-01						# ConfigMap 名称 (要和上面对应)
          key: hostname						# ConfigMap 里边的 Key (要和上面对应)
    - name: Password
      valueFrom:
        configMapKeyRef:
          name: cm-01
          key: password
  restartPolicy: Never						# 当容器退出后. 不会进行重启操作
```

%/accordion%

