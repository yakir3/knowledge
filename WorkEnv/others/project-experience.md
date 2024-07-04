### 2021.06~2022.07
##### AliyunCloud
计算与容器
+ ECS
+ ACK
+ ACR

存储
+ OSS
+ NAS
+ SLS

网络与 CDN
+ SLB
+ 专有网络 VPC
+ 云企业网 CEN
+ CDN
+ VPN 网关

安全
+ 云安全中心
+ 访问控制 RAM

中间件
+ 微服务引擎 MSE
+ 企业级分布式应用服务 Edas
+ 云消息队列 RabbitMQ

数据库
+ PolarDB Mysql
+ RDS Mysql
+ 云数据库 Redis
+ 数据传输服务 DTS

大数据计算
+ 检索分析服务 Elasticsearch

媒体服务
+ 直播 点播

开发工具
+ OpenAPI Explorer
+ 云效 DevOps: CICD
+ API 网关
+ 内部使用 Aone: CICD


### 2022.07~2023
#### Platform
##### AWS
+ CloudFront
+ Route 53
+ SES
+ SNS
+ MetaAPI

##### CloudFlare
+ CDN

##### GoogleCloud
+ CloudStorage
+ VPCnetwork
+ ComputerEngine
+ Logging
+ Filestore(NFS)
+ ArtifactRegistry
+ KubernetesEngine
INIT
1.gke create
2.manager machine vm init
3.gcloud iam roles create: artifact、ops-api
4.cloud loadbalancer: nat
5.cli: kubectl、helm、google-cloud-cli
cat >> ~/.bashrc << "EOF"
source <(kubectl completion bash)
source <(helm completion bash)
EOF
apt install google-cloud-cli 
apt install google-cloud-cli-gke-gcloud-auth-plugin
6.gloud auth login and import gke kubeconfig to local
gcloud auth login --cred-file=xxx.json
gcloud container clusters get-credentials my-gke --region asia-east2 --project my-gke
7.import rancher(rancher ingress whitelist)
8.gke ingress create(internel loadbalancer)
9.storage and others components
nfs-subdir-external-provisioner
redis, kafka
prometheus, grafana


#### CICD
##### devops_tools
对接 CI 制品，生成 Jira CD 流程工单
自动升级 SQL 工单与代码，根据 Jira webhook 转换流程

##### Jira
升级流程工单，CD 部分

##### Archery
Postgres、Mysql SQL 工单生成以及自动执行

##### Jenkins
脚本工具：定时查询供应商余额通知
第三方项目 CICD 任务

##### Gitlab

##### Jenkins

##### Rancher

#### Knowledge Base
##### [[ContainerRuntime#Quick test container|Mrdoc]]

##### Confluence


#### Monitoring
##### Prometheus
node-exporter
redis-exporter
kafka-exporter
rocketmq-exporter

##### Grafana
alert notice

##### Skywalking
skywalking-agent
alert notice to feishu

#### Logging

##### Fluentd
[[sc-fluentd|flent-bit to tcp forward for persistent storage ]]
upload persistent storage to CloudStorage

##### Fluent-bit
collect GKE cluster logs to Elasticsearch

##### Elasticsearch
index template
index policy

##### Logstash
collect VM machine logs to persistent storage
upload persistent storage to CloudStorage

#### Middleware
##### Server
Apollo
Nacos
Kafka
Redis
RocketMQ
NFS Server

##### Management
Kafka-ui
redis-insight
rocketMQ-dashboard
nfs-common
cerebro

#### Security
安全漏洞平台关注：AWS、绿盟、华为云、阿里云、腾讯云、Ubuntu、Redhat

Java jar fix 

Docker basic images 

Middleware GitHub 漏洞安全补丁关注



#### Kubernetes 优化
##### JVM
```bash
JAVA_OPTS="-Dfile.encoding=utf-8 \
-Dcatalina.base=${PWD}
-Dlog.file.path=/app/logs
"

java $JAVA_OPTS -XX:InitialRAMPercentage=50.0 \
-XX:MinRAMPercentage=50.0 \
-XX:MaxRAMPercentage=75.0 \
-Xlog:gc:/app/logs/gc.log:time,level,tags \
-XX:+HeapDumpOnOutOfMemoryError \
-XX:HeapDumpPath=/app/logs/heapdump.hprof \
-jar app.jar
--server.port=${SERVER_PORT-8080}
```

##### Ingress
ingress proxy_read_timeout

##### Resource
request
limit
HPA

namespace limitrange?

##### Permission
RBAC

##### Image
debug image 调试 Pod：缩减基础镜像


nfs-subdir-external-provisioner
使用 GitOps 等 CICD 应用改造现有发布流程




### 2024
#### CICD
##### Nexus
npm: hosted-repo, proxy-repo, group-repo
maven

##### jiracdflow
xxx

##### ansible
system init
deploy middleware

#### Platform
##### Alibaba Cloud
+ CDN

##### Huawei Cloud
+ CDN
+ Live


>1. [乌云知识库](https://github.com/SuperKieran/WooyunDrops)
>2. [mindoc](https://github.com/mindoc-org/mindoc)
