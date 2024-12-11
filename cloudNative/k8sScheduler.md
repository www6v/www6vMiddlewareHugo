---
title: Kubernetes调度器
date: 2019-06-09 12:27:44
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes  
---

<p></p>
<!-- more -->



##  资源调度泛型 [1]

<div style="text-align: center;">

![调度系统泛型](https://user-images.githubusercontent.com/5608425/65023010-96b65700-d964-11e9-9acd-7cc8edbbde85.JPG)
调度系统泛型
</div>


类型|	资源选择|	排他性|	分配粒度|	集群策略
-|-|-|-|-
中央调度器|	全局|	无，时序|	全局策略|	严格的优先级(抢占式) 
两层调度调度器|	动态资源集|	悲观锁|	增量囤积|	严格公正
共享状态|	全局|	乐观锁|	调度器策略|	优先级抢占

表1. 常见调度器的比较


##  Kubernetes 资源调度[2]
![k8s调度器](.\k8sScheduler\k8sScheduler.jpg)

## Kubernetes 调度的两个阶段[4][5]
##### 基于谓词和优先级的调度器（Predicates and Priorities） · v1.0.0 ~ v1.14.0
![基于谓词和优先级的调度器](.\k8sScheduler\predicates-and-priorities-scheduling.png)

+ 调度器扩展（Scheduler Extender） · v1.2.0 - Scheduler extension  
  通过调用外部调度器扩展的方式改变调度器的决策；

+ Map-Reduce 优先级算法 · v1.5.0 - MapReduce-like scheduler priority functions  
  为调度器的优先级算法支持 Map-Reduce 的计算方式，通过引入可并行的 Map 阶段优化调度器的计算性能；  

##### 基于调度框架的调度器（Scheduling Framework） · v1.15.0 ~ 至今
![基于调度框架的调度器](.\k8sScheduler\kubernetes-scheduling-queue.png)

+ 调度框架认为 Kubernetes 中目前存在调度（Scheduling）和绑定（Binding）两个循环：  
  调度循环在多个 Node 中为 Pod 选择最合适的 Node；  
  绑定循环将调度决策应用到集群中，包括绑定 Pod 和 Node、绑定持久存储等工作；  

+ 除了两个大循环之外，调度框架中还包含 QueueSort、PreFilter、Filter、PostFilter、Score、Reserve、Permit、PreBind、Bind、PostBind 和 Unreserve 11 个扩展点（Extension Point），这些扩展点会在调度的过程中触发。  

## 批量计算[3]
+ K8s自带的的资源调度器，有一个明显的特点是：依次调度每个容器。

+ Volcano  
  + DRF（dominant resource fairness）: Yarn和Mesos都有  
  DRF意为：“谁要的资源少，谁的优先级高”  
  +  Queue: Yarn调度器的功能  

## 实战[11]
+ 服务资源智能推算: crane+Victoria Metrics   
  +  Crane 调度器 [14]  
     crane-sheduler 基于prometheus集群真实资源负载进行调度，将其应用于调度过程中的 Filter 和 Score 阶段，能够有效缓解集群资源负载不均的问题，真正实现企业的降本增效。  
+ 二次调度:  descheduler [12][13]  
+ 弹性调度：  OpenKruise-WorkloadSpread + Virtual Kubelet  

## 参考
1. [《大数据日知录：架构与算法]()  第4章  张俊林
2. [《Kubenetes in Action》 第11章-机理 第16章-高级调度  七牛容器云团队](http://product.dangdang.com/26439199.html?ref=book-65152-9168_1-529800-3)
3. [为什么K8s需要Volcano？](https://mp.weixin.qq.com/s/_6WCgqxjTR1rAv8gQqNdWw) 华为


##### scheduling framework调度器 && 谓词
4. [调度系统设计精要](https://draveness.me/system-design-scheduler/) linux 调度器， go调度器， k8s调度器
5. [Kubernetes Scheduler 设计与实现](https://www.bilibili.com/video/BV1N7411w7M9) bili
   [第 76 期 Kubernetes Scheduler 设计与实现](https://github.com/talkgo/night/issues/535)  ***
   https://github.com/kubernetes/enhancements/issues/895 even pod, 多个region调度
6. [进击的 Kubernetes 调度系统（一）：Kubernetes scheduling framework](https://mp.weixin.qq.com/s/UkVXuZU0E0LT3LaDdZG4Xg)  未
7. [进击的 Kubernetes 调度系统（二）：支持批任务的 Coscheduling/Gang scheduling](https://blog.csdn.net/alisystemsoftware/article/details/107359341) 未


##### 基于谓词的调度器
8. [Kubernetes集群调度器原理剖析及思考](https://mp.weixin.qq.com/s/gfq1qghLW7g4gKZBBP17IA) - v1.11版本 2019
9. [深度解析Kubernetes核心原理之Scheduler](https://cloud.tencent.com/developer/article/1475940) 未 - KubeCon 2018   *** 
10. [DockOne微信分享（一四九）：Kubernetes调度详解 ](http://dockone.io/article/2885)  FreeWheel 主任工程师-2017年-***未

##### 实战
11. [容器云调度优化及实践](https://www.bilibili.com/video/BV1iD4y117JL?spm_id_from=333.880.my_history.page.click)  V
12. [descheduler 二次调度让 Kubernetes 负载更均衡](https://www.chenshaowen.com/blog/descheduler-makes-kubernetes-load-more-balanced.html)
13. [Kubernetes 中 Descheduler 组件的使用与扩展](https://blog.tianfeiyu.com/2022/06/30/kubernetes_descheduler/)
14. [Crane 调度器介绍——一款在 Kubernetes 集群间迁移应用的调度插件](https://cloudnative.to/blog/crane-scheduler/)
15. [【腾讯云Finops Crane集训营】降本增效神器Crane实战记录](https://tencentcloud.csdn.net/64f7f5a9993dd34278ee1114.html)