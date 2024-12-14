---
title: SpringBoot
date: 2019-09-20 15:02:28
tags:
  - 微服务
categories:
  - 中间件
  - spring 
  - springboot
---

<p></p>
<!-- more -->


# Core
###  Spring Boot定义
**Spring Boot** is designed to get you up and running as quickly as possible, 
with **minimal** upfront **configuration** of Spring. 
Spring Boot takes an opinionated view of building production-ready applications.


###  Features (官方)

- Create stand-alone Spring applications
- **Embed** Tomcat, Jetty or Undertow directly (no need to deploy WAR files)
- Provide opinionated **'starter'** dependencies to simplify your build configuration
- **Automatically configure** Spring and 3rd party libraries whenever possible
- Provide **production-ready** features such as metrics, health checks, and externalized configuration
- Absolutely no code generation and no requirement for XML configuration

###   特性
+  自动配置   Auto Configuration
   为Spring及第三方库提供自动配置;
   简化了项目的构建配置;
   - 无需生成代码或进行xml配置; 
    约定优于配置(Convention Over Configuration) CoC

+ Starter Dependency

+ Springboot CLI

+ 内嵌的服务器
方便地创建可独立运行的Spring应用程序;
直接内嵌的Tomcat， Jetty或者Undertow;

+ 生产级
提供生产级特性;
Actuator（Runtime）


#  Auto Configuration

### 底层装配技术  [3]
+ Spring 模式注解装配

+ Spring @Enable 模块装配
``` Java
// 组件
   @EnableXXX
        @Importer @ImportXXXSelector
   @Conditional
   @ConditionalOnClass
   @ConditionalOnBean
   ... 
```
``` Java
// 开启自动配置
@EnableAutoConfiguration
@SpringBootApplication
```

+ Spring 条件装配装配
``` Java
// 实现原理 - 有条件的加载机制
@ConditionalOnClass
@ConditionalOnBean
@ConditionalOnMissingBean
@ConditionalOnProperty
...
```

+ Spring 工厂加载机制
  - 实现类： SpringFactoriesLoader
  - 配置资源： META-INF/spring.factories

###  外部化配置加载顺序
```
 ...
 命令行参数（--server.port=9000）
 ...
 System.getProperties()
 操作系统环境变量
 ...
```


```
 jar包外的application-{profile}.properties 或 .yml
 jar包内的application-{profile}.properties 或 .yml
 jar包外的application.properties或 .yml
 jar包内的application.properties或 .yml
```

#  Starter Dependency

+ 直接面向功能
+ 官方Starters spring-boot-starter-*

``` xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.0.0.RELEASE</version>
</parent>

<!-- 使用方 -->
<!-- 统一管理依赖 --><!-- spring cloud的依赖 -->
<dependencyManagement></dependencyManagement>

<!-- 定义方 -->
Bill of Materials - bom
BOM本质上是一个普通的POM文件
```

+ 扩展自定义starter
... 



#  production-ready
###  Actuator
+ 目的： 监控并管理应用程序
+ 访问方式： HTTP, JMX
+ 依赖： spring-boot-starter-actuator

###  Actuator Endpoint
+ http访问
/actuator/<id>
+ 端口与路径
+ management.server.address=
+ management.server.port=
  

#   内嵌的Web容器

### 可选容器列表
+ spring-boot-starter-tomcat
+ spring-boot-starter-jetty
+ spring-boot-starter-undertow
+ spring-boot-starter-reactor-netty

### 端口
+ server.port
+ server.address

### 压缩

### Tomcat特性配置
+ server.tomcat.max-connections=10000
+ server.tomcat.max-http-post-size
+ server.tomcat.max-threads


# 参考
1. 《玩转Spring全家桶》 67, 68, 71, 73,  75, 79  丁雪峰 V
2. 《黑马程序员SpringBoot教程，6小时快速入门Java微服务架构Spring Boot》 V
3. 《mksz252 - Spring Boot 2.0深度实践之核心技术篇》 第2章 走向自动装配 V *** 
100. [SpringBoot面试题 (史上最全、持续更新、吐血推荐) ](https://www.cnblogs.com/crazymakercircle/p/14365487.html)  尼恩  未
101. [spring + spring mvc + tomcat 面试题（史上最全）](https://www.cnblogs.com/crazymakercircle/p/14465630.html) 尼恩 未
102. [SpringBoot 基础知识 核心知识 【收藏版】](https://www.cnblogs.com/crazymakercircle/p/13895735.html)  尼恩 未
