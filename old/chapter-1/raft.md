

一. 总结




二. raft-分区脑裂


![raft-patition](https://user-images.githubusercontent.com/5608425/64484884-1c425480-d24b-11e9-92c1-865111cc016d.JPG)  
分区脑裂[非majority有uncommited log、 term1]

![raft-patition-1](https://user-images.githubusercontent.com/5608425/64484885-1c425480-d24b-11e9-8375-102d20506265.JPG)  
分区脑裂[majority可以同步log、 term2]


## 参考：

1. [raft](http://thesecretlivesofdata.com/raft/)  动画
2. [The Raft Consensus Algorithm](https://raft.github.io/)  good 动画 各种系统实现 未
3. [Raft Distributed Consensus Algorithm Visualization](http://kanaka.github.io/raft.js/) 动画 未
4. [Raft对比ZAB协议](https://my.oschina.net/pingpangkuangmo/blog/782702)
5. [raft协议和zab协议有啥区别？](https://www.zhihu.com/question/28242561)
6. [一张图看懂Raft](http://www.seflerzhou.net/post-109.html) 未

---
### 论文
1. [Raft一致性算法论文译文](https://www.infoq.cn/article/raft-paper/)
2. [In Search of an Understandable Consensus Algorithm(Extended Version)](https://raft.github.io/raft.pdf)  raft


