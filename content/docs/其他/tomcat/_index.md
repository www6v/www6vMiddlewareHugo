---
title: Tomcat总结
date: 2020-08-08 22:38:36
tags:
  - Tomcat
categories:
  - 中间件
  - Tomcat
---

<p></p>
<!-- more -->

##  Tomcat 架构
<div style="text-align: center; width: 60%">

![tomcat组件](https://user-images.githubusercontent.com/5608425/64508350-cedbeb00-d30f-11e9-8c01-9f7e5abffcba.png)
tomcat组件
</div>


![tomcat系统架构-多层容器](./images/container.JPG)


![Valve是Tomcat的私有机制](./images/valve.JPG)


##  Servlet规范
+ Servlet
+ Filter
每个请求生成一个Filter链
+ Listener
定制自己的监听器来监听 **Tomcat 内部发生的各种事件**：包括 Web 应用级别的、Session 级别的和请求级别的

## 参考:
[tomcat 组件 Top level view](https://www.iteye.com/blog/onlyor-1689344)  
[深入拆解Tomcat & Jetty - 06 | Tomcat系统架构（下）：聊聊多层容器的设计]() 李号双  
[深入拆解Tomcat & Jetty - 26 | Context容器（下）：Tomcat如何实现Servlet规范？]() 李号双  