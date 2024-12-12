---
title: Kubernetes PaaS平台
date: 2022-01-12 11:07:23
tags:
  - Kubernetes
categories:
  - 云原生
  - Kubernetes
---

<p></p>
<!-- more -->


/ | OpenShift | KubeSphere
:-: | :-: | :-:
网络 | ovs(openshift SDN), flannel, calico | calico, flannel, QinCloud CNI, Porter
存储 | Ceph,NFS | NeonSAN， QingCloud-csi，Ceph-csi
CI/CD | OCP Pipeline/Tekton<br>s2i | Pipeline, Jenkins, sonarqube<br>s2i
微服务 | istio | istio
ingress| HA Proxy | openELB
infa(多云) | kvm,openstack,aws,GCP,azure<br> marketplace |  OpenPitrix(aws, aliyun, openstack) 
Service Catelog |operatorhub| 无
serverless | knative | openfunction(基于knative) 
多集群 |  | solo、 kubefed(二开)


## 参考
青云官网
