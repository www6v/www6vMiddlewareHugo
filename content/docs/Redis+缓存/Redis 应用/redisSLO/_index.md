---
title: Redis SLO
date: 2022-04-27 21:54:37
weight: 3
tags:
  - Redis
categories: 
  - 数据库
  - KV
  - Redis
---

<p></p>
<!-- more -->

## SLO
- 命中率 Hit Ratio
  + 每秒命中数量   
  + 每秒未命中数量
- 吞吐 Throughput
  + 操作数
- 延迟
  + 命令执行平均耗时
- 容量 
  + expiring/not expiring   keys
  + expired/evicted keys
- 内存使用率 Memory Utilization
- 活动连接数 Active Connections

## 参考
1. [部署一个redis exporter监控所有的Redis实例](https://blog.51cto.com/wutengfei/6026334)
2. [6 Crucial Redis Monitoring Metrics You Need To Watch](https://scalegrid.io/blog/6-crucial-redis-monitoring-metrics/)