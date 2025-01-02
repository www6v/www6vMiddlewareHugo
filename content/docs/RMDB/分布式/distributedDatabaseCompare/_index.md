---
title: 分布式 数据库 比较 
date: 2022-03-11 20:13:01
weight: 2
tags:
  - 分布式数据库
categories:  
  - 数据库
  - 关系型
  - 分布式
---

<p></p>
<!-- more -->



## 分布式 数据库 比较 [1]

|            | PolarDB-X                         | TiDB                        | CockroachDB                        | Spanner                                   |
| ---------- | --------------------------------- | --------------------------- | ---------------------------------- | ----------------------------------------- |
| 分布式事务 | MVCC+TSO                          | MVCC+TSO [Percolator][5][6] | MVCC+HLC[2][3][4]                  | MVCC+TrueTime API                         |
| 存储引擎   | InnoDB/x-engine<br> HEX2(列存)    | RocksDB<br/>TiFlash(列存)   | RocksDB                            | Colossus                                  |
| 高可用     | 计算无状态集群<br>存储Multi-Paxos | 计算无状态集群<br>存储Raft  | 计算存储一体化 集群化 <br>存储Raft | 计算存储一体化 集群化 <br>存储Multi-Paxos |
| 数据分区   | Hash/List/Range                   | Range/Hash                  | Range/Hash                         | Range/Hash                                |
| 全局索引   | √                                 | √                           | √                                  | √                                         |
| HTAP       | 强隔离 强一致<br>MPP并行          | 强隔离 强一致<br>Spark      | 混合负载<br> MPP并行               | 混合负载<br> MPP并行                      |
| 生态兼容性 | 基本兼容MySQL                     | 基本兼容MySQL               | 基本兼容PGSQL                      | 非标准SQL                                 |
| 元数据DDL  | 全局一致 + Online                 | 全局一致 + Online           | 全局一致 + Online                  | 全局一致 + Online                         |
| 全局日志   | √                                 | √                           | √（企业版）                        | ×                                         |
| 备份恢复   | √                                 | √                           | √                                  | √                                         |



## 参考

1. 《云数据库架构》 2.3.1
2. [CockroachDB分布式事务解密(一)：CockroachDB & HLC](https://www.modb.pro/db/84156)
   CockroachDB使用了一个软件实现的基于NTP时钟同步的混合逻辑时钟算法(Hybrid Logic Clock)——HLC追踪系统中事务的的hb关系(happen before)。
3. [CockroachDB事务解密(二)：事务模型](https://www.modb.pro/db/84153)
4. [Cockroach  HLC](https://github.com/cockroachdb/cockroach/blob/master/pkg/util/hlc/hlc.go)
5. {% post_link 'tikvMVCCTransaction' %}
6. {% post_link 'distributedDatabaseGlobalTime' %}  self
7. {% post_link ''globalSecondaryIndex %} self



