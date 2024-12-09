---
title: Kubernetes声明式API
date: 2019-08-29 18:15:25
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes
---

<p></p>
<!-- more -->

   ![声明式API](.\k8sDeclarativeAPI\ks8-declarative-api.jpg )

## 一. CRD
```
# CRD的定义和使用
$ tree
.
├── controller.go                + 自定义控制器： 拿到“实际状态”，然后拿它去跟“期望状态”做对比，执行“业务逻辑”
├── crd
│ └── network.yaml               + resource的定义【像类定义】
├── example
│ └── example-network.yaml       + resource的使用【像类实例】
├── main.go
└── pkg
	├── apis
	│ 	└── samplecrd              + group 
	│ 		├── constants.go
	│ 		└── v1                 + version
	│ 			├── doc.go         + 代码生成，Global Tag 
	│ 			├── register.go    + 注册类型（Type）到APIServer中，全局变量
	│ 			├── types.go       + 类型有哪些字段
	│ 			└── zz_generated.deepcopy.go    【codegenerated】
	└── client       +for自定义控制器【codegenerated】：  拿到“期望状态” 
		├── clientset
		├── informers  + 见下图
		└── listers    + 见下图
```

## 二. 自定义控制器 
<div style="text-align: center;">

![自定义控制器](https://user-images.githubusercontent.com/5608425/64071488-e7b02500-ccad-11e9-927e-dd71af8c3923.jpg)  自定义控制器
</div>

>+Informer就是一个自带缓存和索引机制，可以触发 Handler 的客户端库。这个本地缓存在 Kubernetes 中一般被称为 Store，索引一般被称为 Index。
 +Informer 使用了 Reflector 包，它是一个可以通过 ListAndWatch 机制获取并监视 API 对象变化的客户端封装。
 +Reflector 和 Informer 之间，用到了一个“增量先进先出队列”进行协同。而 Informer 与你要编写的控制循环之间，则使用了一个工作队列来进行协同。

>+在实际应用中，除了控制循环之外的所有代码，实际上都是 Kubernetes 为你自动生成的，即：pkg/client/{informers, listers, clientset}里的内容。
 +这些自动生成的代码，就为我们提供了一个可靠而高效地获取 API 对象“期望状态”的编程库。
 +所以，接下来，作为开发者，你就只需要关注如何拿到“实际状态”，然后如何拿它去跟“期望状态”做对比，从而决定接下来要做的业务逻辑即可。  /// controller.go


## 参考:
1. 《深入剖析Kubernetes  - 23  声明式API与Kubernetes编程范式》  张磊 
2. 《深入剖析Kubernetes  - 24  深入解析声明式API（一）：API对象的奥秘》  张磊
3. 《深入剖析Kubernetes  - 25  深入解析声明式API（二）：编写自定义控制器》  张磊
4. [Kubernetes 准入控制 Admission Controller 介绍](https://juejin.im/post/5ba3547ae51d450e425ec6a5)
5. [CRD 代码示例](https://github.com/resouer/k8s-controller-custom-resource)
6. [k8s自定义controller三部曲之一:创建CRD（Custom Resource Definition）](https://blog.csdn.net/boling_cavalry/article/details/88917818) 一、二、三