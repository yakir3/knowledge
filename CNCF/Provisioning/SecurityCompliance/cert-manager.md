#### Introduction
...



#### Deployment
##### Deploy On Kubernetes
**deploy by kubenertes manifest**
```shell
# install operator
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.yaml

```

**deploy by helm**
[[cc-helm|helm常用命令]]
```shell
# install crds resources
# if installCRDS is true, don't need to apply
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.1/cert-manager.crds.yaml

# add and update repo
helm repo add jetstack https://charts.jetstack.io
helm update

# get charts package
helm pull jetstack/cert-manager --untar  
cd cert-manager

# configure and run
vim values.yaml
installCRDs: true

helm -n cert-manager install cert-manager .
```


> Reference:
> 1. [官方 github 地址](https://github.com/cert-manager/cert-manager)
> 2. [官方文档](https://cert-manager.io/docs/)
