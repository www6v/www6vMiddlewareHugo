---
title: Kafka  Q&A
date: 2019-05-15 17:06:28
weight: 11
tags:
  - kafka  
categories: 
  - 消息系统
  - Kafka   
---

<p></p>
<!-- more -->


## 基础
+    Kafka的用途有哪些？使用场景如何？

+    Kafka中的ISR、AR又代表什么？ISR的伸缩又指什么

+    Kafka中的HW、LEO、LSO、LW等分别代表什么？


## topic
+    当你使用kafka-topics.sh创建（删除）了一个topic之后，Kafka背后会执行什么逻辑？

+    topic的分区数可不可以增加？如果可以怎么增加？如果不可以，那又是为什么？

+    创建topic时如何选择合适的分区数？

+    Kafka目前有那些内部topic，它们都有什么特征？各自的作用又是什么？

+    Kafka有哪几处地方有分区分配的概念？简述大致的过程及原理

## Producer
+    ~~Kafka中的分区器、序列化器、拦截器是否了解？它们之间的处理顺序是什么？~~
+    ~~Kafka生产者客户端中使用了几个线程来处理？分别是什么？~~

## 特性

+    聊一聊Kafka的延时操作的原理  
	[Kafka科普系列 | 轻松理解Kafka中的延时操作](https://hiddenpps.blog.csdn.net/article/details/89325701)  
	这里就涉及到了Kafka延迟操作的概念。Kafka在处理拉取请求时，会先读取一次日志文件，如果收集不到足够多（fetchMinBytes，由参数fetch.min.bytes配置，默认值为1）的消息，那么就会创建一个延时拉取操作（DelayedFetch）以等待拉取到足够数量的消息。当延时拉取操作执行时，会再读取一次日志文件，然后将拉取结果返回给follower副本。  
	延迟操作不只是拉取消息时的特有操作，在Kafka中有多种延时操作，比如延时数据删除、延时生产等。  

+    Kafka中的延迟队列怎么实现（这题被问的比事务那题还要多！！！听说你会Kafka，那你说说延迟队列怎么实现？）

+    Kafka中是怎么体现消息顺序性的？

+    Kafka的那些设计让它有如此高的性能？

## 补齐
+    Kafka中怎么实现死信队列和重试队列？

+    Kafka中怎么做消息审计？

+    Kafka中怎么做消息轨迹？

## 监控
+    Kafka中有那些配置参数比较有意思？聊一聊你的看法

+    Kafka有哪些指标需要着重关注？

## 其他    
+    在使用Kafka的过程中遇到过什么困难？怎么解决的？

+    还用过什么同质类的其它产品，与Kafka相比有什么优缺点？

+    Kafka有什么优缺点？  


[Kafka总结](../../../../2016/05/11/kafka/) 