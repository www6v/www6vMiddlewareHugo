---
title: K8s 集成Springcloud
date: 2023-04-15 10:42:05
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes
---

<p></p>
<!-- more -->

#  Case1[2]
+ 架构
	+ nginx 结合 springcloud gateway  
	+ erueka + 本地配置

![arch1](.\k8sSpringcloud\arch1.png)


# Case2[1]
+ 架构
	+ k8s ingress 结合spring gateway
	+ spring-admin做服务注册, ConfigMap做服务配置

# Case3[3]
+ 架构
	+ k8s ingress 结合 zuul
	+ Eureka做服务注册， ConfigServer做服务配置

+ 网关 候选
  - zuul 需要使用
    Ingress中配置路由很麻烦
  
+ 服务配置 候选
  - 环境变量
  - Service
    mysql-svc
  - ConfigMap
  - apollo

+ 服务注册
  - 老项目
    改动Eureka会有风险，建议保留 Eureka
  - 新项目 [4]
    用istio envoy side 做 服务发现
  - 候选
    - Service
      基于CoreDNS的服务发现
    - Env
      基于环境变量的服务发现
      
# 参考
1. [云原生Java架构师的第一课K8s+Docker+KubeSphere+DevOps](https://www.bilibili.com/video/BV13Q4y1C7hS/?p=166)  166  V 
   [项目Repo](https://github.com/www6v/spring-cloud-bookinfo/) git
   
2. [SpringCloud微服务电商系统在Kubernetes集群中上线详细教程](https://blog.csdn.net/web18484626332/article/details/126516371)
   用的都是Deployment ，需要部署成StatefulSet
   
3. [kubernetes架构师课程](https://www.bilibili.com/video/BV16t4y1w7r6/?p=195) P195-P200 V 

4. [Go to Page](istioSpringcloud.md) self 