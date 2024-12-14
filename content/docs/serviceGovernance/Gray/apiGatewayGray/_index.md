---
title: API 网关-灰度发布
date: 2022-03-23 21:31:49
tags:
  - API Gateway
categories: 
  - 服务治理
  - API网关    
---

<p></p>
<!-- more -->

## 灰度发布 策略 [2]
+ 基于权重  百分比
+ version
+ ...

## 基于springcloud gateway + nacos实现灰度发布[1]
``` yaml
spring:
  application:
    name: gateway-reactor-gray
  cloud:
     nacos:
       discovery:
        server-addr: localhost:8848
     gateway:
       discovery:
         locator:
           enabled: true
           lower-case-service-id: true
       routes:
         - id: hello-consumer
           uri: grayLb://hello-consumer  ## 灰度负载均衡
           predicates:
              - Path=/hello/**
```

``` Java
public class GrayLoadBalancer implements ReactorServiceInstanceLoadBalancer {

    ... 
    private Response<ServiceInstance> getInstanceResponse(List<ServiceInstance> instances,HttpHeaders headers) {
        if (instances.isEmpty()) {
            return getServiceInstanceEmptyResponse();
        } else {
            return getServiceInstanceResponseWithWeight(instances);  //
        }
    }

    /**
     * 根据版本进行分发
     */
    private Response<ServiceInstance> getServiceInstanceResponseByVersion(List<ServiceInstance> instances, HttpHeaders headers) {
        String versionNo = headers.getFirst("version"); //
        System.out.println(versionNo);
        Map<String,String> versionMap = new HashMap<>();
        versionMap.put("version",versionNo);
        ...
    }

    /**
     * 根据在nacos中配置的权重值，进行分发
     */
    private Response<ServiceInstance> getServiceInstanceResponseWithWeight(List<ServiceInstance> instances) {
        Map<ServiceInstance,Integer> weightMap = new HashMap<>();
        for (ServiceInstance instance : instances) {
            Map<String,String> metadata = instance.getMetadata();
            if(metadata.containsKey("weight")){   //
                weightMap.put(instance,Integer.valueOf(metadata.get("weight")));
            }
        }
        ...
    }
```

``` Java
public class GrayReactiveLoadBalancerClientFilter implements GlobalFilter, Ordered {

   ...
   
    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        URI url = (URI)exchange.getAttribute(ServerWebExchangeUtils.GATEWAY_REQUEST_URL_ATTR);
        String schemePrefix = (String)exchange.getAttribute(ServerWebExchangeUtils.GATEWAY_SCHEME_PREFIX_ATTR);
        if (url != null && ("grayLb".equals(url.getScheme()) || "grayLb".equals(schemePrefix))) { //
            ServerWebExchangeUtils.addOriginalRequestUrl(exchange, url);
            ...

            return this.choose(exchange).doOnNext((response) -> { //
              ... 
            }).then(chain.filter(exchange));
        } else {
            return chain.filter(exchange);
        }
    }



    private Mono<Response<ServiceInstance>> choose(ServerWebExchange exchange) { //
        URI uri = (URI)exchange.getAttribute(ServerWebExchangeUtils.GATEWAY_REQUEST_URL_ATTR);
        GrayLoadBalancer loadBalancer = new GrayLoadBalancer(clientFactory.getLazyProvider(uri.getHost(), ServiceInstanceListSupplier.class), uri.getHost());
        if (loadBalancer == null) {
            throw new NotFoundException("No loadbalancer available for " + uri.getHost());
        } else {
            return loadBalancer.choose(this.createRequest(exchange)); //
        }
    }


}
```

## 参考
1. [基于springcloud gateway + nacos实现灰度发布（reactive版）](https://www.cnblogs.com/linyb-geek/p/12774014.html)
[相关的代码](https://github.com/lyb-geek/gateway)
2. [Go to Page](k8sIngressNginx.md)   灰度发布  self   

