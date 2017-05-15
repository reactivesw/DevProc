# Publish Process

## 1. Introduction
Here we introduce the publish code to GitHub and DockerHub. 
We're using [webpack template](https://github.com/vuejs-templates/webpack) of vue-cli as start point in this doc.

### 1.1 The tools we use
- github --- for code base
- travis-ci --- for auto build
- docker hub --- for image base
- kubernetes --- cloud platform

### 1.2 The basic process
1. Follow the git process to submit our code.
2. Auto build & publish action will be triggered after submit code.
3. Travis-ci will build code, build docker image and push it to the docker hub.
4. Publish the docker image to kubernetes. (More detail later)
 
## 2. Publish to GitHub and Docker
We use travis-ci and codecov to build a GitHub repository and display the results in the repository README.md.   

### 2.1 travis-ci
Create a file named `.travis.yml` to the root directory of project with content below:
```yml
sudo: required
language: node_js
node_js:
    - "6"

cache:
  directories:
    - $HOME/.npm
    - "$HOME/google-cloud-sdk/"

services:
  - docker

script:
  - npm run build
  - npm run docker

after_success:
- sh ./build/deploy/docker_pusher.sh

before_deploy:
  - if [ ! -d "$HOME/google-cloud-sdk/bin" ]; then rm -rf $HOME/google-cloud-sdk; export CLOUDSDK_CORE_DISABLE_PROMPTS=1; curl https://sdk.cloud.google.com | bash; fi
  - source /home/travis/google-cloud-sdk/path.bash.inc
  - echo 'download google cloud sdk'
  - echo '=============================update kubectl============================='
  - gcloud --quiet version
  - gcloud --quiet components update
  - gcloud --quiet components update kubectl
  - echo '=============================finish update=============================='

deploy:
  - provider: script
    script: sh ./build/deploy/deploy.sh
    skip_cleanup: true
    on:
      branch: dev
```

`script` is for build docker image.

`after_script` push the docker image to our docker hub.

`before_deploy` prepare google cloud sdk

`deploy` run the deploy script

### 2.2 npm scripts
We introduced a new npm scripts `docker` in `.travis.yml`, steps to create it:

1. Copy [docker folder](./resources/publish_process/build/docker) and [docker.js script](./resources/publish_process/build/docker.js) to the build folder of your project.
Replace all the `customer-web`

2. Edit `package.json`, add a `docker` entry in scripts property:
    ```json
    {
      "scripts": {
        "docker": "node build/docker.js"
        // ...
      }
      // ...
    }
    ```
    The `docker.js` script will read project name and version from `package.json` to build image.

### 2.3 Deploy scripts
We used a new script `deploy.sh` in `.travis.yml`, steps to create it:

1. Copy [deploy folder](./resources/publish_process/build/deploy) to the build folder of your project. Replace all the `customer-web` to your project name, as well as versions.
2. Set corresponding namespaces and ports in k8s configs for your project.

### 2.4 Misc

#### 2.4.1 Make webpack fail on error
We expect webpack fail on any error in travis environment, to archive this, edit the `build/webpack.base.js`.

```javascript
// Detect travis environment
const TRAVIS = process.env.TRAVIS ? JSON.parse(process.env.TRAVIS) : false;

module.exports = {
  // Make webpack build failed on error in travis env, https://webpack.js.org/configuration/other-options/#bail
  bail: TRAVIS,
  
  // other configs
}
```

## 3. Environment Variables
We need to setup some environment variables to make deploy script work:

DOCKER_USERNAME
DOCKER_PASSWORD
PROJECT_NAME
CLUSTER_COMPUTE_ZONE
CLUSTER_NAME
GCLOUD_SERVICE_KEY
