---
title: Kafka Controller-控制器
date: 2021-05-16 14:30:24
weight: 8
tags:
  - kafka  
categories:
  - 消息系统
  - Kafka   
---

<p></p>
<!-- more -->


## 选举控制器的规则:
第一个成功创建 /controller 节点的 Broker 会被指定为控制器。

## 作用
+ 主题管理(创建、删除、增加分区)  

+ 分区重分配  
kafka-reassign-partitions  

+ Preferred 领导者选举  
Preferred 领导者选举主要是 Kafka 为了避免部分 Broker 负载过重而提供的一种换 Leader 的方案。  

+ 集群成员管理(新增 Broker、Broker 主动关闭、Broker 宕机)  
包括自动检测新增 Broker、Broker 主动关闭及被动宕机。  
这种自动检测是依赖于前面提到的 Watch 功能和 ZooKeeper 临时节点组合实现的。  

+ 数据服务  
控制器上保存了最全的集群 元数据信息，其他所有 Broker 会定期接收控制器发来的元数据更新请求，从而更新其内存 中的缓存数据。  



## 参考
[直击Kafka的心脏——控制器](https://hiddenpps.blog.csdn.net/article/details/80865540)
<<26 | 你一定不能错过的Kafka控制器>>  胡夕