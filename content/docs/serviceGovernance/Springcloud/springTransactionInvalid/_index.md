---
title: Spring  Transaction  失效
date: 2022-07-20 14:30:49
tags: 
  - spring
categories: 
  - 中间件
  - spring 
  - 事务
---


<p></p>
<!-- more -->


# Spring事务失效问题
###  spring事务失效 [1]

	- 场景：普通方法调用事务方法时，事务会失效
	- 解决：要在普通方法(一般是最外层)上加上@Transactional


###  代理不生效 [2]
+ **非public修饰的方法**
  在AbstractFallbackTransactionAttributeSource类的computeTransactionAttribute方法中有个判断，如果目标方法不是public，则TransactionAttribute返回null，即不支持事务。
  
+ 被final、static关键字修饰的类或方法
  spring事务底层使用了aop，也就是通过jdk动态代理或者cglib，帮我们生成了代理类，在代理类中实现的事务功能。但如果某个方法用final修饰了，那么在它的代理类中，就无法重写该方法，而添加事务功能。
  
+ **类方法内部调用**
  updateStatus方法拥有事务的能力是因为spring aop生成代理了对象，但是这种方法直接调用了this对象的方法，所以updateStatus方法不会生成事务
  + 解决方案
   - 新加一个Service方法
   - 在该Service类中注入自己
   - **通过AopContent类**

+ 当前类没有被Spring管理
  
+ 多线程调用
  spring的事务是通过数据库连接来实现的。当前线程中保存了一个map，key是数据源，value是数据库连接。
  同一个事务，其实是指同一个数据库连接，只有拥有同一个数据库连接才能同时提交和回滚。如果在不同的线程，拿到的数据库连接肯定是不一样的，所以是不同的事务。
  
+ (存储引擎)表不支持事务

+ 未开启事务
  springboot通过DataSourceTransactionManagerAutoConfiguration类，已经默默的帮你开启了事务。
  使用的还是传统的spring项目，则需要在applicationContext.xml文件中，手动配置事务相关参数。如果忘了配置，事务肯定是不会生效的。

+ 将注解标注在接口方法上


### 错误使用@Transactional [2]
+ 错误的传播机制
  目前只有这三种传播特性才会创建新事务：REQUIRED，REQUIRES_NEW，NESTED。
  
+ **异常被内部catch**
  如果想要spring事务能够正常回滚，必须抛出它能够处理的异常。如果没有抛异常，则spring认为程序是正常的。
  
+ rollbackFor属性设置错误
  ```
    @Transactional(rollbackFor = BusinessException.class)
    public void add(UserModel userModel) throws Exception {
       saveData(userModel);
       updateData(userModel);
    }
  ```

+ 嵌套事务
  可以将内部嵌套事务放在try/catch中，并且不继续往上抛异常。这样就能保证，如果内部嵌套事务中出现异常，只回滚内部事务，而不影响外部事务。

+ 手动抛了别的异常


# 参考
1. [Spring 踩坑之@Transactional 神奇失效  小鱼儿](https://segmentfault.com/a/1190000014617571)
2. [spring事务（注解 @Transactional ）失效的12种场景](https://blog.csdn.net/mccand1234/article/details/124571619) 
3. [spring中12种@Transactional的失效场景(小结)](https://www.45fan.com/article.php?aid=1CO8aGBW5f63eGYH)
100. [Spring @Async/@Transactional 失效的原因及解决方案](https://www.jianshu.com/p/9a0de6577ed7) 未



