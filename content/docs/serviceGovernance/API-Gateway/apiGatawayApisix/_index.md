---
title: API 网关-apisix
date: 2022-03-22 13:58:23
tags:
  - API Gateway
categories: 
  - 服务治理
  - API网关    
---

<p></p>
<!-- more -->

## apisix特性
+ Core
  + api聚合
  + 灰度发布
+ 稳定性
  + 服务熔断
  + 故障注入
  + 流量复制
+ 云原生
  + 多云，混合云
  + 容器友好
  + 随意扩缩容

## apisix功能
+ 动态配置，不用reload  
  路由, ssl证书，上游，插件...  
+ 插件化(40个)  
  身份验证, 安全, 日志, 可观察性...  
+ 对接Prom，zipkin， skywalking
+ grpc代理和协议转换(rest <-> gprc)
+ apisix只用了nginx的网络层

## apisix使用场景

+ 处理L4, L7层流量
+ 代替nginx处理南北流量
+ 代替envoy处理东西流量
+ k8s ingress controller

## 参考
+ [【云原生学院 #3】基于 Apache APISIX 的全流量 API 网关](https://www.bilibili.com/video/BV1Gt4y1q7qC?vd_source=f6e8c1128f9f264c5ab8d9411a644036) ***
