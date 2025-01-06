---
title: Redis 热点Hotkey
date: 2022-06-03 21:48:24
weight: 6
tags:
  - Redis
categories:
  - 数据库
  - KV
  - Redis
---

<p></p>
<!-- more -->

## HotKey

+ 寻找热点Key [2]
  + 客户端  [1]
    缺点: 只能统计单个客户端
  + 代理
    缺点:  代理端的开发部署成本
  + 服务端
    缺点:  monitor命令,  短时间用
  + 机器
    packetbeat 抓包
    缺点:  运维部署和机器成本
  
+ 解决热点key [2]
  - 拆分复杂数据结构
  - 迁移热点key
  - 本地缓存加通知机制  [3]
    使用二级缓存  [1]  

## 参考
1. [有赞透明多级缓存解决方案（TMC）](https://mp.weixin.qq.com/s?__biz=MzAxOTY5MDMxNA==&mid=2455759090&idx=1&sn=f9f0b49d7c1916672f9d4f63dab0c2b6)
2. 《Redis 开发与运维》  12.5
3. [京东 Redis 热点数据探测工具镜像](https://github.com/shiyindaxiaojie/hotkey)
   [京东毫秒级热key探测框架设计与实践，已实战于618大促](https://mp.weixin.qq.com/s/xOzEj5HtCeh_ezHDPHw6Jw)
100. [热点 Key 问题的发现与解决](https://help.aliyun.com/document_detail/67252.html) 阿里 文档  已失效

> 通常的解决方案主要集中在对**客户端**和**Server端**进行相应的改造。 
> I. 服务端本地缓存.
> II. 服务端分布式缓存。

> 阿里云方案 (整体看是用中间件 负载均衡 水平扩展)   
> I. 读写分离方案解决热读
> 写 热备; 读 存储水平扩展
> II. 热点数据解决方案
> 该方案通过主动**发现热点**并对其进行**存储**来解决热点Key的问题。

