---
title: Kubernetes Deployment
date: 2022-02-16 19:56:27
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes  
---

<p></p>
<!-- more -->



## Deployment
   ![Kubenetes服务部署](.\k8sDeployment\k8sDeployment.jpg)
1. Pod-template-hash label
2. Rolling Update Deployment
   Max Surge
   Max Unavailable
   
## Argo Rollouts [5]
Argo Rollouts 是一个 Kubernetes 控制器，它提供了在应用程序部署过程中执行渐进式发布和蓝绿部署等高级部署策略的能力。它是基于 Kubernetes 原生的 Deployment 资源构建的，通过引入新的 Rollout 资源来扩展和增强部署控制。

## 参考 
Deployment D
1. [如何在 Kubernetes 中对无状态应用进行分批发布](https://www.infoq.cn/article/oyjoCIZBpxw*dI21AXPI)  阿里 孙齐（代序）
2. [第6 章 ： 应用编排与管理： Deployment](https://edu.aliyun.com/lesson_1651_13081?spm=5176.10731542.0.0.e7a120beywNIVX#_13081)  阿里
3. [kubernetes 最佳实践：优雅热更新](https://tencentcloudcontainerteam.github.io/2019/05/08/kubernetes-best-practice-grace-update/)  陈鹏
4. [Deployment](https://jimmysong.io/kubernetes-handbook/concepts/deployment.html) jimmysong
5. [Argo Rollouts 中文文档](https://lib.jimmysong.io/argo-rollouts/)  jimmysong