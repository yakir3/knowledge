#### Introduction
...

#### Deploy By Binaries
```bash
# 1.download and decompression
https://www.elastic.co/downloads/logstash

# 2.configure
touch config/logstash.conf
vim config/logstash.conf

# 3.run
bin/logstash -f logstash.conf
```

[[sc-logstash|Logstash Config]]

#### Deploy By Container
##### Run On Helm
```bash
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



>Reference:
>1. [Repository](https://istio.io/)
>2. [Repository](https://github.com/istio/istio)