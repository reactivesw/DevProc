# CD to k8s on gke by travis

## 1. 说明

使用travis自动部署项目到k8s上，实际上是使用`gcloud`登陆`gke`，并且连接上`k8s cluster`并且使用`kubectl`部署相关项目，而自动部署就是把这些工作转变为travis的脚步顺序执行。
整个部署过程包括如下命令:

```shell

# 安装配置gcloud
if [ ! -d "$HOME/google-cloud-sdk/bin" ]; then rm -rf $HOME/google-cloud-sdk; export CLOUDSDK_CORE_DISABLE_PROMPTS=1; curl https://sdk.cloud.google.com | bash; fi
source /home/travis/google-cloud-sdk/path.bash.inc

# 安装kubectl
gcloud --quiet components update kubectl

# 配置gcloud
gcloud config set container/use_client_certificate True

# 登陆gke
gcloud auth activate-service-account --key-file=${gke service account key file}

# 连接k8s cluster(在deploy脚步模版中，我把这个过程拆成了几步)
gcloud container clusters get-credentials ${CLUSTER_NAME} --zone ${CLUSTER_COMPUTE_ZONE} --project ${PROJECT_NAME}

# 使用kubectl命令执行相关操作
kubectl get pods
kubectl apply -f .yaml

```

## 2. 前置准备

1. 在travis上添加github项目
2. gke service accout key file(参考[gke setup step 3](https://github.com/reactivesw/development_process/blob/master/devops/gke%20setup.md#3-service-accout))
3. docker hub accout（或者其他repo，这里使用的是docker hub）

## 3. 配置travis

### 3.1 encode key file

```shell
base64 ${gke service accout key file}
```

### 3.2 set gke and k8s variables

要登陆gke，需要使用`gke service account key file`，连接`kubectl`需要`kubectl cluster`的信息，所以在travis的setting中配置这些信息

More options -> settings -> Environment Variables

 添加以下配置
* PROJECT_NAME : gke 上的 project 的 id
* CLUSTER_COMPUTE_ZONE : k8s cluster 的zone
* CLUSTER_NAME : k8s cluster 的 名字
* GCLOUD_SERVICE_KEY : step 3.1 生成的加密信息

## 4. 编写travis部署脚本

### 4.1 `.travis.yaml`模版

```yaml
# build工程需要使用的
sudo: required
language: java
jdk: oraclejdk8

# gcloud 需要
cache:
  directories:
    - "$HOME/google-cloud-sdk/"

# 引入docker，在build结束后push镜像到docker hub
services:
  - docker

# build命令，buildDocker是项目内自定义的命令，用于生成docker 镜像
script:
  - gradle clean
  - gradle wrapper
  - ./gradlew build buildDocker --info

# build成功后push镜像到docker hub
after_success:
- bash <(curl -s https://codecov.io/bash)
- docker login --username="$DOCKER_USERNAME" --password="$DOCKER_PASSWORD";
  docker push repo/project-name;

# deploy之前，安装gcloud和kubectl
before_deploy:
  - if [ ! -d "$HOME/google-cloud-sdk/bin" ]; then rm -rf $HOME/google-cloud-sdk; export CLOUDSDK_CORE_DISABLE_PROMPTS=1; curl https://sdk.cloud.google.com | bash; fi
  - source /home/travis/google-cloud-sdk/path.bash.inc
  - echo 'download google cloud sdk'
  - echo '=============================update kubectl============================='
  - gcloud --quiet version
  - gcloud --quiet components update
  - gcloud --quiet components update kubectl
  - echo '=============================finish update=============================='

# 执行部署脚本，deploy-staging.sh参考4.2的模版
deploy:
  - provider: script
    script: sh deploy-staging.sh
    skip_cleanup: true
    on:
      all_branches: true
```

### 4.2 `deploy-stagin.sh`模版

```shell

#! /bin/bash
set -e

#for credentials
echo '=============================gcloud config set certificate========================='
gcloud config set container/use_client_certificate True
echo '=============================finish gcloud config set certificate=================='

#decode gcloud service key to .json file
echo '=============================decode gcloud service key============================='
echo $GCLOUD_SERVICE_KEY | base64 --decode > ${HOME}/gcloud-service-key.json
echo '=============================finish decode gcloud service key======================'

#config gcloud auth activae service accout by .json file
echo '=============================gcloud auth accout config============================='
gcloud auth activate-service-account --key-file=${HOME}/gcloud-service-key.json
echo '=============================finish gcloud auth accout config======================'

#gcloud config project
#${PROJECT_NAME} come from travis setting
echo '=============================gcloud config project================================='
echo ${PROJECT_NAME}
gcloud --quiet config set project ${PROJECT_NAME}
echo '=============================finish gcloud config project=========================='

#gcloud config cluster
#${CLUSTER_NAME} come from travis setting
echo '=============================gcloud config container cluster======================='
echo ${CLUSTER_NAME}
gcloud --quiet config set container/cluster ${CLUSTER_NAME_STG}
echo '=============================finish config container cluster======================='

#gcloud config compute zone
#${CLUSTER_COMPUTE_ZONE} come from travis setting
echo '=============================gcloud config compute zone============================'
echo ${CLUSTER_COMPUTE_ZONE}
gcloud --quiet config set compute/zone ${CLUSTER_COMPUTE_ZONE}
echo '=============================finish gcloud config compute zone====================='

#gcloud config cluster credentials
#${CLUSTER_NAME} come from travis setting
echo '=============================gcloud config cluster credentials====================='
echo ${CLUSTER_NAME}
gcloud --quiet container clusters get-credentials ${CLUSTER_NAME}
echo '=============================finish gcloud container cluster credentials==========='

#kubectl create deployments and service by .yaml file
echo '=============================kubectl create yaml==================================='
kubectl apply -f ${deployment and service}.yaml
echo '=============================finish kubectl create yaml============================'
```