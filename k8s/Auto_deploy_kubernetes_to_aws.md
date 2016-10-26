
# 说明
本文介绍了如何通过本地安装的 AWSCLI 用脚本完成一键部署 kubernetes 集群。除了使用 AWSCLI安装之外，也可以先在AWS EC2上开启一个实例，然后SSH连接到该实例，类似于跳板一样，来进行安装。

# 1. 前置要求
- 安装 [AWS Command Line Interface](http://docs.aws.amazon.com/zh_cn/cli/latest/userguide/cli-chap-welcome.html)

- 配置AWS账号： 运行 `aws configure`
配置AWSCli需要用到 AWS Access Key 和 AWS Secret Key（这个只有生成的时候看到一次， 请问Admin获得）。

如果想要使用 AWS 上自己的 profile，可以在环境变量里设置 AWS_DEFAULT_PROFILE：
```sh
export AWS_DEFAULT_PROFILE=myawsprofile
```

# 2. Configure Installation Settings
Please check `kubernetes/cluster/aws/config-default.sh` and `kubernetes/cluster/aws/options.md` for a complete configuraiton description. 

```sh
#!/bin/sh
# To use AWS cluster nodes
export KUBERNETES_PROVIDER=aws 

# change this to your unique prefix to avoid conflict with existing k8s cluster
export INSTANCE_PREFIX=myapp 

# the default VPC CIDR is 172.20.0.0/16, change this to avoid conflict with existing k8s cluster
export KUBE_VPC_CIDR_BASE=172.27

# the number of nodes, not include the master. the default is 4 if not set
export NUM_NODES=2 

# We set the two to use the same region resources
export KUBE_AWS_ZONE=us-west-2c
export AWS_S3_REGION=us-west-2 
```

# 3. 安装
参数全部配置完毕后就可以开始安装。如果本地没有下载kubernetes，那么使用以下指令：
```sh
#Using wget
wget -q -O - https://get.k8s.io | bash
#Using cURL
curl -sS https://get.k8s.io | bash
```

脚本执行将会先下载kubernetes的最新release版本，解压，然后开始执行一键部署的 kube-up.sh 脚本，最终完成整个部署。

如果已经下载并解压了kubernetes在本地，那么执行kube-up.sh来进行安装：
```sh
./<Path To kubernetes>/cluster/kube-up.sh
```

When it is done, you should see the following messages:
```
Cluster validation succeeded
Done, listing cluster services:
Kubernetes master is running at https://35.160.196.250
Elasticsearch is running at https://35.160.196.250/api/v1/proxy/namespaces/kube-system/services/elasticsearch-logging
Heapster is running at https://35.160.196.250/api/v1/proxy/namespaces/kube-system/services/heapster
Kibana is running at https://35.160.196.250/api/v1/proxy/namespaces/kube-system/services/kibana-logging
KubeDNS is running at https://35.160.196.250/api/v1/proxy/namespaces/kube-system/services/kube-dns
kubernetes-dashboard is running at https://35.160.196.250/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard
Grafana is running at https://35.160.196.250/api/v1/proxy/namespaces/kube-system/services/monitoring-grafana
InfluxDB is running at https://35.160.196.250/api/v1/proxy/namespaces/kube-system/services/monitoring-influxdb

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

To check the cluster configuration, especially the username and password to access dashboard and Kibana, run the following command:
```sh
kubectl config view
```


# Reference
1. https://github.com/kubernetes/kubernetes/blob/master/docs/design/aws_under_the_hood.md
1. http://www.tothenew.com/blog/setup-kubernetes-cluster-on-aws-ec2/
1. https://medium.com/@canthefason/kube-up-i-know-what-you-did-on-aws-93e728d3f56a#.avnpg7zau
1. http://ryaneschinger.com/blog/building-a-kubernetes-cluster-on-aws/
1. http://kubernetes.io/docs/getting-started-guides/aws/