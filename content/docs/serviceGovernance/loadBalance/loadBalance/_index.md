---
title: 负载均衡-算法
date: 2022-05-06 11:29:37
tags:
  - 负载均衡
categories:
  - 中间件
  - 负载均衡
---

<p></p>
<!-- more -->


# 负载均衡算法
### LVS[1][2]

| 组件 | 类型     | 负载均衡算法                                                 | 场景                                                         |
| ---- | -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| LVS  | **静态** | RR：roundrobin [常用]                                        | 轮询机制                                                     |
|      |          | WRR：Weighted RR [常用]                                      | 加权轮询，权重越大承担负载越大                               |
|      |          | SH：Source Hashing 源地址哈希                                | 实现session sticky<br/>缺点：调度粒度大，对负载均衡效果差；  |
|      |          | DH：Destination Hashing 目标地址哈希                         |                                                              |
|      | **动态** | LC：least connections                                        | 适用于长连接应用<br>`Overhead=activeconns*256+inactiveconns` |
|      |          | WLC：Weighted LC  [常用]                                     | 默认调度方法,较常用（加上了权重）<br>`Overhead=(activeconns*256+inactiveconns)/weight` |
|      |          | [SED](https://so.csdn.net/so/search?q=SED&spm=1001.2101.3001.7020)：Shortest Expection Delay | `Overhead=(activeconns+1)*256/weight`                        |
|      |          | NQ：Never Queue，                                            | 第一轮均匀分配，后续SED<br/>***\*SED\****算法改进            |
|      |          | LBLC：Locality-Based LC                                      | 动态的 ***\*DH\****连接算法                                  |
|      |          | LBLCR：LBLC with Replication                                 | 带复制功能的LBLC                                             |
|      |          |                                                              |                                                              |

###  Nginx [3]

| 组件  | 类型          | 负载均衡算法         | 场景                                                         |
| ----- | ------------- | -------------------- | ------------------------------------------------------------ |
| Nginx | **静态**<br/> | 轮询<br/>            | 每个请求按时间顺序逐一分配到不同的后端服务器，如果后端服务器 down 掉，能自动剔除 |
|       |               | 加权轮询<br/>        | 指定轮询几率，weight 和访问比率成正比，用于后端服务器性能不均的情况 |
|       |               | IP Hash<br/>         | 每个请求按访问 ip 的 hash 结果分配，这样每个访客固定访问一个后端服务器，可以解决 session 的问题 |
|       | **动态**<br/> | Fair （第三方）<br/> | 按后端服务器的响应时间来分配请求，响应时间短的优先分配       |
|       |               | url_hash（第三方）   | 按访问 url 的 hash 结果来分配请求，使每个 url 定向到同一个后端服务器，后端服务器为缓存时比较有效 |
|       |               | Least Connections    |                                                              |



###  HAproxy

| 组件    | 类型          | 负载均衡算法           | 场景 |
| ------- | ------------- | ---------------------- | ---- |
| HAproxy | **静态**<br/> | 轮询<br/>              |      |
|         |               | 加权轮询<br/>          |      |
|         |               | IP Hash<br/>           |      |
|         | **动态**<br/> | Least Connections<br/> |      |
|         |               | Source                 |      |



# LVS工作模式[11-16]
  - DR
  - TUN模式
  - NAT模式

# 参考
1. [LVS负载均衡集群服务搭建详解](https://demo.dandelioncloud.cn/article/details/1547407561087266818)      
2. [LVS调度算法总结](https://blog.csdn.net/aa896517050/article/details/125399055)
3. [LVS、Nginx 及 HAProxy 的区别](https://blog.csdn.net/weixin_42073629/article/details/109440892)
 [LVS集群的负载调度](http://www.linuxvirtualserver.org/zh/lvs4.html)  ***  未



### LVS工作模式
11. [LVS三种模式的区别及负载均衡算法](https://www.likecs.com/show-739972.html)
12. [LVS 介绍以及配置应用](https://www.likecs.com/show-307061337.html) ***
13. [深入浅出 LVS 负载均衡（一）NAT、FULLNAT 模型原理](https://zhuanlan.zhihu.com/p/363346400)  未
14. [深入浅出 LVS 负载均衡（二）DR、TUN 模型原理](https://zhuanlan.zhihu.com/p/377090230)  未
15. [深入浅出 LVS 负载均衡（三）实操 NAT、TUNNEL 模型](https://zhuanlan.zhihu.com/p/381297341)  未
16. [深入浅出 LVS 负载均衡（四）实操 DR 模型、Keepalived DR 模型的高可用](https://zhuanlan.zhihu.com/p/356354676)  未