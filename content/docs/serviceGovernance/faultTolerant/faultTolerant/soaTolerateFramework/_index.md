---
title:   容错框架
date: 2016-10-07 06:40:26
tags:
  - 服务治理
categories: 
  - 服务治理
  - 容错        
---

<p></p>
<!-- more -->


# Hystrix实现和容错模式
+ Hystrix实现和容错模式
	- 熔断【熔断器模式】
		+ 三个状态
			+ 开
			+ 闭
			+ 半开
		+ 模块
			+ 熔断请求判断机制算法
				+ 维护10个bucket,每秒一个bucket,每个blucket记录成功,失败,超时,拒绝的状态。
					+ 超时【超时与重试模式】
					+ 失败（异常）
					+ 成功
					+ 拒绝
						线程池拒绝【1】
						信号量拒绝【2】
				+ 默认错误超过50%且10秒内超过20个请求进行中断拦截
			+ 熔断恢复
				+ 每隔5s允许部分请求通过，若请求都是健康的（RT<250ms）则对请求健康恢复
			+ 熔断报警和Metric上报
	- 流控【限流模式】
		+ 控制速率
		+ 控制并发
	- 隔离【舱壁隔离模式】
		+ Hystrix实现
			+ 线程池隔离 【1】
			+ 信号量隔离【2】
	- 回退【回退模式】
		+ 快速失败（Fail Fast ）
		+ 无声失败（Fail Silent ）
		+ 返回默认值（Fallback  Static ）


# Resilience4j [1]
+ 断路器（Circuit Breaker）
+ 重试（Retry）
+ 限时器（Time Limiter） 
+ 限流器（Rate Limiter）
+ 隔板（BulkHead）


# 参考
### Hystrix
1. 微服务熔断与隔离 楚岩
2. Hystrix技术解析 王新栋
3. <<亿级流量网站架构核心技术>> 5.8节 张开涛
4. Hystrix 使用与分析 zhangyijun

### Resilience4j
1. [Resilience4j 比 Hystrix 好在哪里？](https://www.zhihu.com/question/365162958) 
