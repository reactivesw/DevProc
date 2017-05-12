# Auto Deploy to Kubernetes
This document describes how to automatically deploy services to kubernetes.

## 1. Kubernetes API
k8s provide a lot of restful api([api reference](http://kubernetes.io/docs/api-reference/v1/operations/)) to manage k8s resources like rc , pod e.g.
In the whole deployment process, use following api:
* delete a ReplicationController
  `DELETE /api/v1/namespaces/{namespace}/replicationcontrollers/{name}`
* delete a Pod
  `DELETE /api/v1/namespaces/{namespace}/pods/{name}`
* create a new rc by yaml file
  `POST /api/v1/namespaces/{namespace}/replicationcontrollers`


## 2. Deploy Scripts
In project, create a new folder named `scripts`(or other name you like), in this folder, new two file name `deploy.sh` and `cust-catalog-rc.yaml`(you should use your project name to install the file name).
### 2.1 `deploy.sh`
In `deploy.sh`, call api to delete a rc and all pods, and finally create a new rc by post yaml file to k8s.
Here is the example.
```shell
#! /bin/sh

#设置名字
serviceName="cust-catalog"
readonly serviceName

#删除rc
echo "\n----------------------------------start delete ${serviceName} rc---------------------------------------------\n"
curl -X DELETE http://54.200.161.225:8080/api/v1/namespaces/default/replicationcontrollers/${serviceName}
echo "\n----------------------------------end delete ${serviceName} rc-----------------------------------------------\n"

#获取到所有的pods
echo "\n----------------------------------start get all ${serviceName} pod-------------------------------------------\n"
podList=$(curl -X GET http://54.200.161.225:8080/api/v1/namespaces/default/pods)
echo "\n----------------------------------end get all ${serviceName} pod---------------------------------------------\n"

#删除所有pod
echo "\n----------------------------------start delete all ${serviceName} pod----------------------------------------\n"
for podName in $(echo $podList | grep -oE ${serviceName}"-[a-zA-Z0-9]{1,5}")
do
	curl -X DELETE http://54.200.161.225:8080/api/v1/namespaces/default/pods/$podName
done
echo "\n----------------------------------end delete all ${serviceName} pod------------------------------------------\n"

#提交yaml文件，新建rc
echo "------------------------------------start post cust-catalog-rc.yaml to k8s-------------------------------------\n"
curl -X POST http://54.200.161.225:8080/api/v1/namespaces/default/replicationcontrollers \
	  -H "Content-Type:application/yaml" --data-binary "@cust-catalog-rc.yaml"
echo "\n----------------------------------end post cust-catalog-rc.yaml to k8s---------------------------------------\n"
```
In your project, you should name your own service name install of `cust-catalog`, and use your own yaml file path.
### 2.2 `yaml`
Here is `cust-catalog-rc.yaml` for example.
```yaml
kind: ReplicationController
apiVersion: v1
metadata:
  name: cust-catalog
  labels:
    name: cust-catalog
spec:
  replicas: 1
  selector:
    name: cust-catalog
  template:
    metadata:
      labels:
        name: cust-catalog
    spec:
      containers:
      - name: cust-catalog
        image: reactivesw/catalog
        ports:
        - containerPort: 9096
        env:
        - name: spring_datasource_url
          value: "jdbc:mysql://10.254.156.22:3306/reactivesw"
        - name: spring_datasource_username
          value: root
        - name: spring_datasource_password
          value: "123456"
        - name: grpc_port
          value: "9096"
```

## 3. Travis Support
In Travis CI,we can easily deploy to server by a custom script([Travis Refence](https://docs.travis-ci.com/user/deployment/script/)).

1. edit `.travis.yaml`
  in `.travis.yaml`, append following script:
  ```yaml
  deploy:
  provider: script
  script: sh ./scripts/deploy.sh
  skip_cleanup: true
  on:
    all_branches: true
  ```
  
2. edit `deploy.sh`
  in `deploy.sh`, we need to change the path of yaml file.
  * before
    ```shell 
    curl -X POST http://54.200.161.225:8080/api/v1/namespaces/default/replicationcontrollers \
	  -H "Content-Type:application/yaml" --data-binary "@cust-catalog-rc.yaml"
    ```
    
  * after
    ```shell 
    curl -X POST http://54.200.161.225:8080/api/v1/namespaces/default/replicationcontrollers \
	  -H "Content-Type:application/yaml" --data-binary "@./scripts/cust-catalog-rc.yaml"
    ```
	  
