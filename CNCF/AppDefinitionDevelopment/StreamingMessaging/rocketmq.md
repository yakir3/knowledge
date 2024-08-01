#### Introduction
...


#### Deploy By Binaries
##### Quick Start
```bash
# download source
cd /usr/local/src/
wget https://dist.apache.org/repos/dist/release/rocketmq/5.3.0/rocketmq-all-5.3.0-source-release.zip
unzip rocketmq-all-5.3.0-source-release.zip && rm -f rocketmq-all-5.3.0-source-release.zip
cd rocketmq-all-5.3.0-source-release

# compile and install
mvn -Prelease-all -DskipTests -Dspotbugs.skip=true clean install -U
cp -aR distribution/target/rocketmq-5.3.0/rocketmq-5.3.0 /opt/rocketmq-5.3.0

# soft link
ln -svf /opt/rocketmq-5.3.0 /opt/rocketmq
cd /opt/rocketmq

# postinstallation
export ROCKETMQ_HOME=/opt/rocketmq
#export JAVA_HOME=/opt/jdk21
export PATH=$PATH:/opt/rocketmq/bin

# local mode
# option1: single replication
./bin/mqnamesrv
./bin/mqbroker -n localhost:9876 --enable-proxy
# option2: 2m-2s-sync
./bin/mqnamesrv
./bin/mqbroker -n 192.168.1.1:9876 -c $ROCKETMQ_HOME/conf/2m-2s-sync/broker-a.properties --enable-proxy
./bin/mqbroker -n 192.168.1.1:9876 -c $ROCKETMQ_HOME/conf/2m-2s-sync/broker-a-s.properties --enable-proxy
./bin/mqbroker -n 192.168.1.1:9876 -c $ROCKETMQ_HOME/conf/2m-2s-sync/broker-b.properties --enable-proxy
./bin/mqbroker -n 192.168.1.1:9876 -c $ROCKETMQ_HOME/conf/2m-2s-sync/broker-b-s.properties --enable-proxy

# cluster mode(deployment on different machines)
# start multiple nameserver
./bin/mqnamesrv
# start broker: 2 master 2 slave with synchronous replication
./bin/mqbroker -n 192.168.1.1:9876,192.168.1.2:9876,192.168.1.3:9876 -c $ROCKETMQ_HOME/conf/2m-2s-sync/broker-a.properties
./bin/mqbroker -n 192.168.1.1:9876,192.168.1.2:9876,192.168.1.3:9876 -c $ROCKETMQ_HOME/conf/2m-2s-sync/broker-a-s.properties
./bin/mqbroker -n 192.168.1.1:9876,192.168.1.2:9876,192.168.1.3:9876 -c $ROCKETMQ_HOME/conf/2m-2s-sync/broker-b.properties
./bin/mqbroker -n 192.168.1.1:9876,192.168.1.2:9876,192.168.1.3:9876 -c $ROCKETMQ_HOME/conf/2m-2s-sync/broker-b-s.properties
# start multiple proxy
./bin/mqproxy -n 192.168.1.1:9876,192.168.1.2:9876,192.168.1.3:9876

# shutdown
./bin/mqshutdown broker
./bin/mqshutdown namesrv
```

##### Config and Boot
###### Config
```bash
# master config
vim conf/2m-2s-sync/broker-a.properties
vim conf/2m-2s-sync/broker-b.properties
# slave config
vim conf/2m-2s-sync/broker-a-s.properties
vim conf/2m-2s-sync/broker-b-s.properties

###
# common config
brokerClusterName=DefaultCluster
deleteWhen=04
fileReservedTime=48
brokerRole=SYNC_MASTER
flushDiskType=ASYNC_FLUSH
#namesrvAddr=
#listenPort=11011
#autoCreateTopicEnable=true
#autoCreateSubscriptionGroup=true
#mapedFileSizeCommitLog=1073741824
#mapedFileSizeConsumeQueue=300000
#diskMaxUsedSpaceRatio=88

# broker-a
brokerName=broker-a
brokerId=0
#storePathRootDir=/opt/rocketmq/store
#storePathCommitLog=/opt/rocketmq/store/commitlog
#storePathConsumeQueue=/opt/rocketmq/store/consumequeue
#storePathIndex=/opt/rocketmq/store/index
#storeCheckpoint=/opt/rocketmq/store/checkpoint
#abortFile=/opt/rocketmq/store/abort

# broker-b
brokerName=broker-b
brokerId=0

# broker-a-s
brokerName=broker-a
brokerId=0

# broker-b-s
brokerName=broker-b
brokerId=0
###
```

###### Boot(systemd)
```bash
cat > /etc/systemd/system/rocketmq.service << "EOF"
[Unit]
Description=Rocketmq
Documentation=https://rocketmq.apache.org/docs/
Wants=network-online.target
After=network-online.target

[Service]
ExecStartPre=
ExecStart=
LimitNOFILE=655350
LimitNPROC=65535
NoNewPrivileges=yes
#PrivateTmp=yes
Restart=on-failure
RestartSec=10s
Type=notify
TimeoutStartSec=infinity
TimeoutStopSec=infinity
UMask=0077
User=rocketmq
Group=rocketmq
WorkingDirectory=/opt/rocketmq

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start rocketmq.service
systemctl enable rocketmq.service
```

##### Verify
```bash
# set nameserver address
export NAMESRV_ADDR=localhost:9876

# produce 
./bin/tools.sh org.apache.rocketmq.example.quickstart.Producer
# consume
./bin/tools.sh org.apache.rocketmq.example.quickstart.Consumer
```

##### Troubleshooting
```bash
# problem 1
# 
```


#### Deploy By Container
##### Run On Docker
```bash
# pull image
docker pull apache/rocketmq:5.1.4

# start nameserver
docker run -it --net=host apache/rocketmq ./mqnamesrv

# start broker
docker run -it --net=host --mount source=/tmp/store,target=/home/rocketmq/store apache/rocketmq ./mqbroker -n localhost:9876
```

##### Run On Helm
```bash
# rocketmq operator
# https://artifacthub.io/packages/olm/community-operators/rocketmq-operator
```



>Reference:
> 1. [Official Document](https://rocketmq.apache.org/)
> 2. [RocketMQ Github](https://github.com/apache/rocketmq)