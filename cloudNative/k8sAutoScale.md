---
title: Kubernetes自动伸缩和HPA
date: 2019-11-16 11:55:37
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes  
---

<p></p>
<!-- more -->

![Kubernetes自动伸缩](.\k8sAutoScale\k8sAutoScale.jpg)


## 一. Core metrics(核心指标)  
![hpa3](https://user-images.githubusercontent.com/5608425/68987952-a3730080-086a-11ea-9a69-6b2c41de98ed.JPG)


kubernetes的新监控体系中，metrics-server属于**Core metrics(核心指标)**，提供API metrics.k8s.io，仅提供Node和Pod的CPU和内存使用情况。而其他Custom Metrics(自定义指标)由Prometheus等组件来完成. 
图14-3 14-5 14-6 基于Core metrics(核心指标)

![hpa1](https://user-images.githubusercontent.com/5608425/68987950-a3730080-086a-11ea-83b8-1b6e06e3c659.jpg)

##### kube-aggregator

有了Metrics Server组件，也采集到了该有的数据，也暴露了api，但因为api要统一，如何将请求到api-server的/apis/metrics请求转发给Metrics Server呢，解决方案就是：kube-aggregator,在k8s的1.7中已经完成，之前Metrics Server一直没有面世，就是耽误在了**kube-aggregator**这一步。

kube-aggregator（聚合api）主要提供：  
Provide an API for registering API servers.  
Summarize discovery information from all the servers.  
Proxy client requests to individual servers.  

##### Metrics Server
**metric-server是扩展的apiserver.**  
**Metrics Server**: metric-aggregator, 聚合metric。  
**Metrics Server** 是集群级别的资源利用率数据的**聚合器（ aggregator ）**。Metrics Server 通过Kubernetes 聚合器（ **kube-aggregator**）**注册**到主API Server 之上，而后基于kubelet 的Summary API 收集每个节点上的指标数据，并将它们存储于内存中然后以指标API 格式提供。  



##### metric api
metric api的使用：  
Metrics API 只可以查询当前的度量数据，并不保存历史数据  
Metrics API URI 为 /apis/metrics.k8s.io/，在 k8s.io/metrics 维护  
必须部署 metrics-server 才能使用该 API，metrics-server 通过调用 Kubelet Summary API 获取数据

## 二.  自定义指标（Custom Metrics）与Prometheus

![hpa5](https://user-images.githubusercontent.com/5608425/68987954-a40b9700-086a-11ea-985a-10d423d2cd15.JPG)

Kubernetes 里的 Custom Metrics 机制，是借助 **Aggregator APIServer 扩展机**制来实现的。这里的具体原理是，当你把 Custom Metrics APIServer 启动之后，Kubernetes里就会出现一个叫作custom.metrics.k8s.io的 API。而当你访问这个 URL 时，Aggregator 就会把你的请求转发给 Custom Metrics APIServer 。**而 Custom Metrics APIServer 的实现，其实就是一个 Prometheus 项目的 Adaptor**。


目前Kubernetes中自定义指标一般由Prometheus来提供，再利用**k8s-prometheus-adapter**聚合到apiserver，实现和核心指标（metric-server)同样的效果

Prometheus可以采集其它各种指标，但是prometheus采集到的metrics并不能直接给k8s用，因为两者数据格式不兼容，因此还需要另外一个组件(**kube-state-metrics**)，将prometheus的metrics数据格式转换成k8s API接口能识别的格式，转换以后，因为是自定义API，所以还需要用Kubernetes aggregator在主API服务器中注册，以便直接通过/apis/来访问。  

**文件清单**：  
node-exporter：prometheus的export，收集Node级别的监控数据  
prometheus：监控服务端，从node-exporter拉数据并存储为时序数据。  
kube-state-metrics：将prometheus中可以用PromQL查询到的指标数据转换成k8s对应的数  
k8s-prometheus-adapter：聚合进apiserver，即一种custom-metrics-apiserver实现  
开启Kubernetes aggregator功能（参考上文metric-server）  


## 三. HPA

![hpa2](https://user-images.githubusercontent.com/5608425/68987951-a3730080-086a-11ea-82d6-78ba5efcdfa5.jpg)


## 四. 实战

+ [HPA](https://github.com/rootsongjc/kubernetes-handbook/tree/master/manifests/HPA) 基于http_requests
+ [custom metrics](https://yasongxu.gitbook.io/container-monitor/yi-.-kai-yuan-fang-an/di-1-zhang-cai-ji/custom-metrics)
  [容器监控实践—Custom Metrics](http://www.xuyasong.com/?p=1520)


## 参考:
1. 《Kubernetes进阶实战》 马永亮
2. 《深入剖析Kubernetes - 49  Custom Metrics 让Auto Scaling不再“食之无味”》  张磊
3. [container-monitor](https://github.com/www6v/container-monitor) git
4. [metrics-server](https://yasongxu.gitbook.io/container-monitor/yi-.-kai-yuan-fang-an/di-1-zhang-cai-ji/metrics-server)











