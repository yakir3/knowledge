#### Deploy by Binaries
> 官方包下载j地址：https://kafka.apache.org/downloads
> kafka3.3 以上版本使用 Kraft 协议替代 zookeeper，可不启动 zookeeper

##### Zookeeper Mode
[[zookeeper|zookeeper-deploy]]
下载官方包
```bash
# 下载解压
cd /opt/
wget https://archive.apache.org/dist/kafka/3.3.1/kafka_2.13-3.3.1.tgz
tar xf kafka_2.13-3.3.1.tgz && rm -rf kafka_2.13-3.3.1.tgz  
# 进入目录
mv kafka_2.13-3.3.1 kafka_3.3.1
cd kafka_3.3.1
```

[[sc-kafka|kafka常用配置]]
修改配置
```bash
# zookeeper 配置
cat > config/zookeeper.properties << "EOF"
# 初始延迟时间（心跳时间单位）
tickTime=2000
initLimit=10
syncLimit=5
# 集群时需配置 zk 数据与日志目录（单点集群使用不同目录）
dataDir=/opt/kafka_3.3.1/zk-data
dataLogDir=/opt/kafka_3.3.1/zk-logs
clientPort=2181
# 集群时需配置服务通信与选举用端口（单点集群使用不同端口）
#server.0=1.1.1.1:2888:3888
#server.1=1.1.1.2:2888:3888
#server.2=1.1.1.3:2888:3888
maxClientCnxns=300
admin.enableServer=false
EOF


# kafka 配置
cat > config/server.properties << "EOF"
# 集群启动时 broker.id 必须不同
broker.id=0
listeners=PLAINTEXT://:9092
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
log.dirs=/opt/kafka_3.3.1/data
# 分区与副本相关配置
num.partitions=3
num.recovery.threads.per.data.dir=1
offsets.topic.replication.factor=3
transaction.state.log.replication.factor=3
transaction.state.log.min.isr=2
default.replication.factor=3
min.insync.replicas=2
log.retention.hours=168
log.retention.check.interval.ms=300000
# 单点 zk 时只需配置单 zk 配置
zookeeper.connect=1.1.1.1:2181,1.1.1.2:2181,1.1.1.3:2181
zookeeper.connection.timeout.ms=18000
# 生产环境建议配置为3
group.initial.rebalance.delay.ms=0
EOF
```

启动服务与开机自启
```bash
# 集群方式启动启动 zookeeper 需要创建 myid
# 多点集群
echo 0 > /opt/kafka_3.3.1/zk-data/myid
echo 1 > /opt/kafka_3.3.1/zk-data/myid
echo 2 > /opt/kafka_3.3.1/zk-data/myid
# 单点集群
echo 0 > /opt/kafka_3.3.1/zk0-data/myid
echo 1 > /opt/kafka_3.3.1/zk1-data/myid
echo 2 > /opt/kafka_3.3.1/zk2-data/myid

# 启动 zookeeper
./bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
# 启动 kafka
./bin/kafka-server-start.sh -daemon config/server.properties

# 开机自启
# Systemd 方式
cat > /etc/systemd/system/kafka.service << EOF
[Unit]
Description=Apache Kafka server
Documentation=https://kafka.apache.org
After=network.target
Wants=network-online.target
 
[Service]
Type=forking
ExecStart=/opt/kafka_3.3.1/bin/kafka-server-start.sh /opt/kafka_3.3.1/config/server.properties
Restart=on-failure
LimitNOFILE=65535
 
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl start kafka.service
systemctl enable kafka.service
```

##### Kraft Mode
下载官方包
```bash
# 下载解压
cd /opt/
wget https://archive.apache.org/dist/kafka/3.3.1/kafka_2.13-3.3.1.tgz
tar xf kafka_2.13-3.3.1.tgz && rm -rf kafka_2.13-3.3.1.tgz  
# 进入目录
mv kafka_2.13-3.3.1 kafka_3.3.1
cd kafka_3.3.1
```

kraft 配置与格式化
```bash
# 集群启动时配置点
# vim config/kraft/server.properties
# node.id 集群启动每个节点需不同
node.id=1
controller.quorum.voters=1@1.1.1.1:9093,2@1.1.1.2:9093,3@1.1.1.3:9093
listeners=PLAINTEXT://:9092,CONTROLLER://:9093
inter.broker.listener.name=PLAINTEXT
advertised.listeners=PLAINTEXT://localhost:9092
controller.listener.names=CONTROLLER
# meta 数据保存路径
log.dirs=/opt/kafka_3.3.1/data
# 分区与副本相关配置
num.partitions=3
num.recovery.threads.per.data.dir=1
offsets.topic.replication.factor=3
transaction.state.log.replication.factor=3
transaction.state.log.min.isr=2
default.replication.factor=3
min.insync.replicas=2


# 格式化存储目录，根据配置文件生成 meta 数据
KAFKA_CLUSTER_ID="$(./bin/kafka-storage.sh random-uuid)"
./bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c config/kraft/server.properties
```

