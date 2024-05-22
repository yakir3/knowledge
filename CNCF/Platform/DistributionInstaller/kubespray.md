#### Introduction
...


#### Deployment
##### Run On Binaries
```shell
# download source

```

##### Run On Docker
[[cc-docker|Docker常用命令]]
```shell
# run by docker or docker-compose
# https://hub.docker.com/_/zookeeper
```

##### Run On Kubernetes
[[cc-k8s|deploy by kubernetes manifest]]
```shell
# 
```

[[cc-helm|deploy by helm]]
```shell
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
> 1. [官方文档](https://kubespray.io/#/)
> 2. [官方 github 地址](https://github.com/kubernetes-sigs/kubespray)
