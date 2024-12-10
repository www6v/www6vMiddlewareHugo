---
title:  Kubernetes服务
date: 2019-11-04 11:56:32
tags:
  - Kubernetes
categories:
  - 云原生
  - Kubernetes
---

<p></p>
<!-- more -->

## 一. Kubenetes服务

![Kubernetes服务](.\k8sService\k8sService.jpg)


![Kubernetes服务发现架构](https://user-images.githubusercontent.com/5608425/68105556-d4257280-ff19-11e9-9d19-f18f5c454f34.jpg)
Kubernetes服务发现架构


+ ClusterIP 模式的 Service: **稳定的 IP 地址**，即 VIP.  ClusterIP是VIP, 虚拟IP.    
+ Headless Service: **稳定的 DNS 名字**, 名字是通过 Pod 名字和 Service 名字拼接出来.  

### 1.1  服务对外暴露方式

1. NodePort  四层
<div style="text-align: center; width:60%; height: 60%">
</div>
![node-port](https://user-images.githubusercontent.com/5608425/68234082-7d17be80-003b-11ea-891f-90a9e174bbc8.png)


+ 一定要对流出的包做 SNAT操作[2][6]

```
           client
             \ ^
              \ \
               v \
   node 1 <--- node 2
   | ^    SNAT
   | |    --->
   v |
 endpoint
```

+ 获取真实客户端IP, 设置Service 的 spec.externalTrafficPolicy 字段设置为 local，[2][6]

```
    client
    ^ / \
   / /   \
  / v     X
node 1   node 2
  ^ |
  | |
  | v
endpoint
```

2. Service LoadBalancer  四层
<div style="text-align: center; width:60%; height: 60%">
</div>
![loadbalancer](https://user-images.githubusercontent.com/5608425/68290997-e216f700-00c3-11ea-82d3-b5e3f4c565a1.jpg)


**LoadBalancer**类型的Service被提交后，Kubernetes就会调用**CloudProvider**[5]在公有云上为你创建一个负载均衡服务，并且把被代理的 Pod 的 IP地址配置给负载均衡服务做后端.

3. ExternalName
ExternalName 类型的 Service，其实是在 kubedns里为你添加了一条 CNAME 记录.
1.7 之后支持的一个新特性.

4. Ingress Controller  七层
<div style="text-align: center; width:60%; height: 60%">
</div>
![ingress-1](https://user-images.githubusercontent.com/5608425/68234079-7c7f2800-003b-11ea-8ada-2c034db8b25a.png)
![ingress-2](https://user-images.githubusercontent.com/5608425/68234081-7c7f2800-003b-11ea-804c-1c5d87164d06.png)   


+ Ingress 服务: 全局的、为了代理不同后端 Service 而设置的负载均衡服务.
+ Ingress 对象，其实就是 Kubernetes 项目对“反向代理”的一种抽象。
+ Ingress Controller: Nginx、HAProxy、Envoy、Traefik


**Ingress controller**

为了使 Ingress 正常工作，集群中必须运行 Ingress controller。 这与其他类型的控制器不同，其他类型的控制器通常作为 kube-controller-manager 二进制文件的一部分运行，在集群启动时自动启动。 你需要选择最适合自己集群的 Ingress controller 或者自己实现一个。

+ Kubernetes 当前支持并维护 GCE 和 nginx 两种 controller
+ F5（公司）支持并维护 F5 BIG-IP Controller for Kubernetes
+ Kong 同时支持并维护 社区版 与 企业版 的 Kong Ingress Controller for Kubernetes
+ Traefik 是功能齐全的 ingress controller（Let’s Encrypt, secrets, http2, websocket…）, Containous 也对其提供商业支持。
+ Istio 使用 CRD Gateway 来 控制 Ingress 流量。


### 1.2 通过DNS发现服务
> 每个Service对象相关的DNS记录有两个：
{SVCNAME}.{NAMESPACE}.{CLUSTER_DOMAIN}
{SVCNAME}.{NAMESPACE}.svc.{CLUSTER_DOMAIN}

```
root@kubia-9nvx7:/# cat /etc/resolv.conf
nameserver 172.17.0.2
search default.svc.cluster.local svc.cluster.local cluster.local
options ndots:5
```

```
（1）拥有ClusterIP的Service资源，要具有以下类型的资源记录
A记录：<service>.<ns>.svc.<zone>. <ttl>  IN  A  <cluster-ip>

（2）Headless类型的Service资源，要具有以下类型的资源记录
A记录：<service>.<ns>.svc.<zone>. <ttl> IN A <endpoint-ip>

（3）ExternalName类型的Service资源，要具有CNAME类型的资源记录
CNAME记录：<service>.<ns>.svc.<zone>. <ttl> IN CNAME <extname>.
```

### 1.3 ClusterIP模式的yaml配置
Service（接口声明） + Deployment（ endpoint 接口实现）


## 二. Kubenetes服务工作原理

+ Service是由**kube-proxy**组件，加上**iptables**来共同实现的。
+ kube-proxy的作用: 网络配置

##### 2.1 kube-proxy 
##### userspace 代理模式
<div style="text-align: center;">
<img width="450" alt="user-space-proxy" src="https://user-images.githubusercontent.com/5608425/68077955-2b3b2280-fe08-11e9-8672-3210219a7372.png">
userspace 代理模式
</div>

##### iptables Proxy Mode
<div style="text-align: center;">
<img width="450" alt="iptables-proxy" src="https://user-images.githubusercontent.com/5608425/68077954-2b3b2280-fe08-11e9-8231-cb9bc177ba21.png">
 Iptables Proxy Mode
</div>


```
-A OUTPUT -m comment --comment "kubernetes service portals" -j KUBE-SERVICES

# 访问10.107.54.95后跳转到KUBE-SVC-4N57TFCL4MD7ZTDA链
-A KUBE-SERVICES -d 10.107.54.95/32 -p tcp -m comment --comment "default/nginx: cluster IP" -m tcp --dport 80 -j KUBE-SVC-4N57TFCL4MD7ZTDA

# 随机转发的目的地，分别是 KUBE-SEP-UZXILYFQQ2IZUWN5 和 KUBE-SEP-43IWXJI557JKCKCF
-N KUBE-SVC-4N57TFCL4MD7ZTDA
-A KUBE-SVC-4N57TFCL4MD7ZTDA -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-UZXILYFQQ2IZUWN5
-A KUBE-SVC-4N57TFCL4MD7ZTDA -j KUBE-SEP-43IWXJI557JKCKCF

## DNAT到pod的ip和端口
-A KUBE-SEP-UZXILYFQQ2IZUWN5 -p tcp -m tcp -j DNAT --to-destination 172.17.0.4:80
-A KUBE-SEP-43IWXJI557JKCKCF -p tcp -m tcp -j DNAT --to-destination 172.17.0.5:80
```

##### IPVS proxy mode
> IPVS是LVS一个组件，提供高性能、高可靠性的四层负载均衡器。IPVS 是IP Virtual Server的简写。IPVS构建在netfilter上，作为Linux 内核的一部分，从传输层实现了负载均衡。


与iptables类似，ipvs基于netfilter 的 hook 功能，但使用哈希表作为底层数据结构并在内核空间中工作。这意味着ipvs可以更快地重定向流量，并且在同步代理规则时具有更好的性能。此外，ipvs为负载均衡算法提供了更多选项，例如：

    rr：轮询调度
    lc：最小连接数
    dh：目标哈希
    sh：源哈希
    sed：最短期望延迟
    nq： 不排队调度

 





## 参考:
1. [深入理解 Kubernetes之：Service](https://www.kubernetes.org.cn/5992.html) good
2. [第14 章 ： Kubernetes Services](https://edu.aliyun.com/lesson_1651_17064#_17064)  阿里
3. [《Kubenetes in Action》](http://product.dangdang.com/26439199.html?ref=book-65152-9168_1-529800-3)  七牛容器云团队
4. [Kubernetes中的服务发现机制与方式](https://mp.weixin.qq.com/s/3THiWFt52tZckFGxg3Cx-g) 马永亮 
6. [从 K8S 的 Cloud Provider 到 CCM 的演进之路](https://mp.weixin.qq.com/s/a_540yJ1EGVroJ9TpvYtPw)  毛宏斌 百度
7. [获取真实客户端IP](https://docs.ucloud.cn/compute/uk8s/service/getresourceip)
8. [华为云在 K8S 大规模场景下的 Service 性能优化实践](https://mp.weixin.qq.com/s?__biz=MzU1OTAzNzc5MQ==&mid=2247485610&idx=1&sn=e092e55c848af62368835d530c57da15&chksm=fc1c249acb6bad8c940c587e59e0dc63ba4863c7063f0a0e322dcbd6ad5f610cd2ad1b4ba87d&scene=21#wechat_redirect) 未
9. [Service](https://jimmysong.io/kubernetes-handbook/concepts/service.html)  jimmysong
10. [Ingress](https://jimmysong.io/kubernetes-handbook/concepts/ingress.html) jimmysong

-----

《深入剖析Kubernetes》  张磊
1. [《37  找到容器不容易：Service、DNS与服务发现》]() 
2. [《38  从外界连通Service与Service调试“三板斧”》]()
3. [《39  谈谈Service与Ingress》]()

