---
title: Redis 回收策略
date: 2021-06-02 11:42:46
weight: 2
tags:
  - KV
categories:
  - 数据库
  - KV
  - Redis
---

<p></p>
<!-- more -->

[kafka-size]:https://user-images.githubusercontent.com/5608425/66014512-ca1ae900-e501-11e9-93d7-840409a862c5.png
[kafka-time]:https://user-images.githubusercontent.com/5608425/66014513-cab37f80-e501-11e9-9b2c-917838d91a4d.png
[kafka-offset]:https://user-images.githubusercontent.com/5608425/66014514-cab37f80-e501-11e9-9be8-a247690b5f9f.png

##  回收策略
 回收策略       | redis   | kafka    
 :-:     | :-:     | :-:       
 基于时间 | 过期删除策略 <br>1. 定时删除(对内存最友好， 对CPU时间最不友好) <br>2. 惰性删除(对CPU时间最友好， 对内存最不友好) <br>3.定期删除(整合和折中)  | ![kafka-time]  
 基于大小 | 内存淘汰策略 <br>1. noeviction <br>2.lru <br>3. random <br>4. ttl  | ![kafka-size]
 其他 | x  | ![kafka-offset]  

+ 近似LRU算法[11]


# 参考
7. [七问Redis，才知道我与技术大牛的差距在哪里 ](https://mp.weixin.qq.com/s?__biz=MzI4NTA1MDEwNg==&mid=2650780240&idx=1&sn=49fb636a97a3c21fec7d2e2b59bea09f) ***

11. [经典面试题：Redis 内存满了怎么办？](https://mp.weixin.qq.com/s/gkkjJu04sS2qtRdd-yB5DQ)

### 回收策略
10. [Redis内存回收机制，把我整懵了...](http://mp.weixin.qq.com/s?__biz=MjM5ODI5Njc2MA==&mid=2655826994&idx=2&sn=c7efe2b7cdd350f1b3c6fb72cc8c1cd7)
11. [Kafka日志清理之Log Deletion](https://blog.csdn.net/u013256816/article/details/80418297)
12. 《Redis 开发与运维》  8.2.3  未





