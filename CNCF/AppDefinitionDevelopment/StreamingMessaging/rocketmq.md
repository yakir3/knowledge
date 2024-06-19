#### Introduction
...


#### Deploy by Binaries
##### Download and Compile
```bash
# download source
wget https://dist.apache.org/repos/dist/release/rocketmq/5.1.4/rocketmq-all-5.1.4-source-release.zip
unzip rocketmq-all-5.1.4-source-release.zip
cd rocketmq-all-5.1.4-source-release

# compile 
mvn -Prelease-all -DskipTests -Dspotbugs.skip=true clean install -U
cp -aR distribution/target/rocketmq-5.1.4/rocketmq-5.1.4 /opt/rocketmq-5.1.4

# postinstallation
export ROCKETMQ_HOME=/opt/rocketmq-5.1.4/
# export JAVA_HOME=
export PATH=$PATH:/opt/rocketmq-5.1.4/bin

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
##### [[sc-kafka|RocketMQ Config]]

```bash
# config 
#

# boot 
cat > /etc/systemd/system/rocketmq.service << "EOF"
...
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


#### Deploy by Container
##### Run by Docker
```bash
# pull image
docker pull apache/rocketmq:5.1.4

# start nameserver
docker run -it --net=host apache/rocketmq ./mqnamesrv

# start broker
docker run -it --net=host --mount source=/tmp/store,target=/home/rocketmq/store apache/rocketmq ./mqbroker -n localhost:9876


```

##### Run by Helm Operator
```bash
# rocketmq operator
# https://artifacthub.io/packages/olm/community-operators/rocketmq-operator

```


>Reference:
> 1. [Official Document](https://rocketmq.apache.org/)
> 2. [RocketMQ Github](https://github.com/apache/rocketmq)