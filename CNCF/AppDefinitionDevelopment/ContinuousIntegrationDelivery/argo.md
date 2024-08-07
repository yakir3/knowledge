### Argo CD
#### Introduction
...


#### Deploy By Container
##### Run by Resource
```bash
# version
ARGO_CD_VERSION=v2.7.9
kubectl create namespace argocd
# non-ha install
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/${ARGO_CD_VERSION}/manifests/install.yaml
# ha install
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/${ARGO_CD_VERSION}/manifests/ha/install.yaml

```

##### Run in Kubernetes
```bash
# add and update repo
helm repo add argo https://argoproj.github.io/argo-helm
helm update

# get charts package
helm fetch argo/argo-cd --untar
cd argo-cd

# configure and run
vim values.yaml
...
helm -n cicd install argocd .
```


#### Started
##### postinstallation
```bash
# install argocd cli latest version
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm -f argocd-linux-amd64

# access argocd server
kubectl -n argocd port-forward svc/argocd-server --address=0.0.0.0 8080:443
# kubectl -n argocd apply -f argocd-ingress.yaml

# get username and password
username=admin
password=`kubectl -n argocd get secrets argocd-initial-admin-secret -ojsonpath='{.data.password}' |base64 -d`

```

##### application
```bash
# login by argocd cli
argocd login <ARGOCD_SERVER>

# create example app
argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default

argocd app list # kubectl -n argocd get applications

# sync or deploy application
argocd app sync guestbook
argocd app get guestbook


```


### Argo Workflows
#### Introduction
...


#### Deploy By Container
##### Run by Resource
```bash
# version
ARGO_WORKFLOWS_VERSION=v3.4.9
# install
kubectl create namespace argo
kubectl apply -n argo -f https://github.com/argoproj/argo-workflows/releases/download/${ARGO_WORKFLOWS_VERSION}/install.yaml

# switch authentication mode to server
kubectl patch deployment \
  argo-server \
  --namespace argo \
  --type='json' \
  -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/args", "value": [
  "server",
  "--auth-mode=server"
]}]'
```


##### Run in Kubernetes
```bash
# add and update repo
helm repo add argo https://argoproj.github.io/argo-helm
helm update

# get charts package
helm fetch argo/argo-workflows --untar
cd argo-workflows

# configure and run
vim values.yaml
...
helm -n cicd install argo-workflows .

```

#### Started
##### postinstallation
```bash
# install  cli latest version
ARGO_WORKFLOWS_VERSION=v3.4.9
curl -sLO https://github.com/argoproj/argo-workflows/releases/download/${ARGO_WORKFLOWS_VERSION}/argo-linux-amd64.gz
gunzip argo-linux-amd64.gz 
install -m 755 argo-linux-amd64 /usr/local/bin/argo && rm -f argo-linux-amd64

# access argo-server 
kubectl -n argo port-forward deployment/argo-server --address=0.0.0.0  2746:2746
# kubectl -n argo apply -f argo-ingress.yaml

```

##### application
```bash
# example 
argo -n argo submit -w https://raw.githubusercontent.com/argoproj/argo-workflows/master/examples/hello-world.yaml
argo -n argo list
argo -n argo get @latest

# Steps | DAG | Artifacts etc..


```


> Reference:
> 1. [Official Website](https://argoproj.github.io/)
> 2. [Argo Workflows](https://argoproj.github.io/workflows/)
> 3. [Argo CD](https://github.com/argoproj/argo-cd/)
