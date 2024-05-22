#### Introduction
...


#### Deployment
##### Run On Binaries
```shell
# get and run from source
wget https://github.com/coredns/coredns/releases/download/v1.10.1/coredns_1.10.1_linux_amd64.tgz
tar xf coredns_1.10.1_linux_amd64.tgz
install -m 0755 coredns /usr/local/bin
coredns -conf /opt/coredns/coredns.conf 
# OR
git clone https://github.com/coredns/coredns
cd coredns && make
install -m 0755 coredns /usr/local/bin
coredns -conf /opt/coredns/coredns.conf -dns.port=1053

# create config
cat > /opt/coredns/coredns.conf << "EOF"
example.org:1053 {
    file /var/lib/coredns/example.org.signed
    transfer {
        to * 2001:500:8f::53
    }
    errors
    log
}

. {
    any
    forward . 8.8.8.8:53
    errors
    log
}
EOF

# systemd start 
cat > /etc/systemd/system/coredns.service << "EOF"
...
EOF
systemctl daemon-reload
systemctl start coredns.service
systemctl enable coredns.service
```

##### Run On Docker
[[cc-docker|Docker常用命令]]
```shell
# https://hub.docker.com/r/coredns/coredns/tags
```

##### Run On Kubernetes
[[cc-k8s|deploy by kubernetes manifest]]
```shell
#
```

[[cc-helm|deploy by helm]]
```shell
# Add and update repo
helm repo add coredns https://coredns.github.io/helm
helm repo update

# Get charts package
helm fetch coredns/coredns --untar
cd coredns

# Configure and run
vim values.yaml
...

helm -n kube-system install coredns .
```


> Reference:
> 1. [官方文档](https://coredns.io/)
> 2. [官方 github 地址](https://github.com/coredns/coredns)

