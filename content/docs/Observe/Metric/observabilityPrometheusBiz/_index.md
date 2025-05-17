---
title: 可观测性-Prometheus业务监控
date: 2022-07-17 10:05:33
tags:
  - metric
categories:
  - 可观测性
  - metric
---

<p></p>
<!-- more -->



# 抓取业务指标的三种⽅式
###  白盒监控（最常用的指标抓取方式）
+ 通过 CRD 配置指标抓取
  - ServiceMonitor
    + **通过 Label 选择器匹配**：ServiceMonitor->Service->Endpoints->Pod
    + **首选类型**，可抓取多个 Pod 指标
  - PodMonitor
    + **通过 Label 选择器直接匹配 Pod**
    + 适合无 Service 的场景，例如 CronJobs、DaemonSets
+ 优势
  - 无需学习复杂的 Prometheus 配置，包含默认的 relabeling
  - 分离工程团队和基础设施团队

+ Query Metrics 简单例子
``` 
/// 过去 1 分钟，第 90 个百分位数请求延迟时间的直方图
histogram_quantile(     ---------> 获取直⽅图
   0.9,     ---------> 获取第 90 个百分位数请求延迟时间
     sum(       ---------> 聚合桶，并按桶的上限(le)进行分组
        rate(       --------->  获得每个桶的变化速率
           http_response_time_seconds_bucket{job="week9-app"}[1m]    ---------> 过去 1 分钟内 HTTP 请求延迟并分桶
       )
     )
   by(le)
)
```

### 黑盒监控 （其他指标抓取方式）
+ **通过 CRD 配置指标抓取**
  - Probe
    + 需要**部署 blackbox_exporter**
    + 可以被用在黑盒监控（如 HTTP 探针、网站可用性监控）
    + 监控静态的目标（如网站）或者 Ingress 对象
    + 通过 Label 选择器匹配 Ingress
+ 优势
  - **不侵入业务逻辑**
  - 快速发现故障


### 基于Annotations 抓取 (不推荐使用)



# 业务指标告警
### 避免告警疲劳 ***

+ 告警疲劳
  - 过多告警导致忽视，最终酿成生产事故
  
+ 生产实践
  - Alertmanager **route 参数优化**
    + group_wait：等待多长时间才为一个组发送告警（通常等待告警抑制或收集同一组更多的告警），默认 30s
    + group_interval：在发送新的告警之前等待多少时间，默认 5m
    + repeat_interval：重复告警的发送时间，默认 4h
  - 对**告警规则合理分组**减少告警数量，并设置合理的触发持续时间
    + group_by：比如按命名空间、集群、数据中心分组
    + for：5m、10m
+ **高纬度告警对象**，例如针对数据中心而不是实例级
+ 提供解决手册和仪表盘链接，更快解决问题
  - annotations:
    + runbook_url


+ 正确使用 Alertmanager 的功能特性

| 痛点<br/>              | 手段      | Alertmanager                                                 |
| ---------------------- | --------- | ------------------------------------------------------------ |
| 只向特定的团队发送告警 | 路由      | 通过标签将告警路由到特定的接收者<br/>                        |
| 同时发出了太多告警     | 抑制      | 在其他告警触发时抑制某些告警<br/>                            |
| 告警误报               | 静音      | 暂时静音告警，比如定期执行维护时<br/>                        |
| **警报过于频繁**       | 节流      | 优化 router 中的 group_wait、group_interval、repeat_interval 参数<br/> |
| 告警组织混乱           | 分组<br/> | 例如按 environment 标签对告警进行逻辑分组<br/>大规模场景不推荐使用 instance、ip_address、instance_id 等分组<br/> |
| 通知信息不足           | 通知模板  | 使用模板标准化告警消息，添加更多信息                         |


# 参考
《基于 Prometheus 业务指标弹性伸缩》  pdf   极客时间公开课