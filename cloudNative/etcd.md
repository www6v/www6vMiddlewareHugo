---
title: etcd 总结
date: 2022-04-06 21:19:30
tags:
  - etcd
categories: 
  - 数据库
  - KV
  - etcd
---


<p></p>
<!-- more -->



## 读流程 [3]
![读流程](.\etcd\read1.png)

一个读请求从 client 通过 Round-robin 负载均衡算法，选择一个-etcd server 节点，发出 gRPC 请求，经过 etcd server 的 KVServer 模块、线性读模块、MVCC 的 treeIndex 和 boltdb 模块紧密协作，完成了一个读请求。  

etcd 提供的两种读机制 (串行读和线性读)   

## 写流程[4]
![写流程](.\etcd\write.png)

 etcd 的写请求流程，重点介绍了 Quota、WAL、Apply 和 MVCC 模块。Quota 模块会防止 db 大小超限，WAL 模块保证了集群的一致性和可恢复性，Apply 模块实现了幂等性，MVCC 模块维护索引版本号和内存索引结构。etcd 通过异步、批量提交事务机制提升写 QPS 和吞吐量。这些模块相互协作，实现了在节点遭遇 crash 等异常情况下，不丢任何已提交的数据、不重复执行任何提案。[N AI]

## 客户端Lease [5]
![客户端Lease](.\etcd\lease.png)

etcd 的 Lessor 模块在启动时会创建两个常驻 goroutine，分别用于检查过期 Lease 并撤销，以及定时更新 Lease 的剩余到期时间。该模块提供了 Grant、Revoke、LeaseTimeToLive 和 LeaseKeepAlive API，用于创建、撤销、获取有效期和续期 Lease。[N AI]  


## MVCC 和 revision[2]
+ etcd revision  
  - 定义   
    - 计数器  
    - 键值空间发生变化， revision相应增加  
  - 用途  
    - 逻辑时钟  
    - **MVCC**  

## 参考
1. [第16 章 ： 深入理解 etcd - 基本原理解析](https://edu.aliyun.com/lesson_1651_18365#_18365) 未
2. 《云原生分布式存储基石-etcd深入解析》
3. 《02 | 基础架构：etcd一个读请求是如何执行的？》
4. 《03丨基础架构：etcd一个写请求是如何执行的？》
5. 《06 | 租约：如何检测你的客户端存活？》



