---
title: Redis 架构 *
date: 2021-05-25 18:35:49
weight: 1
tags:
  - Redis
categories:
  - 数据库
  - KV
  - Redis
---

<p></p>
<!-- more -->

## 目录
<!-- toc -->

# Redis架构演进[1]
+ **数据怕丢失** -> 持久化（RDB/AOF）
+ **恢复时间久** -> 主从副本（副本随时可切）
+ **故障手动切换慢** -> 哨兵集群（自动切换）
+ **读存在压力** -> 扩容副本（读写分离）
+ **写存在压力/容量瓶颈** -> 分片集群
   - **分片集群社区方案** ->  Twemproxy、Codis（Redis 节点之间无通信，需要部署哨兵，可横向扩容）
   - **分片集群官方方案** ->  Redis Cluster （Redis 节点之间 Gossip 协议，无需部署哨兵，可横向扩容）
+ **业务侧升级困难** -> Proxy + Redis Cluster（不侵入业务侧）



# 主从架构
+ 主从同步
	- 异步方式来同步数据
		- 最终一致性
	- 分类
		- 1. 增量同步 （同步的是指令）
			- 1.指令记录在master本地的内存 buffer
			- 2.异步将 buffer 中的指令同步到从节点
			- 类似 AOF
		- 2. 快照同步（同步的是内容，全量同步）
			- bgsave存磁盘rdb，然后rdb发到slave，slave装载
			- 优化: 2.8.18 版开始支持无盘复制


#  哨兵集群 sentinel
   master-slave异步复制, 所以会丢消息

```   
   参数: 
   # 至少有一个slave复制
   min-slaves-to-write 1   
   # slave节点最大10s的延迟
   min-slaves-max-lag 10   
```

#  Redis cluster
**整体架构**
1. 去中心化的;
2. 所有数据划分为16384个slots，每个节点负责其中一部分slots;

**容错**
1. 主从容错，主升从。
2. PFail（Possibly Fail） -> 临时不可用
   Fail -> 确定不可用， PFail Count> 集群的1/2

**Gossip**协议
集群节点采用 Gossip 协议来广播自己的状态以及自己对整个集群认知的改变;
可能下线 (PFAIL-Possibly Fail) && 确定下线 (Fail)

**slot迁移**
在迁移过程中，客户端访问的流程会有很大的变化。
迁移是会影响服务效率的，同样的指令在正常情况下一个 ttl 就能完成，而在迁移中得 3 个 ttl 才能搞定。

**网络抖动**
```
# 表示当某个节点持续 timeout 的时间失联时，才可以认定该节点出现故障
cluster-node-timeout 
```

**槽位迁移感知**
2个error指令
1.**MOVED错误**：  用来纠正槽位
  槽的负责权已经从一个节点转移到了另一节点
2. **ASK错误， ASKING命令**： 用来临时纠正槽位
    只是两个节点在迁移槽的过程中使用的一种临时措施

# 参考
1. [一文搞懂 Redis 架构演化之路](https://zhuanlan.zhihu.com/p/543953543) 腾讯 *** 

《Redis 深度历险：核心原理与应用实践》 钱文品
3. 原理 8：有备无患 —— 主从同步
~~4. 原理 3：未雨绸缪 —— 持久化~~
5. 集群 1：李代桃僵 —— Sentinel
6. 集群 3：众志成城 —— Cluster