启动服务与开机自启
```bash
# 启动 kafka
./bin/kafka-server-start.sh -daemon config/kraft/server.properties


# 开机自启
# Systemd 方式
cat > /etc/systemd/system/kafka.service << EOF
[Unit]
Description=Apache Kafka server
Documentation=https://kafka.apache.org
After=network.target
Wants=network-online.target
 
[Service]
Type=forking
ExecStart=/opt/kafka_3.3.1/bin/kafka-server-start.sh -daemon /opt/kafka_3.3.1/config/kraft/server.properties
Restart=on-failure
LimitNOFILE=265535
 
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start kafka.service
systemctl enable kafka.service
```

如需自定义 JAVA 环境时在启动脚本添加环境变量
```bash
export JAVA_HOME=/opt/jdkx.xx
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
```

##### Verify
```bash
# 创建 topic
./bin/kafka-topics.sh --bootstrap-server 127.0.0.1:9092 --create --topic yakir-test
# 查看分区副本信息
./bin/kafka-topics.sh --bootstrap-server 127.0.0.1:9092 --describe 
```
[[cc-kafka|其他kafka常用命令]]


#### Deploy by Helm
##### Get helm charts
[[cc-helm|helm使用]]
```bash
# add and update repo
helm repo add bitnami https://charts.bitnami.com/bitnami
helm update

# get charts package
helm fetch bitnami/kafka --version=20.0.6  --untar
cd kafka

# configure and run
vim values.yaml
global:
  storageClass: xxx
config: |-
  ...
heapOpts: -Xmx1024m -Xms1024m
defaultReplicationFactor: 3
offsetsTopicReplicationFactor: 3
transactionStateLogReplicationFactor: 3
transactionStateLogMinIsr: 2
numPartitions: 3
replicaCount: 3
...

# install
helm -n middleware install kafka .

```

##### Persistent storage
kafka 需要使用持久化存储配置，k8s 本身不支持 nfs 做 storageclass ，需要安装第三方 nfs 驱动实现

[[nfs-server|1.nfs-server部署]]

2.安装 nfs 第三方驱动插件
[[nfs-server#nfs-subdir-external-provisioner|deploy provisioner]]


##### Install kafka
```bash
# Chart.yaml 配置修改，视情况修改
sed -i 's/^name: .*/name: uat-kafka-xxx/' Chart.yaml

# values.yaml 配置修改，必修改项
vim values.yaml
## 修改全局持久化存储类
global:
  storageClass: nfs-client
## kafka 相关配置
logsDirs: /bitnami/kafka/data
defaultReplicationFactor: 3
offsetsTopicReplicationFactor: 3
transactionStateLogReplicationFactor: 3
transactionStateLogMinIsr: 2
numPartitions: 3
replicaCount: 3
podLabels:
  app: uat-kafka-xxx
zookeeper:
  enabled: true
## 新版本 kraft 协议，开启 kraft 算法需要关闭 zookeeper
kraft:
  enabled: false


## 安装
helm -n middleware install uat-kafka-xxx .

```

##### Verify
```bash
# kubectl -n middleware get pod 
# kubectl -n middleware get service
uat-kafka                          ClusterIP   10.234.14.230   <none>        9092/TCP                     
uat-kafka-headless                 ClusterIP   None            <none>        9092/TCP,9093/TCP            


# k8s 集群内部可通过 service 的 headless 实现集群访问
kafka.servers = uat-kafka-0.uat-kafka-v3-headless.middleware.svc:9092,uat-kafka-1.uat-kafka-v3-headless.middleware.svc:9092,uat-kafka-2.uat-kafka-v3-headless.middleware.svc:9092


# 启动 client 容器测试
kubectl -n middleware run kafka-client --image docker.io/bitnami/kafka:3.4.0-debian-11-r22 --command -- sleep infinity
kubectl -n middleware exec -it kafka-client -- bash

```


#### Run On Docker
```bash
# run by docker or docker-compose
# https://hub.docker.com/r/bitnami/kafka
```




>Reference:
>1. [storaclass 存储类官方说明](https://kubernetes.io/zh-cn/docs/concepts/storage/storage-classes/)
>2. [nfs-server 驱动部署方式](https://blog.51cto.com/smbands/4903841)
>3. [nfs 驱动 helm 安装](https://artifacthub.io/packages/helm/nfs-subdir-external-provisioner/nfs-subdir-external-provisioner)
>4. [kafka kraft 协议介绍](https://www.infoq.cn/article/j1jm5qehr1jiequby0ot)
>5. [kafka 官方相关地址](https://github.com/apache/kafka)
