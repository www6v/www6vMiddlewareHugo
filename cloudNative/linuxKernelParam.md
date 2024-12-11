---
title: 虚拟机和容器中的内核参数 kernel
date: 2020-08-16 12:27:46
tags:
  - linux
categories:
  - linux 
  - kernel  
  - 参数 
---

<p></p>
<!-- more -->

## 重要的内核参数

```
##内存与交换分区
vm.swappiness

# 内存分配  
## OOM
vm.overcommit_memory=2:  过量使用.   0, 1, 2
  RAM, swap
vm.overcommit_ratio=50
比如：
swap: 2G ，RAM: 8G
则 memory = swap + RAM * ratio =  2G + 8G * 50% = 6G
        
如何充分使用内存：
  1. swap跟RAM一样大； swappiness=0
  2. vm.overcommit_memory=2，  vm.overcommit_ratio=100， swappiness=0 (生产中)
     memory = swap + RAM * ratio        
```

```
## 网络
net.ipv4.ip_forward  # ipv4的路由转发功能

net.ipv4.tcp_tw_reuse = 1              #开启重用，允许将TIME_WAIT socket用于新的TCP连接。默认为0，表示关闭。
net.ipv4.tcp_tw_recycle = 1            #开启TCP连接中TIME_WAIT socket的快速回收。默认值为0，表示关闭
。
net.ipv4.tcp_syncookies = 1            #开启SYN cookie，出现SYN等待队列溢出时启用cookie处理，防范少量的SYN攻击。默认为0，表示关闭。

net.ipv4.tcp_keepalive_time = 600      #keepalived启用时TCP发送keepalived消息的拼度。默认位2小时。
net.ipv4.tcp_keepalive_probes = 5      #TCP发送keepalive探测以确定该连接已经断开的次数。根据情形也可以适当地缩短此值。
net.ipv4.tcp_keepalive_intvl = 15      #探测消息发送的频率，乘以tcp_keepalive_probes就得到对于从开始探测以来没有响应的连接杀除的时间。
                                        默认值为75秒，也就是没有活动的连接将在大约11分钟以后将被丢弃。
                                        对于普通应用来说,这个值有一些偏大,可以根据需要改小.特别是web类服务器需要改小该值。
net.ipv4.ip_local_port_range = 1024 65000 #指定外部连接的端口范围。默认值为32768 61000。

net.ipv4.tcp_max_syn_backlog = 262144  #表示SYN队列的长度，预设为1024，这里设置队列长度为262 144，以容纳更多的等待连接。
net.core.somaxconn = 16384             #定义了系统中每一个端口最大的监听队列的长度, 对于一个经常处理新连接的高负载 web服务环境来说，默认值为128，偏小。

## 缓冲区大小
net.ipv4.tcp_mem
net.ipv4.tcp_rmem
net.ipv4.tcp_wmem

## core
wmem_max
wmem_default
rmem_max
rmem_default
```

```
# IPC - 进程通讯
  message
    msgmni
    msgmax
    msgmnb
  shm - sharememory
    shmall
    shmmax
    shmmni
  semaphore  
```


```
# ls /proc/sys
abi  crypto  debug  dev  fs  kernel  net  vm

# 多线程
vm.max_map_count 
```


```
# 进程有若干操作系统资源的限制
➜  ~ cat /proc/1/limits
Limit                     Soft Limit           Hard Limit           Units
Max cpu time              unlimited            unlimited            seconds
Max file size             unlimited            unlimited            bytes
Max data size             unlimited            unlimited            bytes
Max stack size            8388608              unlimited            bytes
Max core file size        0                    unlimited            bytes
Max resident set          unlimited            unlimited            bytes
Max processes             15188                15188                processes
Max open files            65536                65536                files
Max locked memory         65536                65536                bytes
Max address space         unlimited            unlimited            bytes
Max file locks            unlimited            unlimited            locks
Max pending signals       15188                15188                signals
Max msgqueue size         819200               819200               bytes
Max nice priority         0                    0
Max realtime priority     0                    0
Max realtime timeout      unlimited            unlimited            us
```

## 容器中的内核参数
```
# 已经namespace化的内核参数：
kernel.shm*,
kernel.msg*,
kernel.sem,
fs.mqueue.*,
net.*.

# 没有namespace化
vm.*

# k8s把syctl参数分为safe和unsafe
# 只有三个参数被认为是safe的
kernel.shm_rmid_forced,
net.ipv4.ip_local_port_range,
net.ipv4.tcp_syncookies
```

## 参考
### 内核参数
1. [Linux内核常见参数的优化](https://www.jianshu.com/p/3096a8e6a36f)
2. [单个JVM下支撑100w线程数vm.max_map_count](https://blog.csdn.net/vic_qxz/article/details/82853447)
3. [Linux的overcommit配置](http://www.firefoxbug.com/index.php/archives/2800/)
4. [给容器设置内核参数](https://tencentcloudcontainerteam.github.io/2018/11/19/kernel-parameters-and-container/) good
5. [TCP总结](../../../../2015/04/25/tcp/) self
6. [06_虚拟化技术基础原理详解](https://www.bilibili.com/video/BV1W7411J7DP?p=5&vd_source=f6e8c1128f9f264c5ab8d9411a644036) V