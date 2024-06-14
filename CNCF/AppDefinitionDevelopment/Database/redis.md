#### Deploy by Binaries
> 官方包下载地址：http://download.redis.io/redis-stable/

##### Download and Compile
```shell
# 下载源码
wget https://download.redis.io/redis-stable.tar.gz

# 解压编译
tar -xzvf redis-stable.tar.gz
cd redis-stable
make

# 安装编译好的二进制命令到执行 prefix 目录
make PREFIX=/usr/local/bin install

```

[[sc-redis-cluster|redis常用配置]]

##### Single Mode
```shell
# 复制配置文件
cp redis.conf /etc/redis.conf

# 前台启动 server
/usr/local/bin/redis-server /etc/redis.conf
# daemon 方式启动
nohup /usr/local/bin/redis-server /etc/redis.conf
```


##### Cluster Mode
初始化配置与启动
```shell
# 创建目录
mkdir -p /opt/redis/{bin,data,conf,logs}
mkdir -p /opt/redis/data/{7001..7003}

# 复制编译后二进制命令与配置
cp /usr/local/bin/redis-* /opt/redis/bin/
cp redis.conf /opt/redis/conf/redis_7001.conf
cp redis.conf /opt/redis/conf/redis_7002.conf
cp redis.conf /opt/redis/conf/redis_7003.conf

# 修改配置文件
cat > /opt/redis/conf/redis_7001.conf << "EOF"
bind 0.0.0.0
port 7001
# 是否后台进程启动
daemonize yes
supervised auto
pidfile /opt/redis/logs/redis_7001.pid
logfile /opt/redis/logs/redis_7001.log
dir /opt/redis/data/7001
# RDB 持久化配置
stop-writes-on-bgsave-error yes
dbfilename dump.rdb
rdb-del-sync-files no
masterauth redis123
requirepass redis123
# AOF 配置
appendonly yes
appendfilename "appendonly.aof"
appendfsync everysec
# 集群模式
cluster-enabled yes
cluster-node-timeout 15000
# 禁用高危命令
rename-command FLUSHALL ""
rename-command FLUSHDB  ""
rename-command CONFIG   ""
rename-command SHUTDOWN ""
rename-command KEYS     ""
EOF

# 复制修改其他 redis 节点配置
cp /opt/redis/conf/redis_7001.conf /opt/redis/conf/redis_7002.conf 
cp /opt/redis/conf/redis_7001.conf /opt/redis/conf/redis_7003.conf 

# 启动 redis，3主3从模式需启动6个 redis 实例
redis-server conf/redis_7001.conf
redis-server conf/redis_7002.conf
redis-server conf/redis_7003.conf
```
集群初始化创建
```shell
# cluster-replicas 配置 slave 节点数量，建议为3主3从配置
redis-cli --cluster-replicas 0 --cluster create \
127.0.0.1:7001 \
127.0.0.1:7002 \
127.0.0.1:7003
```


##### Run and Boot
```shell
# redis 配置文件方式，打开配置即使用守护进程启动
daemonize yes

# Systemd 方式，supervised 需配置为 systemd 或 auto
cat > /etc/systemd/system/redis.service << "EOF"
[Unit]
Description=Redis In-Memory Data Store
Documentation=https://redis.io/
Wants=network-online.target
After=network-online.target

[Service]
# Environment=statedir=/opt/redis
# ExecStartPre=/bin/mkdir -p ${statedir}
WorkingDirectory=/opt/redis
Type=forking
# 根据配置对应修改
ExecStart=/usr/local/bin/redis-server /opt/redis/conf/redis_7001.conf
#ExecStop=/usr/local/bin/redis-cli -p 7001 -a redis123 shutdown
ExecReload=/bin/kill -s HUP $MAINPID
# PIDFile=/opt/redis/logs/redis_7001.pid
LimitNOFILE=65535
#OOMScoreAdjust=-900
Restart=always
RestartSec=5s
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start redis.service
systemctl enable redis.service
```


