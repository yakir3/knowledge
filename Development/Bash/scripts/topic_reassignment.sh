#!/bin/bash
bootstrap_server_host=127.0.0.1:9092
base_dir=/opt/kafka
topics=`$base_dir/bin/kafka-topics.sh --bootstrap-server $bootstrap_server_host --list`

for i in $topics;do
  replicsNum=`$base_dir/bin/kafka-topics.sh --bootstrap-server $bootstrap_server_host --describe --topic $i|grep ReplicationFactor|awk -F'[ :\t]+' '{print $8}'`
  if [ $replicsNum == 1 ];then
    echo $i >> ./topic.txt
  fi
done

IFS=$'\n'
echo '{"version":1,"partitions":[' > topic-reassignment.json
for i in $topics;do
  leaders=`$base_dir/bin/kafka-topics.sh --bootstrap-server $bootstrap_server_host --describe --topic $i|grep Leader`
  for leader in $leaders;do
    partition=`echo $leader |awk '{print $4}'`
    leader=`echo $leader |awk '{print $6}'`
    # 用 shuf 保证 副分片 和 主分片 不在同一个 Broker 且随机分配在剩余的节点中
    follwer=`grep -vxF $leader ./leaders.txt | shuf -n1`
    echo '{"topic":"'$i'","partition":'$partition',"replicas":['$leader','$follwer']},' >> ./topic-reassignment.json
  done
done
echo ']}' >> topic-reassignment.json
