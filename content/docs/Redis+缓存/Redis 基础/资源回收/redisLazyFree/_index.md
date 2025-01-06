---
title: Redis LazyFree
date: 2022-06-01 10:46:16
weight: 1
tags:
  - KV
categories:
  - 数据库
  - KV
  - Redis
---

<p></p>
<!-- more -->


## 场景 [1]

+ 场景一：客户端执行的**显示删除/清除命令**，比如 del，flushdb 等；
+ 场景二：某些指令带有的隐式删除命令，比如 move , rename 等；
+ 场景三：到达**过期**时间的数据需要删除；
+ 场景四：使用内存达到 maxmemory 后被选出来要**淘汰**的数据需要删除；
+ 场景五：在主从同步全量同步阶段，从库收到主库的 RDB 文件后要先删除现有的数据再加载 RDB 文件；




## 相关配置
```
惰性删除相 关的配置项

lazyfree-lazy-eviction：对应缓存淘汰时的数据删除场景。
lazyfree-lazy-expire：对应过期 key 的删除场景。
lazyfree-lazy-server-del：对应会隐式进行删除操作的 server 命令执行场景。
replica-lazy-flush：对应从节点完成全量同步后，删除原有旧数据的场景。
```


## 源代码
``` C
evict.c

int freeMemoryIfNeeded(void) {
    /*......*/
    /* Finally remove the selected key. */
        if (bestkey) {
            db = server.db+bestdbid;
            robj *keyobj = createStringObject(bestkey,sdslen(bestkey));
            propagateExpire(db,keyobj,server.lazyfree_lazy_eviction);  ### 1
            /* We compute the amount of memory freed by db*Delete() alone.
             * It is possible that actually the memory needed to propagate
             * the DEL in AOF and replication link is greater than the one
             * we are freeing removing the key, but we can't account for
             * that otherwise we would never exit the loop.
             *
             * AOF and Output buffer memory will be freed eventually so
             * we only care about memory used by the key space. */
            delta = (long long) zmalloc_used_memory();    //获取当前内存使用量
            latencyStartMonitor(eviction_latency);
            if (server.lazyfree_lazy_eviction)   /////. 如果 lazyfree_lazy_eviction 被设置为 1，也就是启用了缓存淘汰时的惰性删除，
                dbAsyncDelete(db,keyobj);        /////.  那么，删除操作对应的命令就是 UNLINK；
            else
                dbSyncDelete(db,keyobj);         /////.  否则的话，命令就是 DEL。

            /*......*/
            delta -= (long long) zmalloc_used_memory();   ///根据当前内存使用量计算数据删除前后释放....
            mem_freed += delta;    //更新已释放的内存量
            /*......*/
}
```


``` C
db.c ### 1

/* Propagate expires into slaves and the AOF file.
 * When a key expires in the master, a DEL operation for this key is sent
 * to all the slaves and the AOF file if enabled.
 *
 * This way the key expiry is centralized in one place, and since both
 * AOF and the master->slave link guarantee operation ordering, everything
 * will be consistent even if we allow write operations against expiring
 * keys. */
void propagateExpire(redisDb *db, robj *key, int lazy) {
    robj *argv[2];

    argv[0] = lazy ? shared.unlink : shared.del;    // 如果server启用了lazyfree-lazy
    argv[1] = key;                //被淘汰的key对象
    incrRefCount(argv[0]);
    incrRefCount(argv[1]);

    if (server.aof_state != AOF_OFF)   ///  是否启用了 AOF 日志 /// 如果启用了AOF日志
        feedAppendOnlyFile(server.delCommand,db->id,argv,2);  // 把被淘汰 key 的删除操作记录到 AOF 文件中，以保证后续使用 AOF 文件进行 Redis 数据库恢复时，可以和恢复前保持一致
    replicationFeedSlaves(server.slaves,db->id,argv,2);   //// 把删除操作同步给从节点，以保证主从节点的数据一致

    decrRefCount(argv[0]);
    decrRefCount(argv[1]);
}
```

```
子操作一

子操作一：将被淘汰的键值对从哈希表中去除，这里的哈希表既可能是设置了过期 key
的哈希表，也可能是全局哈希表。
子操作二：释放被淘汰键值对所占用的内存空间。
```

``` C
子操作一

/* Search and remove an element. This is an helper function for
 * dictDelete() and dictUnlink(), please check the top comment
 * of those functions. */
static dictEntry *dictGenericDelete(dict *d, const void *key, int nofree) {
... ...

    h = dictHashKey(d, key);  //计算key的哈希值 

    for (table = 0; table <= 1; table++) {
        idx = h & d->ht[table].sizemask;  //根据key的哈希值获取它所在的哈希桶编号
        he = d->ht[table].table[idx];   //获取key所在哈希桶的第一个哈希项
        prevHe = NULL;
        while(he) {        //在哈希桶中逐一查找被删除的key是否存在
            if (key==he->key || dictCompareKeys(d, key, he->key)) {
                /* Unlink the element from the list */
                //如果找见被删除key了，那么将它从哈希桶的链表中去除
                if (prevHe)
                    prevHe->next = he->next;
                else
                    d->ht[table].table[idx] = he->next;
                if (!nofree) {        //如果要同步删除，那么就释放key和value的内存空间
                    dictFreeKey(d, he);     //调用dictFreeKey释放
                    dictFreeVal(d, he);
                    zfree(he);
                }
                d->ht[table].used--;
                return he;
            }
            prevHe = he;
            he = he->next;           //当前key不是要查找的key，再找下一个
        }
        ......
    }



/* Remove an element, returning DICT_OK on success or DICT_ERR if the
 * element was not found. */
int dictDelete(dict *ht, const void *key) {
    return dictGenericDelete(ht,key,0) ? DICT_OK : DICT_ERR;
}


/* Remove an element from the table, but without actually releasing
 * the key, value and dictionary entry. The dictionary entry is returned
 * if the element was found (and unlinked from the table), and the user
 * should later call `dictFreeUnlinkedEntry()` with it in order to release it.
 * Otherwise if the key is not found, NULL is returned.
 *
 * This function is useful when we want to remove something from the hash
 * table but want to use its value before actually deleting the entry.
 * Without this function the pattern would require two lookups:
 *
 *  entry = dictFind(...);
 *  // Do something with entry
 *  dictDelete(dictionary,entry);
 *
 * Thanks to this function it is possible to avoid this, and use
 * instead:
 *
 * entry = dictUnlink(dictionary,entry);
 * // Do something with entry
 * dictFreeUnlinkedEntry(entry); // <- This does not need to lookup again.
 */
dictEntry *dictUnlink(dict *ht, const void *key) {
    return dictGenericDelete(ht,key,1);
}
```


