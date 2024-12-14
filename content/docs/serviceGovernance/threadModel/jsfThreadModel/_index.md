---
title: 京东服务框架JSF服务提供者线程模型
date: 2015-07-09 17:14:28
tags:
 - 服务框架 
 - 多线程
categories: 
  - 服务治理
  - 案例-京东JSF  
---

<p></p>
<!-- more -->

# 京东服务框架JSF 
JSF是京东基础架构组的服务化中间件产品，全名是Jingdong Service Framework（中文名：杰夫）。
JSF整体是依据netty来构建的，本文从代码层面简单介绍一下JSF服务端的线程模型。

### 1.JSF的服务端线程模型整体上是 boss线程池 + worker线程池 + 业务线程池。boss线程池和worker线程池称为Reactor线程池。

三类线程池各自的参数详见下图1。

worker线程池和业务线程池之间的关系详见下图2，在图中可以看到业务线程和worker线程是解耦的，请求放入业务线程后，IO线程即worker线程就返回了，业务线程和I/O线程隔离。 在没有解耦IO线程和业务ChannelHandler的情况时，如果在业务ChannelHandler中进行数据库等同步I/O操作，很有可能会导致IO线程中的pipeline链路被阻塞。

![图1 三类线程池各自的参数](./images/jsf线程模型_参数.jpg)


![图2 worker线程池和业务线程池关系](http://www6v.github.io/www6vHome/jsf%20%E7%BA%BF%E7%A8%8B%E6%A8%A1%E5%9E%8B/netty%20%E7%BA%BF%E7%A8%8B%E6%A8%A1%E5%9E%8B.png "图2 worker线程池和业务线程池关系")
         

### 2. 图3是boss线程池， 线程数为Max(4,cpu/2)，用户不可以配置



![图3 boss线程池](http://www6v.github.io/www6vHome/jsf%20%E7%BA%BF%E7%A8%8B%E6%A8%A1%E5%9E%8B/boss%E7%BA%BF%E7%A8%8B%E6%B1%A0.JPG "图3 boss线程池")
         

### 3. 图4是worker线程池， 线程数为Max(8,cpu+1)，用户可以配置


![图4 worker线程池](http://www6v.github.io/www6vHome/jsf%20%E7%BA%BF%E7%A8%8B%E6%A8%A1%E5%9E%8B/worker%E7%BA%BF%E7%A8%8B%EF%BC%88io%E7%BA%BF%E7%A8%8B%EF%BC%89.JPG "图4 worker线程池")
         

### 4.图5和图6是业务线程池的构建，cached线程池大小是20-200，默认queue的大小是0。 任务来了直接分配线程，直到线程池满，得不到执行线程抛异常。

图7中一个服务端口对应一个业务线程池。



![图5 业务线程池构建1](http://www6v.github.io/www6vHome/jsf%20%E7%BA%BF%E7%A8%8B%E6%A8%A1%E5%9E%8B/%E4%B8%9A%E5%8A%A1%E7%BA%BF%E7%A8%8B%E6%B1%A0-%E5%88%9D%E5%A7%8B%E5%8C%961.JPG "图5 业务线程池构建1")
         

![图6 业务线程池构建2](http://www6v.github.io/www6vHome/jsf%20%E7%BA%BF%E7%A8%8B%E6%A8%A1%E5%9E%8B/%E4%B8%9A%E5%8A%A1%E7%BA%BF%E7%A8%8B%E6%B1%A0-%E5%88%9D%E5%A7%8B%E5%8C%962.JPG "图6 业务线程池构建2")
         

![图7 服务端口和业务线程池的关系](http://www6v.github.io/www6vHome/jsf%20%E7%BA%BF%E7%A8%8B%E6%A8%A1%E5%9E%8B/%E4%B8%9A%E5%8A%A1%E7%BA%BF%E7%A8%8B%E6%B1%A0-%E6%9E%84%E5%BB%BA.JPG "图7 服务端口和业务线程池的关系")
         

### 5. 在ChannelPipeline中ServerHandler根据服务端的配置获取对应的业务线程池，然后在ServerHandler的handlerRequest中提交业务任务，默认的任务是JSFTask。

具体实现如图8,9,10.


![图8 ServerHandler中获取业务线程池](http://www6v.github.io/www6vHome/jsf%20%E7%BA%BF%E7%A8%8B%E6%A8%A1%E5%9E%8B/%E4%B8%9A%E5%8A%A1%E7%BA%BF%E7%A8%8B%E6%B1%A0-%E8%8E%B7%E5%8F%96.JPG "图8 ServerHandler中获取业务线程池")
         


![图9 ServerHandler中提交业务任务](http://www6v.github.io/www6vHome/jsf%20%E7%BA%BF%E7%A8%8B%E6%A8%A1%E5%9E%8B/%E6%8F%90%E4%BA%A4task%E5%88%B0%E4%B8%9A%E5%8A%A1%E7%BA%BF%E7%A8%8B.JPG "图9 ServerHandler中提交业务任务")
         


![图10 提交task到业务线程Executor](http://www6v.github.io/www6vHome/jsf%20%E7%BA%BF%E7%A8%8B%E6%A8%A1%E5%9E%8B/%E4%B8%9A%E5%8A%A1%E7%BA%BF%E7%A8%8B%E6%89%A7%E8%A1%8Ctask.JPG "图10 提交task到业务线程Executor")
         


可以看到，JSF服务提供者线程模型整体还是按照boss+worker+biz这种netty官方推荐的方式构建的。

 

## 参考：

1. 京东 jsf 源代码和文档
2. Netty案例集锦之多线程篇（续） 李林锋