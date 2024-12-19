---
title: MySQL Logs
date: 2022-02-27 22:25:29
weight: 6
tags:
  - mysql
categories: 
  - 数据库
  - 关系型 
  - mysql
---

<p></p>
<!-- more -->



## MySQL Log和事务[0]

##### redo log 

+  有了redolog之后，当对缓冲区的数据进行增删改之后，会首先将操作的数据页的变化，记录在redo log buffer中。在事务提交时，会将redo log buffer中的数据刷新到redo log磁盘文件中。过一段时间之后，如果刷新缓冲区的脏页到磁盘时，**发生错误，此时就可以借助于redo log进行数据恢复，这样就保证了事务的持久性**。
+  因为在业务操作中，我们操作数据一般都是**随机读写磁盘**的，而不是顺序读写磁盘。 而redo log在往磁盘文件中写入数据，由于是日志文件，所以都是**顺序写**的。顺序写的效率，要远大于随机写。 这种先写日志的方式，称之为** WAL（Write-Ahead Logging）**。

#####  undo log 

回滚日志，用于记录数据被修改前的信息 , 作用包含两个 : **提供回滚(保证事务的原子性) 和MVCC(多版本并发控制) **。

undo log和redo log记录物理日志不一样，它是逻辑日志。可以认为当delete一条记录时，undolog中会记录一条对应的insert记录，反之亦然，当update一条记录时，它记录一条对应相反的update记录。

##### 总结

| Log      | 性质               | 记录内容                 | ACID                |
| -------- | ------------------ | ------------------------ | ------------------- |
| redo log | 物理日志[记录内容] | wal                      | 保证事务的持久性[D] |
| undo log | 物理日志[记录内容] | 被修改前的信息，提供回滚 | 保证事务的原子性[A] |

​    binlog                 逻辑日志[记录操作]





## MySQL Log和可靠性
#####  binlog的三种格式[1]
+ statement
+ row格式
+ mixed格式: statement or row格式

  因为有些**statement格式**的binlog可能会**导致主备不一致**，所以要使用row格式。
  但**row格式的缺点是，很占空间**。比如你用一个delete语句删掉10万行数据，用statement的话就是一个SQL语句被记录到binlog中，占用几十个字节的空间。但如果用row格式的binlog，就要把这10万条记录都写到binlog中。这样做，不仅会占用更大的空间，同时写binlog也要耗费IO资源，影响执行速度。
  所以，MySQL就取了个**折中方案**，也就是有了mixed格式的binlog。**mixed格式**的意思是，MySQL自己会判断这条SQL语句是否可能引起主备不一致，如果有可能，就用row格式，否则就用statement格式。
  也就是说，mixed格式**可以利用statment格式的优点，同时又避免了数据不一致的风险**.因此，如果你的线上MySQL设置的binlog格式是statement的话，那基本上就可以认为这是一个不合理的设置。你至少应该把binlog的格式设置为mixed。


##### redo log 和 undo log [4]

+ redo Log 
  + WAL日志，保证事务持久性
  + buffer楼盘之前数据库意外宕机， 可以进行数据的恢复

+ undo log
  + 保证事务原子性， 回滚或者事务异常，可以回滚到历史版本
  + 实现MVCC的必要条件

```
  事务开始.
      记录A=1到undo log.
      修改A=3.
      记录A=3到redo log.( 先写内存， 后同步到磁盘中)

      记录B=2到undo log.
      修改B=4.
      记录B=4到redo log.( 先写内存， 后同步到磁盘中)

      将redo log写入磁盘。
  事务提交
```



## 参考

0. [黑马程序员 MySQL数据库入门到精通](https://www.bilibili.com/video/BV1Kr4y1i7ru?p=78)  P138 - P140
   [mysql_note](https://github.com/www6v/mysql_note) 笔记1
   [MySQL 索引](https://frxcat.fun/database/MySQL/MySQL_Advanced_index/) 笔记2 ***

1. 《MySQL是怎么保证主备一致的？》 MySQL实战45讲  丁奇
4. 《云数据库架构》 1.1.5  1.1.7 - 阿里云