---
title: Redis NVM
date: 2022-05-14 20:49:50
tags:
  - Redis
categories: 
  - 数据库
  - KV  
  - Redis
---

<p></p>
<!-- more -->


## 特点
+ 能持久化保存数据
+ 读写速度和 DRAM 接近
+ 容量大


## Intel Optane AEP 内存条(简称 AEP 内存)
+ Memory 模式
  软件系统能使用到 的内存空间，就是 AEP 内存条的空间容量。
  在 Memory 模式时，Redis 可以利用 NVM 容量大的特点，实现大容量实例，保存更 多数据。

+ App Direct 模式
  使用了 App Direct 模式的 AEP 内存，也叫 做持久化内存(Persistent Memory，PM)。

  Redis 可以直接在持久化内存上进行数据读写，在这 种情况下，Redis 不用再使用 RDB 或 AOF 文件了，数据在机器掉电后也不会丢失。
  而且，实例可以直接使用持久化内存上的数据进行恢复，恢复速度特别快。


## 参考：
40 | Redis的下一步:基于NVM内存的实践   