#### Deploy by Binaries
##### Download
```bash
# 1.download and decompression
# https://www.elastic.co/downloads/elasticsearch
cd /opt
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.7.1-linux-x86_64.tar.gz
tar -xf elasticsearch-8.7.1-linux-x86_64.tar.gz && rm -rf elasticsearch-8.7.1-linux-x86_64.tar.gz
cd elasticsearch-8.7.1
```

##### Config and Boot
[[sc-elasticsearch|Elasticsearch Config]]
```bash
# 2.configure
vim config/elasticsearch.yml

# 3.run 
./bin/elasticsearch
# daemon run
./bin/elasticsearch -d 

# 4.options: install plugin
./bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v8.5.1/elasticsearch-analysis-ik-8.5.1.zip
# plugins dir = plugins and config

# 5.set password and verify
./bin/elasticsearch-setup-passwords interactive
curl 127.0.0.1:9200 -u 'elastic:es123123'

# 6.boot
cat > /usr/lib/systemd/system/elasticsearch.service << "EOF"
[Unit]
Description=Elasticsearch
Documentation=https://www.elastic.co
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
RuntimeDirectory=elasticsearch
PrivateTmp=true
Environment=ES_HOME=/opt/elasticsearch
Environment=ES_PATH_CONF=/opt/elasticsearch/config
Environment=PID_DIR=/opt/elasticsearch/logs
Environment=ES_SD_NOTIFY=true
EnvironmentFile=-/etc/default/elasticsearch
WorkingDirectory=/opt/elasticsearch
User=elasticsearch
Group=elasticsearch
ExecStart=/opt/elasticsearch/bin/systemd-entrypoint -p ${PID_DIR}/elasticsearch.pid --quiet
StandardOutput=journal
StandardError=inherit
LimitNOFILE=65535
LimitNPROC=4096
LimitAS=infinity
LimitFSIZE=infinity
TimeoutStopSec=0
KillSignal=SIGTERM
KillMode=process
SendSIGKILL=no
SuccessExitStatus=143
TimeoutStartSec=60
Restart=always
RestartSec=3s

[Install]
WantedBy=multi-user.target
EOF

cat > /opt/elasticsearch/bin/systemd-entrypoint << "EOF"
#!/bin/sh
if [ -n "$ES_KEYSTORE_PASSPHRASE_FILE" ] ; then
  exec /opt/elasticsearch/bin/elasticsearch "$@" < "$ES_KEYSTORE_PASSPHRASE_FILE"
else
  exec /opt/elasticsearch/bin/elasticsearch "$@"
fi
EOF

chmod +x /opt/elasticsearch/bin/systemd-entrypoint 
chown elasticsearch:elasticsearch /opt/elasticsearch -R

systemctl daemon-reload
systemctl start elasticsearch.service
systemctl enable elasticsearch.service
```

>Elascticsearch 可视化工具 cerebro，[官方地址](https://github.com/lmenezes/cerebro)


#### Deploy by Container
##### Run by Helm
```bash
# add and update repo
helm repo add elastic https://helm.elastic.co
helm update

# get charts package
helm pull elastic/elasticsearch --untar
cd elasticsearch

# create storageclass
# nfs-server or others
[[nfs-server]]

# configure and run
vim values.yaml
esConfig: {}
volumeClaimTemplate:
  storageClassName: "elk-nfs-client"
...

helm -n logging install elasticsearch .

```


#### Deploy by ECK Operator
详见Reference:


>Reference:
> 1. [官方 github 文档](https://github.com/elastic/elasticsearch)
> 2. [官方 k8s 集群部署文档](https://www.elastic.co/downloads/elastic-cloud-kubernetes)
> 3. [Ubuntu Install](https://www.elastic.co/guide/en/elasticsearch/reference/8.7/deb.html)