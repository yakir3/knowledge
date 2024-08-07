#### Introduction
...


#### Deploy By Binaries
##### Quick Start
```bash
# option1: compile source install
cd /usr/local/src/
wget https://dist.apache.org/repos/dist/release/rocketmq/5.3.0/rocketmq-all-5.3.0-source-release.zip
unzip rocketmq-all-5.3.0-source-release.zip && rm -f rocketmq-all-5.3.0-source-release.zip
cd rocketmq-all-5.3.0-source-release
mvn -Prelease-all -DskipTests -Dspotbugs.skip=true clean install -U
cp -aR distribution/target/rocketmq-5.3.0/rocketmq-5.3.0 /opt/rocketmq-5.3.0

# options2: download bin install
cd /usr/local/src/
wget https://dist.apache.org/repos/dist/release/rocketmq/5.3.0/rocketmq-all-5.3.0-bin-release.zip
unzip rocketmq-all-5.3.0-bin-release.zip && rm -f rocketmq-all-5.3.0-bin-release.zip
cp -aR rocketmq-all-5.3.0-bin-release /opt/rocketmq-5.3.0

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
# option2: synchronization 2m-2s-sync
./bin/mqnamesrv
./bin/mqbroker -n localhost:9876 -c $ROCKETMQ_HOME/conf/2m-2s-sync/broker-a.properties --enable-proxy
./bin/mqbroker -n localhost:9876 -c $ROCKETMQ_HOME/conf/2m-2s-sync/broker-a-s.properties --enable-proxy
./bin/mqbroker -n localhost:9876 -c $ROCKETMQ_HOME/conf/2m-2s-sync/broker-b.properties --enable-proxy
./bin/mqbroker -n localhost:9876 -c $ROCKETMQ_HOME/conf/2m-2s-sync/broker-b-s.properties --enable-proxy
# option3: asynchronous 2m-2s-async
...

# cluster mode
# option1: synchronization 2m-2s-sync
./bin/mqnamesrv
./bin/mqbroker -n 192.168.1.1:9876;192.161.2:9876 -c $ROCKETMQ_HOME/conf/2m-2s-sync/broker-a.properties
./bin/mqbroker -n 192.168.1.1:9876;192.161.2:9876 -c $ROCKETMQ_HOME/conf/2m-2s-sync/broker-a-s.properties
./bin/mqbroker -n 192.168.1.1:9876;192.161.2:9876 -c $ROCKETMQ_HOME/conf/2m-2s-sync/broker-b.properties
./bin/mqbroker -n 192.168.1.1:9876;192.161.2:9876 -c $ROCKETMQ_HOME/conf/2m-2s-sync/broker-b-s.properties
./bin/mqproxy -n 192.168.1.1:9876;192.161.2:9876 -pc $ROCKETMQ_HOME/conf/2m-2s-sync/proxyConfig.json
# option2: asynchronous 2m-2s-async
...

# failover mode
...

# shutdown
./bin/mqshutdown broker
./bin/mqshutdown namesrv
```

##### Config and Boot
###### Config
**Local Mode**
```bash
# namesrv config
cat > /opt/rocketmq/conf/2m-2s-sync/nameserver.conf << "EOF"
namesrvAddr=10.0.0.x
EOF

# master config
cat > /opt/rocketmq/conf/2m-2s-sync/broker-a.properties << "EOF"
brokerClusterName=DefaultCluster
brokerName=broker-a
brokerId=0
namesrvAddr=10.0.0.1:9876;10.0.0.2:9876
bindAddress=10.0.0.1
listenPort=6888
storePathRootDir=/opt/rocketmq/store
deleteWhen=04
diskMaxUsedSpaceRatio=85
fileReservedTime=48
brokerRole=SYNC_MASTER
flushDiskType=ASYNC_FLUSH
EOF
cat > /opt/rocketmq/conf/2m-2s-sync/broker-b.properties << "EOF"
brokerClusterName=DefaultCluster
brokerName=broker-b
brokerId=0
namesrvAddr=10.0.0.1:9876;10.0.0.2:9876
bindAddress=10.0.0.1
listenPort=6888
storePathRootDir=/opt/rocketmq/store
deleteWhen=04
diskMaxUsedSpaceRatio=85
fileReservedTime=48
brokerRole=SYNC_MASTER
flushDiskType=ASYNC_FLUSH
EOF

# slave config
cat > /opt/rocketmq/conf/2m-2s-sync/broker-a-s.properties << "EOF"
brokerClusterName=DefaultCluster
brokerName=broker-a
brokerId=1
namesrvAddr=10.0.0.1:9876;10.0.0.2:9876
bindAddress=10.0.0.1
listenPort=7888
storePathRootDir=/opt/rocketmq/store-s
deleteWhen=04
diskMaxUsedSpaceRatio=85
fileReservedTime=48
brokerRole=SLAVE
flushDiskType=ASYNC_FLUSH
EOF
cat > /opt/rocketmq/conf/2m-2s-sync/broker-b-s.properties << "EOF"
brokerClusterName=DefaultCluster
brokerName=broker-b
brokerId=1
namesrvAddr=10.0.0.1:9876;10.0.0.2:9876
bindAddress=10.0.0.1
listenPort=7888
storePathRootDir=/opt/rocketmq/store-s
deleteWhen=04
diskMaxUsedSpaceRatio=85
fileReservedTime=48
brokerRole=SLAVE
flushDiskType=ASYNC_FLUSH
EOF
```

