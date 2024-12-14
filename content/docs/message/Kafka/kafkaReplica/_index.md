---
title: Kafka Replication-副本机制
date: 2021-05-16 10:50:48
weight: 9
tags:
  - kafka
categories: 
  - 消息系统
  - Kafka   
---

<p></p>
<!-- more -->


##  Partition
1. 首领 leader ， 首领副本
2. 跟随者 follower， 跟随者副本
3. 首选首领


##  Kafka的副本机制
1. AR = ISR + OSR。   
ISR 不只是追随者副本集合，它必然包括 Leader 副本。  

2. ISR中副本有主从之分，但是**读写都是主副本**， 从副本只负责**拉取**主副本的数据。
好处（一致性方面）  
	+ 方便实现**“Read-your-writes”**  
	+ 方便实现**单调读（Monotonic Reads）**  

3. Kafka 判断 Follower 是否与 Leader 同步的标准,**不是看"相差的消息数"，而是看"落后的时间"。**  
   **落后的时间**就是 Broker 端参数 replica.lag.time.max.ms 参数值。  
   这个参数的含义是Follower 副本能够落后 Leader 副本的最长时间间隔，当前默认值是 10 秒。  
4. Unclean 领导者选举（Unclean Leader Election）   
[Kafka 可靠性总结](../../../../2016/07/05/kafkaReliability/) self  

## Q&A
+    失效副本是指什么？有那些应对措施？   
怎么样判定一个分区是否有副本是处于同步失效状态的呢？从Kafka 0.9.x版本开始通过唯一的一个参数replica.lag.time.max.ms（默认大小为10,000）来控制，当ISR中的一个follower副本滞后leader副本的时间超过参数replica.lag.time.max.ms指定的值时即判定为副本失效，需要将此follower副本剔出除ISR之外。  
[Kafka解析之失效副本](https://honeypps.com/mq/kafka-analysis-of-under-replicated-partitions/)  
+    优先副本是什么？它有什么特殊的作用？  
+    多副本下，各个副本中的HW和LEO的演变过程
+    为什么Kafka不支持读写分离？

## 参考：
7. Kafka核心技术与实战 - 23丨Kafka副本机制详解  胡夕