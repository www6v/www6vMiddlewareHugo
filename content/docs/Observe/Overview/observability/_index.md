---
title: 可观测性 总结
date: 2019-08-31 11:54:42
tags:
  - 可观测性
categories:
  - 可观测性
  - 总结
---

<p></p>
<!-- more -->

**关键词**:  可观测性,  全链路,  APM， Metric， Log

# 可观测性
### 1.0-基础支柱 [1][3]
![metric-tracing-logging](https://user-images.githubusercontent.com/5608425/64059064-216a2880-cbe7-11e9-9ee7-141334d93959.png)


模式| 产品/框架 
:-:| :-: 
Log aggregation| **ELK**， AWS Cloud Watch 
Application metrics + alert| **Prometheus** 、AWS Cloud Watch 
Distributed tracing| Zipkin ，Jaeger，pinpoint（无侵入）, **skywalking**（无侵入）, CAT 
Exception tracking| Zipkin ，Jaeger，pinpoint（无侵入）, **skywalking**（无侵入）, CAT 

### 2.0-统一的可观测性平台[3]
+ OpenTelemetry - 数据采集传输的标准化

### 3.0-内生的可观测性能力[3]
+ 基于ebpf

#  监控指标和原则

+ USE 原则  [面向"资源监控指标"]
  + 利用率（Utilization），资源被有效利用起来提供服务的平均时间占比
  + 饱和度（Saturation），资源拥挤的程度，比如工作队列的长度
  + 错误率（Errors），错误的数量

+ RED 原则  [面向"服务监控指标"] 
  + 每秒请求数量（Rate）
  + 每秒错误数量（Errors）
  + 服务响应时间（Duration）

+ google 四个黄金监控指标  [面向服务]
  + 延迟    latancy
  + 通信量  throughtout
  + 错误    error
  + 饱和度  

# 可观测性-发展[4]
+ metric,log, tracing 之间的转换，tradeoff
  metric 是最经济的 cost少
  
+ zipkin 
  - follow dapper论文
  - 场景
    按需诊断，采样1%。 
  - 特性 
    集成适配各种系统
  - jaeger 
    golang版本的zipkin
  
+ Prometheus
  - 目标
    基础设施的监控
  - pull 
    成本低
  - 协议，数据类型
    counter , xxx, xxx,summary

+ pinpoint
  - 概念 独特
    定位公司内部问题

+ CAT
  - follow dapper
  - 纯sdk， 无agent
  - 多语言

+ openTelemetry
  - 是厂商的功能的最小集
        
## 参考
1. [Metrics, tracing 和 logging 的关系](https://wu-sheng.github.io/me/articles/metrics-tracing-and-logging)
2. xxx
3. [【云原生学院#25】云原生应用可观测性实践](https://www.bilibili.com/video/BV1CL411777R?spm_id_from=333.880.my_history.page.click)  github中有PPT ***

4. [开源可观测体系发展之路 - 吴晟 @ 得物技术沙龙](https://www.bilibili.com/video/BV1Bk4y1L7T2/) V *** 

1xx. [Monarch: 谷歌的全球级内存时序数据库](https://www.pianshen.com/article/96362082048/)   监控  未