```  C
子操作二


基于异步删除的数据淘汰
dbAsyncDelete


/* Delete a key, value, and associated expiration entry if any, from the DB.
 * If there are enough allocations to free the value object may be put into
 * a lazy free list instead of being freed synchronously. The lazy free list
 * will be reclaimed in a different bio.c thread. */
#define LAZYFREE_THRESHOLD 64
int dbAsyncDelete(redisDb *db, robj *key) {
    /* Deleting an entry from the expires dict will not free the sds of
     * the key, because it is shared with the main dictionary. */
    if (dictSize(db->expires) > 0) dictDelete(db->expires,key->ptr);  /// 在过期 key 的哈希表中同步删除被淘汰的键值对

    /* If the value is composed of a few allocations, to free in a lazy way
     * is actually just slower... So under a certain limit we just free
     * the object synchronously. */
    dictEntry *de = dictUnlink(db->dict,key->ptr);  /// 在全局哈希表中异步删除被淘汰的键值对
    if (de) {
        robj *val = dictGetVal(de);
        size_t free_effort = lazyfreeGetFreeEffort(val);

        /* If releasing the object is too much work, do it in the background
         * by adding the object to the lazy free list.
         * Note that if the object is shared, to reclaim it now it is not
         * possible. This rarely happens, however sometimes the implementation
         * of parts of the Redis core may call incrRefCount() to protect
         * objects, and then call dbDelete(). In this case we'll fall
         * through and reach the dictFreeUnlinkedEntry() call, that will be
         * equivalent to just calling decrRefCount(). */
        if (free_effort > LAZYFREE_THRESHOLD && val->refcount == 1) { /// 计算释放被淘汰键值对内存空间的开销///当被淘汰键值对是包含超过 64 个元素的集合类型时
            atomicIncr(lazyfree_objects,1);
            bioCreateBackgroundJob(BIO_LAZY_FREE,val,NULL,NULL); /// 会调用 bioCreateBackgroundJob 函数，来实际创建后台任务执行惰性删除
            dictSetVal(db->dict,de,NULL);
        }
    }

    /* Release the key-val pair, or just the key if we set the val
     * field to NULL in order to lazy free it later. */
    if (de) {
        dictFreeUnlinkedEntry(db->dict,de);
        if (server.cluster_enabled) slotToKeyDel(key);
        return 1;
    } else {
        return 0;
    }
}


/* Return the amount of work needed in order to free an object.
 * The return value is not always the actual number of allocations the
 * object is compoesd of, but a number proportional to it.
 *
 * For strings the function always returns 1.
 *
 * For aggregated objects represented by hash tables or other data structures
 * the function just returns the number of elements the object is composed of.
 *
 * Objects composed of single allocations are always reported as having a
 * single item even if they are actually logical composed of multiple
 * elements.
 *
 * For lists the function returns the number of elements in the quicklist
 * representing the list. */
size_t lazyfreeGetFreeEffort(robj *obj) {
    if (obj->type == OBJ_LIST) {
        quicklist *ql = obj->ptr;
        return ql->len;
    } else if (obj->type == OBJ_SET && obj->encoding == OBJ_ENCODING_HT) {
        dict *ht = obj->ptr;
        return dictSize(ht);
    } else if (obj->type == OBJ_ZSET && obj->encoding == OBJ_ENCODING_SKIPLIST){
        zset *zs = obj->ptr;
        return zs->zsl->length;
    } else if (obj->type == OBJ_HASH && obj->encoding == OBJ_ENCODING_HT) {
        dict *ht = obj->ptr;
        return dictSize(ht);
    } else if (obj->type == OBJ_STREAM) {
        size_t effort = 0;
        stream *s = obj->ptr;

        /* Make a best effort estimate to maintain constant runtime. Every macro
         * node in the Stream is one allocation. */
        effort += s->rax->numnodes;

        /* Every consumer group is an allocation and so are the entries in its
         * PEL. We use size of the first group's PEL as an estimate for all
         * others. */
        if (s->cgroups) {
            raxIterator ri;
            streamCG *cg;
            raxStart(&ri,s->cgroups);
            raxSeek(&ri,"^",NULL,0);
            /* There must be at least one group so the following should always
             * work. */
            serverAssert(raxNext(&ri));
            cg = ri.data;
            effort += raxSize(s->cgroups)*(1+raxSize(cg->pel));
            raxStop(&ri);
        }
        return effort;
    } else {
        return 1; /* Everything else is a single allocation. */
    }
}
```

```
子操作二

基于同步删除的数据淘汰
dbSyncDelete
```

## 参考
1. [redis惰性删除 lazy free 源码剖析，干货满满](https://blog.csdn.net/LIFE_PLAN/article/details/127786442)
