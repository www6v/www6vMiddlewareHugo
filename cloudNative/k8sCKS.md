---
title: Kubernetes CKS
date: 2022-01-15 23:06:15
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes
  - security
---

<p></p>
<!-- more -->


### Cluster Setup - 10%
##### [Securing a Cluster](https://kubernetes.io/docs/tasks/administer-cluster/securing-a-cluster/)

1. 使用网络安全策略来限制集群级别的访问 
[Use Network security policies to restrict cluster level access](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
2. 使用CIS基准检查Kubernetes组件(etcd, kubelet, kubedns, kubeapi)的安全配置 
   [Use CIS benchmark to review the security configuration of Kubernetes components](https://www.cisecurity.org/benchmark/kubernetes/)  (etcd, kubelet, kubedns, kubeapi)
    - [Kube-bench](https://github.com/aquasecurity/kube-bench) - Checks whether Kubernetes is deployed securely by running the checks documented ain the CIS Kubernetes Benchmark.
3. 正确设置带有安全控制的Ingress对象 
Properly set up [Ingress objects with security control](https://kubernetes.io/docs/concepts/services-networking/ingress/#tls)
4. 保护节点元数据和端点 
[Protect node metadata and endpoints](https://kubernetes.io/docs/tasks/administer-cluster/securing-a-cluster/#restricting-cloud-metadata-api-access)

<details><summary> Using Kubernetes network policy to restrict pods access to cloud metadata </summary>

  * This example assumes AWS cloud, and metadata IP address is 169.254.169.254 should be blocked while all other external addresses are not.

 ```yaml
      apiVersion: networking.k8s.io/v1
      kind: NetworkPolicy
      metadata:
        name: deny-only-cloud-metadata-access
      spec:
        podSelector: {}
        policyTypes:
        - Egress
        egress:
        - to:
          - ipBlock:
            cidr: 0.0.0.0/0
            except:
            - 169.254.169.254/32
 ```

</details>

5. 最小化GUI元素的使用和访问 
[Minimize use of, and access to, GUI elements](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/#accessing-the-dashboard-ui)

6. 在部署之前验证平台二进制文件 
[Verify platform binaries before deploying](https://github.com/kubernetes/kubernetes/releases)

<details><summary> Kubernetes binaries can be verified by their digest **sha512 hash**  </summary>

- Checking the Kubernetes release page for the specific release
- Checking the change log for the [images and their digests](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.19.md#downloads-for-v1191)

</details>

### Cluster Hardening - 15%

1. 限制访问Kubernetes API 
[Restrict access to Kubernetes API](https://kubernetes.io/docs/reference/access-authn-authz/controlling-access/)
  - [Control anonymous requests to Kube-apiserver](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#anonymous-requests)
  - [Non secure access to the kube-apiserver](https://kubernetes.io/docs/concepts/security/controlling-access/#api-server-ports-and-ips)
2. 使用基于角色的访问控制来最小化暴露 
   [Use Role-Based Access Controls to minimize exposure](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
    *   [Handy site collects together articles, tools and the official documentation all in one place](https://rbac.dev/)
    *   [Simplify Kubernetes Resource Access Control using RBAC Impersonation](https://docs.bitnami.com/tutorials/simplify-kubernetes-resource-access-rbac-impersonation/)
3. 谨慎使用服务帐户，例如禁用默认设置，减少新创建帐户的权限 
Exercise caution in using service accounts e.g. [disable defaults](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#use-the-default-service-account-to-access-the-api-server), minimize permissions on newly created ones

<details><summary> Opt out of automounting API credentials for a service account </summary>

   #### Opt out at service account scope
   ```yaml
   apiVersion: v1
   kind: ServiceAccount
   metadata:
     name: build-robot
   automountServiceAccountToken: false
   ```
   #### Opt out at pod scope
   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: cks-pod
   spec:
     serviceAccountName: default
     automountServiceAccountToken: false
   ```

</details>

4. 经常更新Kubernetes 
[Update Kubernetes frequently](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-upgrade/)

### System Hardening - 15%

1. 最小化主机操作系统的大小(减少攻击面) 
Minimize host OS footprint (reduce attack surface)

<details><summary>Reduce host attack surface </summary>

   * [seccomp which stands for secure computing was originally intended as a means of safely running untrusted compute-bound programs](https://kubernetes.io/docs/tutorials/clusters/seccomp/)
   * [AppArmor can be configured for any application to reduce its potential host attack surface and provide greater in-depth defense.](https://kubernetes.io/docs/tutorials/clusters/apparmor/)
   * [PSP enforces](https://kubernetes.io/docs/concepts/policy/pod-security-policy/)
     PodSecurityPolicy is deprecated as of Kubernetes v1.21, and will be removed in v1.25. We recommend migrating to Pod Security Admission.
   * Apply host updates
   * Install minimal required OS fingerprint
   * Identify and address open ports
   * Remove unnecessary packages
   * Protect access to data with permissions
     *  [Restirct allowed hostpaths](https://kubernetes.io/docs/concepts/policy/pod-security-policy/#volumes-and-file-systems)

</details>

2. 最小化IAM角色 
   Minimize IAM roles
   *   [Access authentication and authorization](https://kubernetes.io/docs/reference/access-authn-authz/authentication/)
3. 最小化对网络的外部访问 
Minimize external access to the network

<details><summary>     if it means deny external traffic to outside the cluster?!! </summary>

   * not tested, however, the thinking is that all pods can talk to all pods in all name spaces but not to the outside of the cluster!!!

   ```yaml
   apiVersion: networking.k8s.io/v1
   kind: NetworkPolicy
   metadata:
     name: deny-external-egress
   spec:
     podSelector: {}
     policyTypes:
     - Egress
     egress:
       to:
       - namespaceSelector: {}
   ```

</details>

4. 适当使用内核强化工具，如AppArmor, seccomp 
   Appropriately use kernel hardening tools such as AppArmor, seccomp
   * [AppArmor](https://kubernetes.io/docs/tutorials/clusters/apparmor/)
   * [Seccomp](https://kubernetes.io/docs/tutorials/clusters/seccomp/)

### Minimize Microservice Vulnerabilities - 20%

1. 设置适当的OS级安全域，例如使用PSP, OPA，安全上下文 
   Setup appropriate OS-level security domains e.g. using PSP, OPA, security contexts
   - [Pod Security Policies](https://kubernetes.io/docs/concepts/policy/pod-security-policy/)
   - [Open Policy Agent](https://kubernetes.io/blog/2019/08/06/opa-gatekeeper-policy-and-governance-for-kubernetes/)
   - [Security Contexts](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)
2. 管理Kubernetes机密 
[Manage kubernetes secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
3. 在多租户环境中使用容器运行时 (例如gvisor, kata容器) 
Use [container runtime](https://kubernetes.io/docs/concepts/containers/runtime-class/) sandboxes in multi-tenant environments (e.g. [gvisor, kata containers](https://github.com/kubernetes/enhancements/blob/5dcf841b85f49aa8290529f1957ab8bc33f8b855/keps/sig-node/585-runtime-class/README.md#examples))
4. 使用mTLS实现Pod对Pod加密 
[Implement pod to pod encryption by use of mTLS](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/)
  - [ ] check if service mesh is part of the CKS exam


### Supply Chain Security - 20%

1. 最小化基本镜像大小 
Minimize base image footprint

   <details><summary>   Minimize base Image </summary>

   * Use distroless, UBI minimal, Alpine, or relavent to your app nodejs, python but the minimal build.
   * Do not include uncessary software not required for container during runtime e.g build tools and utilities, troubleshooting and debug binaries.
     *   [Learnk8s: 3 simple tricks for smaller Docker images](https://learnk8s.io/blog/smaller-docker-images)
      *   [GKE 7 best practices for building containers](https://cloud.google.com/blog/products/gcp/7-best-practices-for-building-containers)

   </details>

2. 保护您的供应链：将允许的注册表列入白名单，对镜像进行签名和验证 
Secure your supply chain: [whitelist allowed image registries](https://kubernetes.io/blog/2019/03/21/a-guide-to-kubernetes-admission-controllers/#why-do-i-need-admission-controllers), sign and validate images
  * Using [ImagePolicyWebhook admission Controller](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#imagepolicywebhook)
4. 使用用户工作负载的静态分析(例如kubernetes资源，Docker文件) 
Use static analysis of user workloads (e.g. [kubernetes resources](https://kubernetes.io/blog/2018/07/18/11-ways-not-to-get-hacked/#7-statically-analyse-yaml), docker files)
5. 扫描镜像，找出已知的漏洞 
   [Scan images for known vulnerabilities](https://kubernetes.io/blog/2018/07/18/11-ways-not-to-get-hacked/#10-scan-images-and-run-ids)
    * [Aqua security Trivy]( https://github.com/aquasecurity/trivy)
    *   [Anchore command line scans](https://github.com/anchore/anchore-cli#command-line-examples)


### Monitoring, Logging and Runtime Security - 20%

1. 在主机和容器级别执行系统调用进程和文件活动的行为分析，以检测恶意活动 
	Perform behavioural analytics of syscall process and file activities at the host and container level to detect malicious activities
	- [Falco installation guide](https://falco.org/docs/)
	- [Sysdig Falco 101](https://learn.sysdig.com/falco-101)
	- [Falco Helm Chart](https://github.com/falcosecurity/charts/tree/master/falco)
	- [Falco Kubernetes helmchart](https://github.com/falcosecurity/charts)
	- [Detect CVE-2020-8557 using Falco](https://falco.org/blog/detect-cve-2020-8557/)
2. 检测物理基础架构，应用程序，网络，数据，用户和工作负载中的威胁 
Detect threats within a physical infrastructure, apps, networks, data, users and workloads
3. 检测攻击的所有阶段，无论它发生在哪里，如何扩散 
Detect all phases of attack regardless where it occurs and how it spreads

   <details><summary>    Attack Phases </summary>

     -   [Kubernetes attack martix Microsoft blog](https://www.microsoft.com/security/blog/2020/04/02/attack-matrix-kubernetes/)
     -   [MITRE attack framwork using Falco](https://sysdig.com/blog/mitre-attck-framework-for-container-runtime-security-with-sysdig-falco/)
     -   [Lightboard video: Kubernetes attack matrix - 3 steps to mitigating the MITRE ATT&CK Techniques]()
     -   [CNCF Webinar: Mitigating Kubernetes attacks](https://www.cncf.io/webinars/mitigating-kubernetes-attacks/)

   </details>

4. 对环境中的不良行为者进行深入的分析调查和识别 
   Perform deep analytical investigation and identification of bad actors within the environment
   - [Sysdig documentation](https://docs.sysdig.com/)
   - [Monitoring Kubernetes with sysdig](https://kubernetes.io/blog/2015/11/monitoring-kubernetes-with-sysdig/)
   - [CNCF Webinar: Getting started with container runtime security using Falco](https://youtu.be/VEFaGjfjfyc)
5. 确保容器在运行时不变 
[Ensure immutability of containers at runtime](https://kubernetes.io/blog/2018/03/principles-of-container-app-design/)
6. 使用审计日志来监视访问 
[Use Audit Logs to monitor access](https://kubernetes.io/docs/tasks/debug-application-cluster/audit/)





