---
title: Zookeeper-总结
date: 2015-03-26 22:22:29
tags:
  - Zookeeper
categories:
  - 中间件 
  - Zookeeper
---

<p></p>
<!-- more -->



#  读/写流程 [1]
###  写流程
+ 写Leader
+ 写Follower/Observer
  将写请求转发给Leader处理

###  读流程
+ Leader/Follower/Observer都可直接处理读请求，从本地内存中读取数据并返回给客户端即可。

# 应用场景 [2]
### 元数据管理
Dubbo， HBase

### 分布式协调
kafka controller

### Master选举 -> HA架构
HDFS NameNode HA

### 分布式锁
案例比较少


# 实现高可用 [2]
### 主备切换

### 集群选举
+ 最小节点获胜
+ 抢建唯一节点
+ 法官判决

# 参考
1. [深入浅出Zookeeper（一） Zookeeper架构及FastLeaderElection机制 ](http://www.jasongj.com/zookeeper/fastleaderelection/) *** 
2. [浅析如何基于ZooKeeper实现高可用架构｜得物技术](https://www.jianshu.com/p/9ce2600dd139) 
100. [ZooKeeper 核心通识](https://zhuanlan.zhihu.com/p/571732977) 未
