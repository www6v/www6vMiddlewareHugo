---
title: Redis Cluster
date: 2022-07-11 06:45:41
weight: 3
tags:
  - KV
categories:
  - 数据库
  - KV
  - Redis
---

<p></p>
<!-- more -->

## 目录
<!-- toc -->

# Cluster 功能 [1.1]
+ Redis Cluster支持多个master，每个master又可以挂载多个slave
  - 读写分离
  - 支持数据的高可用
  
+ 故障转移， 高可用
  由于Cluster自带Sentinel的故障转移机制，内置了高可用的支持， **无需再去使用哨兵功能**  
+ 由对应的集群来负责维护节点、插槽和数据之间的关系

# Slot
Redis集群有16384个哈希槽每个key通过CRC16校验后对16384取模来决定放置哪个槽，集群的每个节点负责一部分hash槽.

###   分片方式
- crc（key）% 16384

###  映射关系
   key （→ CRC） 分片
   分片 (→ 映射关系)  实例 

###   slot分配
- 自动分配slot
  create() 
- 手动分配slot
  meet()
  addSlot()

###  指令
-  MOVED指令， ASK 指令

###  最大槽数是16384的原因 [1.3]
[ redis 作者解答]
[ why redis-cluster use 16384 slots? #2576 ](https://github.com/redis/redis/issues/2576)   antirez 

[中文翻译]
正常的心跳数据包带有节点的完整配置，可以用幂等方式用旧的节点替换旧节点，以便更新旧的配置。 这意味着它们包含原始节点的插槽配置，该节点使用2k的空间和16k的插槽，但是会使用8k的空间（使用65k的插槽）。同时，由于其他设计折衷，Redis集群不太可能扩展到1000个以上的主节点。 因此16k处于正确的范围内，以确保每个主机具有足够的插槽，最多可容纳1000个矩阵，但数量足够少，可以轻松地将插槽配置作为原始位图传播。请注意，在小型群集中，位图将难以压缩，因为当N较小时，位图将设置的slot / N位占设置位的很大百分比。

[解读]
- **消息头太大， 发送的心跳包过于庞大**
**如果槽位为65536，发送心跳信息的消息头达8k，发送的心跳包过于庞大。**

在消息头中最占空间的是myslots[CLUSTER_SLOTS/8]。当槽位为65536时，这块的大小是:65536÷8÷1024=8kb

在消息头中最占空间的是myslots[CLUSTER_SLOTS/8]。当槽位为16384时，这块的大小是:16384∶8∶1024=2kb

因为每秒钟，redis节点需要发送一定数量的ping消息作为心跳包，如果槽位为65536，这个ping消息的消息头太大了，浪费带宽。 

- **主节点数量上限为1000，无需65536个slot**
redis的集群主节点数量基本不可能超过个1000个。
集群节点越多，心跳包的消息体内携带的数据越多。如果节点过1000个，也会导致网络拥堵。因此redis作者不建议redis cluster节点数量超过1000个。那么，对于节点数在1000以内的redis cluster集群，16384个槽位够用了。没有必要拓展到65536个。 


# 一致性
+ **Redis集群不保证强一致性**
redis集群不保证强一致性，这意味着在特定的条件下，Redis集群可能会丢掉一些被系统收到的写入请求命令


# 参考

1. [10.Redis集群(cluster)](https://github.com/www6v/Learning-in-practice/tree/master/Redis/10.Redis%E9%9B%86%E7%BE%A4(cluster))
1.1[Redis集群介绍](https://github.com/www6v/Learning-in-practice/blob/master/Redis/10.Redis%E9%9B%86%E7%BE%A4(cluster)/1.Redis%E9%9B%86%E7%BE%A4%E4%BB%8B%E7%BB%8D.md)
1.2 [Redis Cluster](https://www.bilibili.com/video/BV13R4y1v7sP/?p=76)
1.3 [Redis Cluster](https://www.bilibili.com/video/BV13R4y1v7sP/?p=84) 