**Failover Mode**
```bash
# namesrv and controller config

# broker config
```

###### Boot(systemd)
**Local Mode**
```bash
# namesrv
cat > /etc/systemd/system/rocketmq-namesrv.service << "EOF"
[Unit]
Description=Rocketmq
Documentation=https://rocketmq.apache.org/docs/
Wants=network-online.target
After=network-online.target

[Service]
#ExecStartPre=/opt/rocketmq/bin/runserver.sh
ExecStart=/opt/rocketmq/bin/mqnamesrv
LimitNOFILE=655350
LimitNPROC=65535
NoNewPrivileges=yes
#PrivateTmp=yes
Restart=on-failure
RestartSec=10s
SuccessExitStatus=143
Type=simple
TimeoutStartSec=60
TimeoutStopSec=30
UMask=0077
User=rocketmq
Group=rocketmq
WorkingDirectory=/opt/rocketmq

[Install]
WantedBy=multi-user.target
EOF


# master
cat > /etc/systemd/system/rocketmq-master.service << "EOF"
[Unit]
Description=Rocketmq
Documentation=https://rocketmq.apache.org/docs/
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/opt/rocketmq/bin/mqbroker -c /opt/rocketmq/conf/2m-2s-sync/broker-m.properties
LimitNOFILE=655350
LimitNPROC=65535
NoNewPrivileges=yes
#PrivateTmp=yes
Restart=on-failure
RestartSec=10s
Type=simple
TimeoutStartSec=60
TimeoutStopSec=30
UMask=0077
User=rocketmq
Group=rocketmq
WorkingDirectory=/opt/rocketmq

[Install]
WantedBy=multi-user.target
EOF

# slave
cat > /etc/systemd/system/rocketmq-slave.service << "EOF"
[Unit]
Description=Rocketmq
Documentation=https://rocketmq.apache.org/docs/
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/opt/rocketmq/bin/mqbroker -c /opt/rocketmq/conf/2m-2s-sync/broker-s.properties
LimitNOFILE=655350
LimitNPROC=65535
NoNewPrivileges=yes
#PrivateTmp=yes
Restart=on-failure
RestartSec=10s
Type=simple
TimeoutStartSec=60
TimeoutStopSec=30
UMask=0077
User=rocketmq
Group=rocketmq
WorkingDirectory=/opt/rocketmq

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemctl start rocketmq-namesrv.service
systemctl start rocketmq-master.service
systemctl start rocketmq-slave.service
systemctl enable rocketmq-master.service
systemctl enable rocketmq-slave.service
systemctl enable rocketmq-namesrv.service
```

**Failover Mode**
```bash
#
```

##### Verify
```bash
# set nameserver address
export NAMESRV_ADDR=localhost:9876

# produce 
./tools.sh org.apache.rocketmq.example.quickstart.Producer ; sleep 3
# consume
./tools.sh org.apache.rocketmq.example.quickstart.Consumer
```

##### Troubleshooting
```bash
# problem 1
# 
```


#### Deploy By Container
##### Run in Docker
```bash
# pull image
docker pull apache/rocketmq:5.3.0

# start nameserver
docker run -it --net=host apache/rocketmq ./mqnamesrv

# start broker
docker run -it --net=host --mount source=/tmp/store,target=/home/rocketmq/store apache/rocketmq ./mqbroker -n localhost:9876
```

##### Run in Kubernetes
```bash
# rocketmq operator
# https://artifacthub.io/packages/olm/community-operators/rocketmq-operator
```



>Reference:
> 1. [Repository](https://rocketmq.apache.org/)
> 2. [RocketMQ Github](https://github.com/apache/rocketmq)