---
title: Redis 混合持久化
date: 2023-07-10 15:48:29
tags:
  - KV
categories:
  - 数据库
  - KV
  - Redis
---

<p></p>
<!-- more -->


# Redis 混合持久化
### 数据恢复顺序和加载流程 [2][3]
![mix](./images/mix.jpg)

在这种情况下，  **当redis重启的时候会优先载入AOF文件来恢复原始的数据**  ，因为在通常情况下AOF文件保存的数据集要比RDB文件保存的数据集要完整。

RDB和AOF共存时会优先加载AOF文件

**【主从切换   优先加载  RDB  ->  速度】**
**【redis重启 优先加载 AOF -> 数据完整性】**

### 开启
  ``` 
  aof-use-rdb-preamble no -> yes
  ```

### 原理 [3]
RDB镜像做全量持久化，AOF做增量持久化 先使用RDB进行快照存储，然后使用AOF持久化记录所有的写操作，当重写策略满足或手动触发重写的时候，将最新的数据存储为新的RDB记录。
这样的话，重启服务的时候会从RDB和AOF两部分恢复数据，既保证了数据完整性，又提高了恢复数据的性能。简单来说:混合持久化方式产生的文件一部分是RDB格式，一部分是AOF格式。

#  AOF+RDB混合[1]
而**混合使用 RDB 和 AOF**，正好可以取两者之长，避两者之短，以较小的性能开销保证数据可靠性和性能。

# 参考
1. 《05丨内存快照：宕机后，Redis如何实现快速恢复？》 
2. [redis++：Redis持久化 rdb & aof 工作原理及流程图 （三）](https://www.cnblogs.com/wiseblog/articles/13540042.html)
3. [RDB-AOF混合持久化](https://github.com/www6v/Learning-in-practice/blob/master/Redis/4.Redis%E6%8C%81%E4%B9%85%E5%8C%96/9.RDB-AOF%E6%B7%B7%E5%90%88%E6%8C%81%E4%B9%85%E5%8C%96.md)
   [尚硅谷Redis零基础到进阶，最强redis7教程，阳哥亲自带练（附redis面试题）](https://www.bilibili.com/video/BV13R4y1v7sP/?p=45)





