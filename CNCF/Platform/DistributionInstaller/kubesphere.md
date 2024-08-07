#### Introduction
...


#### Deployment
##### Run On Binaries
```bash
# download source

```

##### Run in Docker
[[cc-docker|Docker常用命令]]
```bash
# run by docker or docker-compose
# https://hub.docker.com/_/zookeeper
```

##### Run On Kubernetes
[[cc-k8s|deploy by kubernetes manifest]]
```bash
# 
```

[[cc-helm|deploy by helm]]
```bash
# Add and update repo
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Get charts package
helm fetch bitnami/zookeeper --untar 
cd zookeeper

# Configure and run
vim values.yaml
global:
  storageClass: "nfs-client"
replicaCount: 3

helm -n middleware install zookeeper . --create-namespace 

# verify
kubectl -n middleware exec -it zookeeper-0 -- zkServer.sh status  
```



> Reference:
> 1. [Official Website](https://www.kubesphere.io/zh/)
> 2. [Repository](https://github.com/kubesphere/kubesphere)
