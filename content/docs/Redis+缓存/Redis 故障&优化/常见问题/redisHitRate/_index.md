---
title: Redis  命中率
date: 2022-07-31 17:13:43
weight: 7
tags:
  - KV
categories:
  - 数据库
  - KV
  - Redis
---

<p></p>
<!-- more -->


# 命中率不高
会增加接口响应时间

# 提高redis命中率 [3][4]

+ 缓存粒度
  缓存粒度越小，命中率越高
+  合理调整缓存有效期的时间
  避免缓存同时失效
+ 预加载
+ 防止缓存击穿和穿透[5]
+ 增加存储容量
  容量不足时会触发Redis内存淘汰机制
  - 清空策略 [6]
   FIFO(first in first out)
    LFU(less frequently used)
    LRU(least recently used)
  
   
# 参考
3. [如何提高redis缓存命中率](https://segmentfault.com/a/1190000023730820)
4. [关于如何提高缓存命中率（redis）](https://www.cnblogs.com/chenhaoyu/p/11308753.html)
5. {% post_link 'redisReliability-1' %} self
6. [缓存那些事](https://tech.meituan.com/2017/03/17/cache-about.html)