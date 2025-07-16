---
title: Nginx优化
date: 2020-03-26 12:07:27
tags:
  - Nginx
categories:
  - 中间件
  - nginx
---

<p></p>
<!-- more -->


##  Nginx 参数优化

###  反向代理
```	nginx
proxy_cache: 10M(重要)
proxy_cache_path /data/nginx_cache/ levels=1:2 keys_zone=my_zone:10m inactive=300s max_size=5g;
```


### tls ssl
``` nginx
ssl_session_cache builtin:1000 shared:SSL:10m;  /// 一天内连接上的用户， 不需要再协商秘钥
ssl_session_cache builtin:1000 shared:SSL:10m;  /// 1m -> 4000个https连接
ssl_session_timeout 10m; /// 10分钟
ssl_protocols TLSv1.2;  /// 版本号
```

### 非安全请求重定向
``` nginx
No redirect:  无重定向 
Redirect： 301-302 -》 转到https站点 
```

### gzip
``` nginx
gzip on;
gzip_comp_level 5;
gzip_http_version 1.1;   /// 注意：gzip 在1.1上有效， http2.0上是无效的
gzip_min_length 256;
gzip_types application/atom+xml ... 
gzip_proxied any;
gzip_vary on;
```


###  worker 
``` nginx
worker_connections  16384;  ///    一个worker有 16384/2=8192 ‬个链接 .
                                   两个事件， 一个读事件， 一个写事件。 
                                   越多的connections对应更多的内存消耗。
Default: worker_connections 512;                                 
```

``` nginx
高级选项：
worker connections的内存池（pools）， 更少的的内存碎片。一般是nginx自动分配的， 不用分配。
Default: 	connection_pool_size 256|512
Default: 	request_pool_size 4k;
```

``` nginx
worker_processes  设置worker进程的数量
```


### 减少进程间切换
程间切换： cpu从一个进程或线程切换到另一个进程或线程。

+ 主动切换和被动切换
+ 减少主动切换
+ 被动切换：时间片耗尽。 
减少被动切换： **增大进程优先级**
Nice 静态优先级: -20 -- 19
Priority 动态优先级： 0-139

### 提升CPU缓存命中率
+ **绑定worker到指定cpu**
L1,L2(cpu独享) 
L3（共享的）
``` nginx
worker_cpu_affinity cpumask ...;
worker_cpu_affinity auto [cpumask];
```

### lua 分配的内存（暂时没有使用）
``` nginx
lua_shared_dict configuration_data 5M;
lua_shared_dict certificate_data 16M;
// 应用场景: 集群流控,  多个worker之间的内存的共享。
```


### http的keeplive  长链接（一个tcp的链接，上面有多个http的请求）  
注意: 非tcp keeplive 

``` nginx
keepalive_disable;  /// 没有设置
keepalive_timeout  75s; // 默认值
keepalive_requests 100; // 默认值  一个tcp请求中可发100个http请求
```

##  测试用例
URL：logsearch.sh.pre.urtc.com.cn

### case1
input：
1000用户并发, 短连接， 非keepalive的   

result：
链接数  40000+  
tps 4000+   
avg 百ms   

### case2
input：
1500用户并发，短连接， 非keepalive的    

result：
链接数 30000+，  
tps 4000+ ，   
avg 200ms+ 


## 参考
100. [Nginx全面配置](https://www.cnblogs.com/xfeiyun/p/15877678.html)  *** 未

