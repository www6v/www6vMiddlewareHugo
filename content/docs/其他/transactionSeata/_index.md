---
title: 分布式事务-Seata
date: 2022-03-24 11:06:49
tags:
  - Seata
categories:
  - 中间件
  - Seata
---

<p></p>
<!-- more -->

[AT Mode]:https://github.com/seata/seata/wiki/AT-Mode
[MT Mode]:https://github.com/seata/seata/wiki/MT-Mode

## Seata 模式[3]

| 功能名称                                                     | 特点                                                         | 基本原理                                                     | 使用场景                                                     | 存在问题                                | 性能     | 复杂度   |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | --------------------------------------- | -------- | -------- |
| AT 模式<br>[AT模式官方文档 1](https://seata.io/zh-cn/docs/dev/mode/at-mode.html) | 自动补偿事务                                                 | 代理数据源，一阶段解析sql将数据写入undo_log表，二阶段根据undo_log表进行回滚 | **支持 ACID 事务的关系型数据库**                             | 开发时需注意：脏读                      | 性能较高 | 开发简单 |
| TCC 模式<br>[TCC模式官方文档](https://seata.io/zh-cn/docs/dev/mode/tcc-mode.html) | 手动补偿事务                                                 | 代理数据源，一阶段执行prepare方法，二阶段执行commit或rollback方法 | **不支持 ACID 事务的数据库**                                 | 开发时需注意：空回滚、幂等、悬挂        | 性能高   | 开发复杂 |
| Saga 模式<br>[SAGA模式官方文档](https://seata.io/zh-cn/docs/user/saga.html) |                                                              | 基于状态机引擎实现，用户设计状态图，开发rollback方法，状态机根据状态图 json 调用相关方法 | **业务流程长、业务流程多** <br>参与者包含其它公司或遗留系统服务，**无法提供 TCC 模式要求的三个接口** | 除了额外开发方法，需设计开发状态图 json | 性能高   | 开发复杂 |
| XA 模式<br>[XA模式官方文档](https://seata.io/zh-cn/docs/dev/mode/xa-mode.html) | 满足全局数据一致性. <br>AT、TCC、Saga 都是补偿型，无法做到真正的全局一致性. | 由数据库XA协议完成提交、回滚                                 | 支持XA 事务的数据库                                          | 性能较低                                | 性能较低 | 开发简单 |



### AT模式 [1]
![AT模式](./images/AT.jpg)


+ 典型的分布式事务过程：
  - TM 向 TC 申请开启一个全局事务，全局事务创建成功并生成一个全局唯一的 XID；
  - XID 在微服务调用链路的上下文中传播；
  - RM 向 TC 注册分支事务，将其纳入 XID 对应全局事务的管辖；
  - TM 向 TC 发起针对 XID 的全局提交或回滚决议；
  - TC 调度 XID 下管辖的全部分支事务完成提交或回滚请求。

### AT模式 示例 [4]
``` Java
@Service
public class OrderServiceImpl implements OrderService {
    ...
    @GlobalTransactional   ///  TM
    @Override
    public OperationResponse placeOrder(PlaceOrderRequestVO placeOrderRequestVO) throws Exception {
        ...

        // 扣减库存
        DynamicDataSourceContextHolder.setDataSourceKey(DataSourceKey.STOCK);
        boolean operationStockResult = stockService.reduceStock(placeOrderRequestVO.getProductId(), amount);

        // 扣减余额
        DynamicDataSourceContextHolder.setDataSourceKey(DataSourceKey.PAY);
        boolean operationBalanceResult = payService.reduceBalance(placeOrderRequestVO.getUserId(), price);

        ...
    }
}
```


``` Java
@Service
@Slf4j
public class PayServiceImpl implements PayService {
    ...

    /**
     * 事务传播特性设置为 REQUIRES_NEW 开启新的事务
     *
     * @param userId 用户 ID
     * @param price  扣减金额
     */
    @Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRES_NEW)   /// RM
    @Override
    public boolean reduceBalance(Long userId, Integer price) throws Exception {
        ...

        log.info("开始扣减用户 {} 余额", userId);
        Integer record = accountDao.reduceBalance(price);
        log.info("扣减用户 {} 余额结果:{}", userId, record > 0 ? "操作成功" : "扣减余额失败");

        return record > 0;

    }
    ...
}
```



## Seata 同类产品

+ TCC 模式

  Eg: 支付宝DTS #3<br>蚂蚁 XTS(内部)/DTX(蚂蚁金融云) #3 <br/>



+ 两阶段

  阿里 TXC(内部)/GTS(阿里云) <br>**非入侵性** <br>[AT Mode][AT Mode] 基于 支持本地 ACID 事务 的 "关系型数据库" <br>[MT Mode][MT Mode] 支持把"自定义"的分支事务纳入到全局事务的管理中



## 参考

1. [对比7种分布式事务方案，还是偏爱阿里开源的Seata，真香！(原理+实战)](https://mp.weixin.qq.com/s?__biz=MzU3MDAzNDg1MA==&mid=2247499421&idx=1&sn=a55797652284bafd9216ea981f4125e0)  ***
2. [Seata AT 模式](https://seata.io/zh-cn/docs/dev/mode/at-mode.html)  官方文档
3. [[Seata 使用调研](http://koca.szkingdom.com/forum/t/topic/322)](http://koca.szkingdom.com/forum/t/topic/322)
4. [Seata AT模式-多数据源](https://github.com/www6v/seata-samples/tree/master/multiple-datasource)
5. [seata的AT模式](https://blog.csdn.net/abcd930704/article/details/121650029)



   早期

1. 分布式事务之TCC事务 梁钟霖
2. 分布式事务之TCC服务设计和实现注意事项 绍辉
3. https://github.com/www6v/tcc-transaction
4. [更开放的分布式事务 | Fescar 品牌升级，更名为 Seata](https://mp.weixin.qq.com/s/S0touTyVWfolEqgFaAjLxg)
5. [关于开源分布式事务中间件Fescar，我们总结了开发者关心的13个问题](https://mp.weixin.qq.com/s/XTCZEZdmToWrETbR1GtR4g)



