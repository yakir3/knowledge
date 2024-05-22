#### Introduction
...


#### Deployment
#### Run On WARFile
```shell
# download and decompression
# https://www.jenkins.io/download/
wget https://get.jenkins.io/war-stable/2.401.1/jenkins.war

# run and init password
mkdir /opt/jenkins-config
JENKINS_HOME=/opt/jenkins-config java -jar jenkins.war
cat /opt/jenkins-config/secrets/initialAdminPassword
```

##### Run On Ubuntu
```shell
# https://www.jenkins.io/doc/book/installing/linux/#debianubuntu
```

##### Run On Docker
[[cc-docker|Docker常用命令]]
```shell
# create bridge network
docker network create jenkins

# run 
docker run -d -v jenkins_home:/var/jenkins_home -p 8080:8080 -p 50000:50000 --restart=on-failure jenkins/jenkins:lts-jdk11 --name jenkins
# persistence storage info and init password
docker inspect jenkins_home
...
cat /var/lib/docker/volumes/jenkins_home/_data/secrets/initialAdminPassword 

```


##### Run On Kubernetes
[[cc-k8s|deploy by kubernetes manifest]]
```shell
# manifest resource yaml
namespace
serviceAccout
persistence volume
Deployment
Service

# more detail
https://www.jenkins.io/doc/book/installing/kubernetes/
```

[[cc-helm|deploy by helm]]
```shell
# Add and update repo
helm repo add jenkinsci https://charts.jenkins.io
helm repo update

# Get charts package
helm fetch jenkinsci/jenkins --untar  
cd jenkins

# Configure and run
vim values.yaml
  ingress:
    enabled: true

helm -n cicd install jenkins . --create-namespace

```

[deploy by jenkins-operator](https://jenkinsci.github.io/kubernetes-operator/docs/getting-started/latest/)

access and use
```shell
# patch harbor ingress resource
kubectl -n cicd patch ingress jenkins --patch '{"spec":{"ingressClassName": "nginx"}}'

# get password
kubectl -n cicd get secrets jenkins -ojsonpath='{.data.jenkins-admin-password}' |base64 -d 

# access by https
https://jenkins.yakir.com
admin
mxP4KKfGtn6hJ8IF2zMMLt
```



> Reference:
> 1. [官方文档](https://www.jenkins.io/doc/book/installing/)
> 2. [官方 github 地址](https://github.com/jenkinsci/jenkins)
