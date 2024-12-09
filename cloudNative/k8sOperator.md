---
title: Kubernetes Operator-Etcd
date: 2019-11-19 10:59:00
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes
---

<p></p>
<!-- more -->

   ![Operator](.\k8sOperator\operator.jpg )


**Operator: "有状态应用", 自动化运维工作。**

##  Etcd Operator部署 
Controller + CRD 
[etcd Controller](https://github.com/coreos/etcd-operator/blob/master/example/deployment.yaml)  Deployment
[etcd CRD](https://github.com/coreos/etcd-operator/blob/master/example/example-etcd-cluster.yaml)  API资源类型 kind: "EtcdCluster"

etcd高可靠： backup + restore   
[etcd backup](https://github.com/coreos/etcd-operator/tree/master/example/etcd-backup-operator)  etcd备份
[etcd restore](https://github.com/coreos/etcd-operator/tree/master/example/etcd-restore-operator) etcd恢复: 恢复备份的数据

##  普通运维方式etcd运维步骤:
1. 创建种子节点（集群）的阶段称为：Bootstrap
2. 通过 Etcd 命令行添加一个新成员：
```
$ etcdctl member add infra1 http://10.0.1.11:2380
```
3. 为这个成员节点生成对应的启动参数，并启动它：
```
etcd
--data-dir=/var/etcd/data
--name=infra1
--initial-advertise-peer-urls=http://10.0.1.11:2380
--listen-peer-urls=http://0.0.0.0:2380
--listen-client-urls=http://0.0.0.0:2379
--advertise-client-urls=http://10.0.1.11:2379
--initial-cluster=infra0=http://10.0.1.10:2380,infra1=http://10.0.1.11:2380
--initial-cluster-state=existing
```

##  etcd Operator 


   ![etcd Operator](.\k8sOperator\operator1.jpg)
<div>
</div>

注: 一个etcd集群，一个controller。

当这个 YAML 文件第一次被提交到 Kubernetes 之后，Etcd Operator 的 Informer，就会立
刻“感知”到一个新的 EtcdCluster 对象被创建了出来。所以，EventHandler 里的“添加”事
件会被触发。

而这个 Handler 要做的操作也很简单，即：在 Etcd Operator 内部创建一个对应的 Cluster 对
象（cluster.New），比如流程图里的 Cluster1。



## 参考:
+ [深入剖析Kubernetes - 27  聪明的微创新：Operator工作原理解读]() 张磊
+ [面向 Kubernetes 编程： Kubernetes 是下一代操作系统](https://mp.weixin.qq.com/s/E5-agHtMvW_X7znVJDkTKA)
+ [awesome-operators](https://github.com/www6v/awesome-operators)    obsolete
+ [operator-sdk](https://github.com/operator-framework/operator-sdk)   工具




%accordion%附件-有用的 Operator%accordion%

[elastic/cloud-on-k8s](https://github.com/elastic/cloud-on-k8s)
[solo-io/envoy-operator](https://github.com/solo-io/envoy-operator)
[coreos/etcd-operator](https://github.com/coreos/etcd-operator)
[lyft/flinkk8soperator](https://github.com/lyft/flinkk8soperator) ***
[banzaicloud/hpa-operator](https://github.com/banzaicloud/hpa-operator)
[gianarb/influxdb-operator](https://github.com/gianarb/influxdb-operator)
[banzaicloud/istio-operator](https://github.com/banzaicloud/istio-operator)
[jaegertracing/jaeger-operator](https://github.com/jaegertracing/jaeger-operator)
[banzaicloud/kafka-operator](https://github.com/banzaicloud/kafka-operator) ***
[oracle/mysql-operator](https://github.com/oracle/mysql-operator)
[Percona-Lab/percona-xtradb-cluster-operator](https://github.com/Percona-Lab/percona-xtradb-cluster-operator)
[coreos/prometheus-operator](https://github.com/coreos/prometheus-operator) ***
[ucloud/redis-cluster-operator](https://github.com/ucloud/redis-cluster-operator) ***
[apache/rocketmq-operator](https://github.com/apache/rocketmq-operator)***
[rook/rook](https://github.com/rook/rook/tree/master/cluster/examples/kubernetes)***
[GoogleCloudPlatform/spark-on-k8s-operator](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator) ***
[pingcap/tidb-operator](https://github.com/pingcap/tidb-operator)***

%/accordion%

