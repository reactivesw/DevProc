# GKE Setup

## 1. init project

Products & Services -> IAM & Admin -> All projects -> CREATE PROJECT

type in `Project name` and click `CREATE`

## 2. Enable Google Container Engine API

project dashboard -> Go to APIs overview -> Enable API -> Google Cloud APIs -> Container Engine API -> Enable

## 3. service accout

IAM & Admin -> Service accounts -> use `Compute Engine default service account` -> click `Create key`  -> choose `JSON` file type -> `CREATE`

after created, would save a json file on your computer, store it securely.

PS: customized account would not  work if `Compute Engine default service account` does not have any key, so just use default service account and its key.

## 4. install gcloud sdk

Before install gcloud sdk, make sure that `Python 2.7` is installed on your system. `Python 3` is not supported.

Use following command to download gcloud sdk and install it:

```shell
if [ ! -d "$HOME/google-cloud-sdk/bin" ]; then rm -rf $HOME/google-cloud-sdk; export CLOUDSDK_CORE_DISABLE_PROMPTS=1; curl https://sdk.cloud.google.com | bash; fi
```

After downloaded, use `source` command or restart `terminal` to make it work

`source $HOME/google-cloud-sdk/path.bash.inc`

Now you can use `gcloud` command, test it!

`gcloud --quite version`

## 5. install kubectl

`gcloud --quiet components update kubectl`

## 6. gcloud auth login

Use json file created at step 3 to login gke

```shell
gcloud config set container/use_client_certificate True
gcloud auth activate-service-account --key-file=Desktop/reactivesw-project-8cbc65e6b354.json
gcloud auth list
```

## 7. create k8s container engine

Products & Services -> Container Engine -> Create a container cluster -> use default setting and click `create`

## 8. connect to k8s cluster

At container clusters page, click button `Connect` of cluster, and you can get script and use it to connect to k8s.

```shell
gcloud container clusters get-credentials cluster-1 \ --zone us-central1-a --project reactivesw-project
kubectl proxy
```

visit k8s dashboard at address `http://localhost:8001/ui`