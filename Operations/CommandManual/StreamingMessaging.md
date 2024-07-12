##### Kafka
```bash
# config
# 动态查看&更新节点配置（官方配置支持 cluster-wide 类型配置才可以更新）
./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type brokers --entity-name 1 --describe
./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type brokers --entity-name 1 --alter --add-config log.cleaner.threads=2
# 使用 --entity-default 参数为调整整个集群的动态配置


# topic
# adding topics by special partition and replication 
./kafka-topics.sh --bootstrap-server localhost:9092 --create --topic myTopic --replication-factor 1 --partitions 1 [--config x=y]
# modifying a topic partition with manual
./kafka-topics.sh --bootstrap-server localhost:9092 --alter --topic myTopic --partitions 3
# select topic
./kafka-topics.sh --bootstrap-server localhost:9092 --descibe --topic myTopic
./kafka-topics.sh --bootstrap-server localhost:9092 --list


# production messages
./kafka-console-producer.sh --bootstrap-server localhost:9092 --topic myTopic
first event
second event


# consumer messages
./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic myTopic
./kafka-console-consumer.sh --bootstrap-server localhost:9092 --group myGroup
./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic myTopic --from-beginning


# consumer groups
./kafka-consumer-groups.sh --bootstrap-server localhost:9092 --descibe --group myGroup [--members] [--verbose]
./kafka-consumer-groups.sh --bootstrap-server localhost:9092 --list


# metadata quorum tool
./kafka-metadata-quorum.sh --bootstrap-server localhost:9092 describe --status
```

##### RocketMQ
```bash
# help
./mqadmin -h
./mqadmin {command} {args}
# args
-b brokerIp:port
-c clusterName
-h
-n nameserver:9876
-t topicName



# topic
./mqadmin updateTopic 
./mqadmin deleteTopic
./mqadmin topicList -n rocketmq-nameserver:9876
./mqadmin topicStatus
./mqadmin topicClusterList -t topicName -n rocketmq-nameserver:9876


# cluster
./mqadmin clusterList


# message
./mqadmin queryMsgById -i msgId -n rocketmq-nameserver:9876
./mqadmin queryMsgByKey -k msgKey -n rocketmq-nameserver:9876
./mqadmin queryMsgByOffset -t topicName -b brokerName -i queueId -o offsetValue -n rocketmq-nameserver:9876
./mqadmin sendMessage -t topicName -b brokerName -p yakirTest -n rocketmq-nameserver:9876
./mqadmin consumeMessage -t topicName -b brokerName -o offset -i queueId -g consumerGroup


# consumer
./mqadmin consumerStatus

```
