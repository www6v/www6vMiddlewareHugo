---
title: gRPC
date: 2022-03-21 09:43:56
tags:
  - 异步
categories:
  - 分布式 
  - 基础
  - rpc  
---

<p></p>
<!-- more -->


## gRPC
##### 通信[1]
+ 基于HTTP2连接，发送消息
+ protobuf做消息序列化

##### HTTP2 [2]
+ 优点
  + 头部压缩、多路复用   
  + stream,  frame

#####  gRPC的通信模式 [1]  
+ 一元RPC模式
+ 服务端 流式RPC模式
+ 客户端 流式RPC模式
+ 双向流RPC模式


## gRPC
##### grpc-java [1]

##### gRPC-go [3][4]
{% details gRPC-go %}  
[grpc-go server.go](https://github.com/grpc/grpc-go/blob/master/examples/route_guide/server/server.go)  
// Package main implements a simple gRPC server that demonstrates how to use gRPC-Go libraries  
// to perform unary, client streaming, server streaming and full duplex RPCs.  

{% enddetails %}

## 参考

1. [IT老齐的gRPC实战课](https://space.bilibili.com/359351574/channel/collectiondetail?sid=412936)
2. 《透视HTTP协议》《33 | 我应该迁移到HTTP/2吗？》
3. [grpc-go examples](https://github.com/grpc/grpc-go/tree/master/examples)
4. [#17 grpc 开发及 grpcp 的源码分析 【 Go 夜读 】](https://www.bilibili.com/video/BV1ht41187Wh/)     
