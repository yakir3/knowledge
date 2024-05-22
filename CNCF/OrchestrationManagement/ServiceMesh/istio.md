### 二进制部署
```shell
# 1.download and decompression
https://www.elastic.co/downloads/logstash

# 2.configure
touch config/logstash.conf
vim config/logstash.conf

# 3.run
bin/logstash -f logstash.conf
```
[[sc-logstash|logstash常用配置]]

### helm 部署
```shell
# add and update repo
helm repo add elastic https://helm.elastic.co
helm update

# get charts package
helm pull elastic/logstash --untar
cd logstash

# configure and run
vim values.yaml
logstashPipeline:
  logstash.conf: |
    input {
      exec {
        command => "uptime"
        interval => 30
      }
    }
    output { stdout { } }

helm -n logging install logstash .

```

> Reference:
> 1、官方 github 地址 = https://github.com/elastic/logstash
> 2、官方 helm 安装指引 = https://github.com/elastic/helm-charts/blob/main/logstash/README.md