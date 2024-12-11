---
title: 可观测性-Prometheus  HA
date: 2022-02-11 00:03:55
tags:
  - prometheus
categories: 
  - 可观测性
  - metric
---

<p></p>
<!-- more -->


## 高可用方案[1]

#####  高可用的几种方案

+ 基本 HA：即两套 Prometheus 采集完全一样的数据，外边挂负载均衡
+ HA + 远程存储：除了基础的多副本 Prometheus，还通过 Remote Write 写入到远程存储，解决存储持久化问题
+ 联邦集群：即 Federation，按照功能进行分区，不同的 Shard 采集不同的数据，由Global节点来统一存放，解决监控数据规模的问题。
+ 使用 Thanos 或者 Victoriametrics，来解决全局查询、多副本数据 Join 问题。

##### 问题
就算使用官方建议的多副本 + 联邦，仍然会遇到一些问题:

+ 官方建议数据做 Shard，然后通过Federation来实现高可用，
+ 但是边缘节点和Global节点依然是单点，需要自行决定是否每一层都要使用双节点重复采集进行保活。
    也就是仍然会有单机瓶颈。
+ 另外部分敏感报警尽量不要通过Global节点触发，毕竟从Shard节点到Global节点传输链路的稳定性会影响数据到达的效率，进而导致报警实效降低。
+ 例如服务Updown状态，Api请求异常这类报警我们都放在Shard节点进行报警。

##### 原因
本质原因是，Prometheus 的本地存储没有数据同步能力，要在保证可用性的前提下，再保持数据一致性是比较困难的，基础的 HA Proxy 满足不了要求，比如：

+ 集群的后端有 A 和 B 两个实例，A 和 B 之间没有数据同步。A 宕机一段时间，丢失了一部分数据，如果负载均衡正常轮询，请求打到A 上时，数据就会异常。
+ 如果 A 和 B 的启动时间不同，时钟不同，那么采集同样的数据时间戳也不同，就不是多副本同样数据的概念了
+ 就算用了远程存储，A 和 B 不能推送到同一个 TSDB，如果每人推送自己的 TSDB，数据查询走哪边就是问题了。

##### 解决方案  
+ 在**存储、查询**两个角度上保证数据的一致
   + **存储角度**：如果使用 **Remote Write 远程存储， A 和 B后面可以都加一个 Adapter，Adapter做选主逻辑，只有一份数据能推送到 TSDB，这样可以保证一个异常，另一个也能推送成功，数据不丢，同时远程存储只有一份，是共享数据**。方案可以参考这篇文章 
   + **查询角度**：上边的方案实现很复杂且有一定风险，因此现在的大多数方案在查询层面做文章，**比如 Thanos 或者 Victoriametrics，仍然是两份数据，但是查询时做数据去重和 Join**。只是 Thanos 是通过 Sidecar 把数据放在对象存储，Victoriametrics 是把数据 Remote Write 到自己的 Server 实例，但查询层 Thanos-Query 和 Victor 的 Promxy的逻辑基本一致。



## Thanos 
##### 组件
+ Bucket
+ Check
+ Compactor
+ Query
+ Rule
+ Sidecar
+ Store
+ receive
+ downsample

##### 特点
+ 为多集群Prometheus提供全局接口  
  全局视图  
+ 将监控数据存储到各种对象存储
+ 为Prometheus提供高可用
+ 易于与Prometheus集成并可模块化部署  

##### 模式
+ Sidecar(默认的模式)
  pull, remote read  
+ Receive  
  push, remote rewrite
  

## 参考
##### HA
1. [高可用 Prometheus：问题集锦](http://www.xuyasong.com/?p=1921)
2. [高可用 Prometheus：Thanos 实践](http://www.xuyasong.com/?p=1925) 
3. [第十八期: 玩转云原生容器场景的Prometheus监控]()  腾讯云 云原生正发声  #todo 重看一遍
4. [Thanos：开源的大规模Prometheus集群解决方案](http://dockone.io/article/6019)   失效
5. [基于 KubeSphere 和 Thanos 构建可持久化存储的多集群监控系统](https://kubesphere.com.cn/live/jinaai0602-live/)  失效
6. [打造云原生大型分布式监控系统(二): Thanos 架构详解](https://zhuanlan.zhihu.com/p/128658137)   imroc@腾讯云 ***
100. [Thanos与Cortex方案对比](https://viva.gitbook.io/project/cloud-native/prometheus/cun-chu-fang-an-cha-yi-dui-bi) 未
101. [Prometheus Thanos与Cortex组件比较](https://blog.csdn.net/sinat_32582203/article/details/121487648) 未
