```shell
##### redis-cluster.conf
bind 0.0.0.0
protected-mode yes
port 7001
# 半连接数量，与操作系统配置取小值
tcp-backlog 511
timeout 0
tcp-keepalive 300
# 后台进程启动
daemonize yes
pidfile /opt/redis/logs/redis_7001.pid
loglevel notice
logfile /opt/redis/logs/redis_7001.log
databases 16
always-show-logo no
set-proc-title yes
proc-title-template "{title} {listen-addr} {server-mode}"

# RDB 持久化配置
# 持久化出错，主进程是否停止写入
stop-writes-on-bgsave-error yes
# 是否压缩
rdbcompression yes
# 导入时是否检查
rdbchecksum yes
dbfilename dump.rdb
rdb-del-sync-files no
# 数据目录
dir /opt/redis/data/7001
# master 节点密码，副本复制同步请求需认证
masterauth redis123
# 表示900秒（15分钟）内至少有1个key的值发生变化，则执行
save 900 1
# 表示300秒（5分钟）内至少有1个key的值发生变化，则执行
save 300 10
# 表示60秒（1分钟）内至少有10000个key的值发生变化，则执行
save 60 10000
# 关闭RDB方式的持久化
# save ""

replica-serve-stale-data yes
replica-read-only yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-disable-tcp-nodelay no
replica-priority 100
acllog-max-len 128
# acl 认证
# aclfile /etc/redis/users.acl
# 密码设置，redis6 以上兼容
requirepass redis123
# 可用最大内存
maxmemory 1gb
# 清理策略
# maxmemory-policy volatile-lru

lazyfree-lazy-eviction no
lazyfree-lazy-expire no
lazyfree-lazy-server-del no
replica-lazy-flush no
lazyfree-lazy-user-del no
lazyfree-lazy-user-flush no

# oom score 配置
oom-score-adj no
oom-score-adj-values 0 200 800
disable-thp yes

# AOF 配置
appendonly yes
appendfilename "appendonly.aof"
# 同步方式
appendfsync everysec
# aof 重写时是否同步
no-appendfsync-on-rewrite no
# 重写触发机制
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
# 加载 aof 错误行为：写入日志继续执行/中止
aof-load-truncated yes
aof-use-rdb-preamble yes
aof-timestamp-enabled no

# 集群模式
cluster-enabled yes
cluster-node-timeout 15000
# 慢日志
slowlog-log-slower-than 10000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events ""
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
stream-node-max-bytes 4096
stream-node-max-entries 100
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit replica 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
dynamic-hz yes
# aof 文件重写策略是否启用
aof-rewrite-incremental-fsync yes
# rdb 自动触发策略是否启用
rdb-save-incremental-fsync yes
jemalloc-bg-thread yes
# 禁用高危命令
rename-command FLUSHALL ""
rename-command FLUSHDB  ""
rename-command CONFIG   ""
rename-command SHUTDOWN ""
rename-command KEYS     ""
```