##### Verify
```shell
# client 端连接命令与参数
# /usr/local/bin/redis-cli [-h host] [-p port] [-a password] [-c]
redis-cli -p 7001 -a redis123 -c 
SET a aaa
GET a

# 集群异常处理
# 查看节点信息
redis-cli -h 127.0.0.1 -p 7001 -a redis123 -c CLUSTER NODES 
# 剔除异常节点
redis-cli -h 127.0.0.1 -p 7001 -a redis123 -c CLUSTER FORGET 82f9c8aa46e695cc21e7e0882e08389f123a5c23
# 重新将 slot 分片
redis-cli --cluster reshard 127.0.0.1:7001 -a redis123


# 常用命令
AUTH password
SELECT DB
INFO
KEYS *
ACL 
CLUSTER NODES
CLUSTER INFO

```


##### troubleshooting
```shell
../deps/jemalloc/lib/libjemalloc.a: No such file or directory
# 解决：
apt install libjemalloc-dev
make 

```


#### Deploy by Helm
##### download helm charts
[[cc-helm|helm使用]]
```shell
# add and update repo
helm repo add bitnami https://charts.bitnami.com/bitnami
helm update

# get charts package
# single mode
helm fetch bitnami/redis --untar
# cluster mode
helm fetch bitnami/redis-cluster  --untar

# configure and run
vim values.yaml
global:
  storageClass: "xxx"
  redis:
    password: "xxx"
# single mode config
architecture: standalone
master:
  disableCommands:
    - FLUSHDB
    - FLUSHALL
    - CONFIG
    - SHUTDOWN
    - KEYS
# cluster mode config
cluster:
  nodes: 3
  replicas: 0
vim templates/configmap.yaml
data:
  redis-default.conf: |-
    rename-command FLUSHALL ""
    rename-command FLUSHDB  ""
    rename-command CONFIG   ""
    rename-command SHUTDOWN ""
    rename-command KEYS     ""
...

# install
helm -n middleware install redis .
helm -n middleware install redis-cluster .
```


##### deploy redis-cluster
```shell
# Chart.yaml 配置修改，视情况修改
sed -i 's/^name: .*/name: uat-redis-xxx/' Chart.yaml


# values.yaml 配置修改，必修改项
vim values.yaml
## 修改全局持久化存储类与密码
global:
  storageClass: nfs-client
  redis:
    password: redis-pwd
## 集群相关配置
cluster:
  init: true
  nodes: 6
  replicas: 1


## 安装
helm -n middleware install uat-redis-cluster .

```

##### Verify
```shell
# 查看 redis 密码
kubectl -n middleware get secret uat-redis-cluster -o jsonpath="{.data.redis-password}" | base64 -d

# kubectl -n middleware get pod
# kubectl -n middleware get service
NAME                                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)              AGE
service/uat-redis-cluster-headless   ClusterIP   None            <none>        6379/TCP,16379/TCP   2m20s
service/uat-redis-cluster            ClusterIP   10.43.148.142   <none>        6379/TCP             2m20s   


# k8s 集群内部可通过 service 的 headless 实现集群访问
kafka.servers = uat-redis-cluster-0.redis-cluster-headless.middleware.svc:6379,uat-redis-cluster-1.redis-cluster-headless.middleware.svc:6379,.....


# 启动 client 容器测试
kubectl -n middleware run redis-client --image docker.io/bitnami/redis-cluster --command -- sleep infinity
kubectl -n middleware exec -it redis-client -- bash
```


#### Run On Docker
```shell
# Standlone
docker run --rm --name yakir-redis -e REDIS_PASSWORD=123 -p 6379:6379 -v /docker-volume/data:/data -d redis


# Cluster
docker run --rm --name redis-cluster -e ALLOW_EMPTY_PASSWORD=yes -d bitnami/redis-cluster
```



>Reference:
>1. [官方文档地址](https://redis.io/docs/getting-started/)
>2. [官方 github 地址](https://github.com/redis/redis)
>3. [redis 集群方案](https://segmentfault.com/a/1190000022028642)
>4. [k8s redis-cluster 部署](https://www.airplane.dev/blog/deploy-redis-cluster-on-kubernetes)