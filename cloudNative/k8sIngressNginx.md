---
title:  Kubernetes Nginx Ingress
date: 2022-02-10 22:41:32
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes  
---

<p></p>
<!-- more -->


# Kubernetes Nginx Ingress [0]
### 版本1-K8s官方维护 [1][2]
+ There are three ways to customize NGINX:
   - **ConfigMap**: using a Configmap to set global configurations in NGINX. 
     [滚动更新后生效， 针对全局的配置]
   - **Annotations**: use this if you want a specific configuration for a particular Ingress rule. [立即生效，针对某个域名location进行配置]
   - **Custom template**: when more specific settings are required, like open_file_cache, adjust listen options as rcvbuf or when is not possible to change the configuration through the ConfigMap.

### 版本2-Nginx官方维护 [3][4]

### 版本1 vs.  版本2 [5]





# 实践 [0]

###  域名重定向 ***
  ```redirect``` ，  http 重定向到https， 新旧域名替换

### 前后端分离 ***
```rewrite```
```
+ www.a.com /    --> 前端服务
+ www.a.com /api --> 后端服务 /api  
  www.a.com/api rewrite到  www.a.com 
```
### SSL配置  [p]
  验证  自签名证书

### 匹配请求头
  Mobile 和 PC 的请求头不同，路由到不同的后端服务

### 实现灰度金丝雀发布[6][7]

不同灰度方式的优先级由高到低为：
canary-by-header`>`canary-by-cookie`>`canary-weight

| Annotation                                           | 说明                                                         |
| ---------------------------------------------------- | ------------------------------------------------------------ |
| nginx.ingress.kubernetes.io/canary                   | 必须设置该Annotation值为`true`，否则其它规则将不会生效。     |
| nginx.ingress.kubernetes.io/canary-by-header         | 表示基于请求头的名称进行灰度发布。                           |
| nginx.ingress.kubernetes.io/canary-by-header-value   | 表示基于请求头的值进行灰度发布。                             |
| nginx.ingress.kubernetes.io/canary-by-header-pattern | 表示基于请求头的值进行灰度发布，并对请求头的值进行正则匹配。 |
| nginx.ingress.kubernetes.io/canary-by-cookie         | 表示基于Cookie进行灰度发布。                                 |
| nginx.ingress.kubernetes.io/canary-weight            | 表示基于权重进行灰度发布。                                   |
| nginx.ingress.kubernetes.io/canary-weight-total      | 表示设定的权重总值。                                         |



%accordion%灰度发布示例%accordion%

+ 基于Header灰度（自定义header值）：当请求Header为ack: alibaba时将访问灰度服务；其它Header将根据灰度权重将流量分配给灰度服务。
+ 基于Cookie灰度：当Header不匹配时，请求的Cookie为hangzhou_region=always时将访问灰度服务。 
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "20"
    nginx.ingress.kubernetes.io/canary-by-header: "ack"
    nginx.ingress.kubernetes.io/canary-by-header-value: "alibaba"
    nginx.ingress.kubernetes.io/canary-by-cookie: "hangzhou_region"

%/accordion%


### 速率限制

### 黑白名单
  allow deny

### 自定义错误页面

# 参考
0. [kubernetes架构师课程](https://www.bilibili.com/video/BV16t4y1w7r6?p=162)  162 V ***
1. [Ingress-Nginx Doc](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/)
2. [Ingress-Nginx Github](https://github.com/kubernetes/ingress-nginx)
3. [Nginx-ingress Doc](https://docs.nginx.com/nginx-ingress-controller/configuration/ingress-resources/advanced-configuration-with-annotations/)
4. [Nginx-ingress GitHub](https://github.com/nginxinc/kubernetes-ingress)
5. [nginx-ingress-controllers.md](https://github.com/nginxinc/kubernetes-ingress/blob/main/docs/content/intro/nginx-ingress-controllers.md)    表格 
6. [Nginx Ingress高级用法](https://help.aliyun.com/document_detail/86533.html#section-gjm-dw6-hkn)
7. [【IT老齐294】大厂如何基于K8S实现金丝雀发布](https://www.bilibili.com/video/BV15o4y1Y7Bq/)



