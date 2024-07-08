##### Kafka
```bash
# 动态查看&更新节点配置（官方配置支持 cluster-wide 类型配置才可以更新）
./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type brokers --entity-name 1 --describe
./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type brokers --entity-name 1 --alter --add-config log.cleaner.threads=2
# 使用 --entity-default 参数为调整整个集群的动态配置


# Topic
# show topic list
./kafka-topics.sh --bootstrap-server localhost:9092 --list
# 查看详情参数
./kafka-topics.sh --bootstrap-server kafka-headless:9092 --list--topic test --descibe

# 查看 consumer 消费情况
./kafka-consumer-groups.sh --bootstrap-server yakir-kafka-headless:9092 --list
#详情
--group test --descibe

# 查看消费者组


# 生产者
./kafka-console-producer.sh --bootstrap-server yakir-kafka-headless:9092 --topic yakirtopic


# 消费者
./kafka-console-consumer.sh --bootstrap-server yakir-kafka-headless:9092 --topic yakirtopic

./kafka-console-consumer.sh --bootstrap-server yakir-kafka-headless:9092 --topic yakirtopic --from-beginning

# 调整 topic 分区数
./kafka-topics.sh --bootstrap-server yakir-kafka-headless:9092 --alter --topic yakirtopic --partitions 3
# 通过 json 文件方式打散 leader 分区以及调整 topic 副本数
echo -e '{\n    "version": 1,' > yakirtopic.json
echo '    "partitions": [' >> yakirtopic.json
for i in {1..3};do 
var=$(printf "1\n2\n3" |shuf |tr '\n' ',')
var=${var::-1}
echo -e '        {"topic": "yakirtopic", "partition": '${i}', "replicas": ['${var}']},' >> yakirtopic.json
done
echo -e '    ]\n}' >> yakirtopic.json
./kafka-reassign-partitions.sh --bootstrap-server 172.23.1.3:9092 --reassignment-json-file yakirtopic.json --execute
# 验证调整结果
./kafka-reassign-partitions.sh --bootstrap-server yakir-kafka-headless:9092 --reassignment-json-file yakirtopic.json --verify

# 指定分区 副本数创建 topic
./kafka-topics.sh --bootstrap-server yakir-kafka-headless:9092 --create --replication-factor 1 --partitions 1 --topic yakir-test-topic

# 停止应用
./kafka-server-stop.sh
# 启动应用
./kafka-server-start.sh -daemon ../config/server.properties

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
