---
title: 分库分表-分页
date: 2022-08-01 15:03:16
tags:
  - DAL
categories:
  - 中间件
  - DAL
  - 分库分表
---

<p></p>
<!-- more -->

# 方案
### 全局查询法
简单

### 业务折衷法
##### 禁止跳页查询
##### 允许数据精度损失

### 二次查询法（推荐）
复杂

# 参考
1. [分库分表必会-跨库分页查询看此一篇就够了](https://juejin.cn/post/7141194628472487972)
2. [分表分页/跨库分页 难玩却不代表没有玩法 ](https://juejin.cn/post/6981996965353488415)
3. [千万级别mysql 分库分表后表分页查询优化方案初探](https://www.cnblogs.com/yizhiamumu/p/16803364.html)
4. [业界难题-“跨库分页”的四种方案 ](https://mp.weixin.qq.com/s/h99sXP4mvVFsJw6Oh3aU5A) ***  58沈剑