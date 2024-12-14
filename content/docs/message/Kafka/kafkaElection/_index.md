---
title: Kafka 中的选主
date: 2021-05-16 10:37:20
weight: 10
tags:
  - kafka
categories: 
  - 消息系统
  - Kafka   
---

<p></p>
<!-- more -->


## Kafka中的选主[1]

/|组件| 详细
:-:|:-:|:-:
kafka|Controller leader| 依赖zk选主, kafka只有一个Controller
Partition leader[2] | leader在ISR中|
Consumer leader的选举| 消费组内的消费者选举出一个消费组的leader|
zookeeper| zk自身的选主 | Zab协议(原子广播+奔溃恢复)
 其他系统依赖zk选主| 使用zk的临时节点， session结束， 临时节点消失|

## Q&A
+    ~~Kafka中有那些地方需要选举？~~这些地方的选举策略又有哪些？

## 参考
1. [Kafka科普系列 | 原来Kafka中的选举有这么多？](https://mp.weixin.qq.com/s?__biz=MzU0MzQ5MDA0Mw==&mid=2247485365&idx=1&sn=f55d8d2e1d6e82d23b6f60b847382c25)  朱小厮  
[Kafka科普系列 | 原来Kafka中的选举有这么多](https://honeypps.com/mq/kafka-basic-knowledge-of-selection/)  

2. [你想知道的所有关于Kafka Leader选举流程和选举策略都在这(内含12张高清大图,建议收藏) ](https://mp.weixin.qq.com/s?__biz=Mzg4ODY1NTcxNg==&mid=2247491541&idx=1&sn=d4dbd0840fd3f61b7e86d6169caf2994&)   石臻臻    ***  未