---
title: Kubernetes Operator-kubebuilder
date: 2021-12-30 20:42:36
tags:
  - Kubernetes
categories: 
  - 云原生
  - Kubernetes  
---

<p></p>
<!-- more -->

## 目录
<!-- toc -->

##  使用kubebuilder构建Operator的过程

+ 自己定义DaemonSet Operator包括：
  - [在每个node上启动一个Pod（CRD + Controller）](#step2-create-crd-and-controller)
  - [webhook(证书 + mutation + validation)](#step3-enable-webhooks)     

## Step1:  init project
##### Create a kubebuilder project, which requires an empty folder

```sh
kubebuilder init --domain cncamp.io
```

##### Check project layout

```sh
cat PROJECT

domain: cncamp.io
layout:
- go.kubebuilder.io/v3
projectName: mysts
repo: github.com/www6v/demo-operator
version: "3"
```

## Step2: Create  CRD and Controller
##### Create API, create resource[Y], create controller[Y]

```sh
kubebuilder create api --group apps --version v1beta1 --kind MyDaemonset
```

#####  edit `api/v1alpha1/simplestatefulset_types.go`

```sh
// MyDaemonsetSpec defines the desired state of MyDaemonset
type MyDaemonsetSpec struct {
	// INSERT ADDITIONAL SPEC FIELDS - desired state of cluster
	// Important: Run "make" to regenerate code after modifying this file

	// Foo is an example field of MyDaemonset. Edit mydaemonset_types.go to remove/update
	Image string `json:"image,omitempty"`
}

// MyDaemonsetStatus defines the observed state of MyDaemonset
type MyDaemonsetStatus struct {
	AvaiableReplicas int `json:"avaiableReplicas,omitempty"`
	// INSERT ADDITIONAL STATUS FIELD - define observed state of cluster
	// Important: Run "make" to regenerate code after modifying this file
}
```

##### Check Makefile

```makefile
Build targets:
    ### create code skeletion
    manifests: generate crd
    generate: generate api functions, like deepCopy

    ### generate crd and install
    run: Run a controller from your host.
    install: Install CRDs into the K8s cluster specified in ~/.kube/config.

    ### docker build and deploy
    docker-build: Build docker image with the manager.
    docker-push: Push docker image with the manager.
    deploy: Deploy controller to the K8s cluster specified in ~/.kube/config.
```

##### Edit `controllers/mydaemonset_controller.go`, add permissions to the controller
```go
//+kubebuilder:rbac:groups=apps.cncamp.io,resources=mydaemonsets/finalizers,verbs=update
// Add the following
//+kubebuilder:rbac:groups=core,resources=nodes,verbs=get;list;watch
//+kubebuilder:rbac:groups=core,resources=pods,verbs=get;list;watch;create;update;patch;delete
```

##### Generate crd

```sh
make manifests
```

##### Build & install

```sh
make build
make docker-build
make docker-push
make deploy
```

## Step3: Enable webhooks

##### Install cert-manager

```sh
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.1/cert-manager.yaml
```

##### Create webhooks

```sh
kubebuilder create webhook --group apps --version v1beta1 --kind MyDaemonset --defaulting --programmatic-validation
```

##### Change code

##### Enable webhook in `config/default/kustomization.yaml`

##### Redeploy

## 附件: Operator源代码
https://github.com/www6v/mydaemonset  
