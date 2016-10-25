
# 说明
本文介绍了如何通过本地安装的 AWSCLI 用脚本完成一键部署 kubernetes 集群。除了使用 AWSCLI安装之外

# 1. 前置要求
- 已开通 AWS 帐号。
- 安装并配置好 [AWS Command Line Interface](http://docs.aws.amazon.com/zh_cn/cli/latest/userguide/cli-chap-welcome.html)

安装 AWSCLI 需要装 Python 和 Pip ，而这两个程序一般macOS（如10.11 El Capitan）是自带的。
配置AWSCli需要用到 AWS Access Key 和 AWS Secret Key，可以登录 AWS 账号后在管理台查看。
如果想要使用 AWS 上自己的 profile，可以在环境变量里设置 AWS_DEFAULT_PROFILE：
```sh
export AWS_DEFAULT_PROFILE=myawsprofile
```

# 2. 配置安装参数
在运行脚本之前，需要先设置好环境变量，不然脚本会用预设值进行部署。本文使用 macOS 下本地安装的 AWSCLI，请在 terminal 中配置好参数，然后用 env 或者 export 指令查看是否正确配置。

必须配置的参数：

```sh
export KUBERNETES_PROVIDER=aws #将脚本指向cluster文件夹里的aws文件夹
export NUM_NODES=2 #节点数，master不算在内
export MASTER_SIZE=t2.medium #master的配置，一般建议至少选择medium以上
export NODE_SIZE=t2.micro #node的配置，根据需要配置
export KUBE_AWS_ZONE=us-west-2b #AWS的区域，对应us-west-2，包括a,b,c三个
export KUBE_AWS_INSTANCE_PREFIX=k8s #名称的预设部分，大部分用到名称的参数会使用这个作为预设部分，再加上自己的后半部分命名
export AWS_S3_REGION=us-west-2 #S3的区域设置，一般与AWS设置为同一个。P.S：不需要加a,b,c
```

可选配置的参数（等号后为脚本预设值）：
```sh
export AWS_SSH_KEY=$HOME/.ssh/id_rsa #如果想要使用已经有的SSH key，就需要用这个来制定路径。预设会创建SSH key到该路径下。
export NETWORK_PROVIDER=kubenet #网络配置，可选kubenet, opencontrail, flannel。
export KUBE_ENABLE_NODE_LOGGING=true #开启node logging
export KUBE_LOGGING_DESTINATION=elasticsearch #可选elasticsearch, gcp。
export CLUSTER_IP_RANGE=10.244.0.0/16
export MASTER_IP_RANGE=10.246.0.0/24
export MASTER_DISK_TYPE=gp2
export MASTER_DISK_SIZE=20
export NODE_ROOT_DISK_TYPE=gp2
export NODE_ROOT_DISK_SIZE=32
export KUBE_ENABLE_CLUSTER_LOGGING=true #设为true，则Elasticsearch和Kibana会作为cluster的一部分一起启动。
export ELASTICSEARCH_LOGGING_REPLICAS=1 #
```

除了以上参数，还可以配置VPC，Subnet，Security Group。不过这些参数一般建议让脚本创建，不然容易出现网络问题。同理CLUSTER_IP_RANGE，MASTER_IP_RANGE如非必要，不需要特意改动。

更详细的参数介绍可以看kubernetes的github[说明文件](https://github.com/kubernetes/kubernetes/blob/master/cluster/aws/options.md)。

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

当所有安装完成，应该可以看到“Kubernetes cluster is running”的信息显示，并且列出服务的外部访问地址。

访问时使用的用户名和密码可以通过本地使用以下指令
```sh
kubectl config view
```
来获得。
