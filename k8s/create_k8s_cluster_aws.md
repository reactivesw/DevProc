
# Create a K8s cluster in AWS
This document describes the steps to create a K8s cluster in AWS. 

# 1. Install and Configure AWS Command Line Interface
- Follow the document [AWS Command Line Interface](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
to install AWS command linei nterface. After intallation, use `aws configure` to configure the user account secretes. Please ask your AWS admin to get AWS Access Key and AWS Secret Key -- the secrete key is only read once in AWS console when it is initially generated。

# 2. Configure Installation Settings
Please check `kubernetes/cluster/aws/config-default.sh` and `kubernetes/cluster/aws/options.md` for a complete configuraiton description. 

After specify AWS as k8s provider, only the `INSTANCE_PREFIX` and `KUBE_VPC_CIDR_BASE` are required to be unique to avoid conflicts with existing clusters. The default configuration uses a `t2.medium` and 20GB ESB SSD disk for master,  a `t1.micro` and 32GB ESB SSD disk for a node. 

If you re-create a cluster with the same settings, you should delete all existing EC2 instances (by deleting AUTO SCALING lauch configuration, autoscaling group for nodes and terminating the master EC2 instance) and the corresponding VPC to avoide network address and name conflicts.  

Put the following environment variables in a script file such as `k8s_env.sh` and run `source k8s_env.sh` to set environment variables. 

```sh
#!/bin/sh
# To use AWS cluster nodes
export KUBERNETES_PROVIDER=aws 

# change this to your unique prefix to avoid conflict with existing k8s cluster, the default is kubernetes. 
export KUBE_AWS_INSTANCE_PREFIX=mycluster 

# change this to avoid conflict with existing k8s cluster, the default VPC CIDR is 172.20.0.0/16. 
export KUBE_VPC_CIDR_BASE=172.27

# the number of nodes, not include the master. the default is 4 if not set
export NUM_NODES=2 
```

# 3. Create a k8s Cluster
If you don't have the kubernetes software downloaded, run the following command to install the software and create an AWS k8s cluster.  

```sh
#Using wget
wget -q -O - https://get.k8s.io | bash
# or Using cURL
curl -sS https://get.k8s.io | bash
```

If you already have the kubernetes installed, run the following command to create an AWS cluster. 
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

# 4. Tips
To check the cluster configurations, especially the username and password to access dashboard and Kibana, run the command `kubectl config view`. 

To see the current cluster info, run `kubectl cluster-info`.  

To share cluster access, see http://kubernetes.io/docs/user-guide/sharing-clusters/. After run `cluster/kube-up.sh`, copy `$HOME/.kube/config` to a folder in sharing machine,  there are three options to share the access credentials: 
* Option 1: copy to the default location: `mv /path/to/.kube/config $HOME/.kube/config`
* Option 2: copy to working directory (from which kubectl is run): `mv /path/to/.kube/config $PWD`
* Option 3: manually pass kubeconfig location to kubectl: via environment variable `export KUBECONFIG=/path/to/.kube/config` or via commandline flag `kubectl ... --kubeconfig=/path/to/.kube/config`. 

To switch to a different cluster context, run `kubectl config set current-context {context-name}`

To remove dated entries of deleted clusters by other users, use `kubectl config unset` to delete entries in clusters, contexts and users. For example:
```sh 
kubectl config unset clusters:cluster-name
kubectl config unset contexts:context-name
kubectl config unset users:user-name  
```

# Reference
1. https://github.com/kubernetes/kubernetes/blob/master/docs/design/aws_under_the_hood.md
1. http://www.tothenew.com/blog/setup-kubernetes-cluster-on-aws-ec2/
1. https://medium.com/@canthefason/kube-up-i-know-what-you-did-on-aws-93e728d3f56a#.avnpg7zau
1. http://ryaneschinger.com/blog/building-a-kubernetes-cluster-on-aws/
1. http://kubernetes.io/docs/getting-started-guides/aws/
