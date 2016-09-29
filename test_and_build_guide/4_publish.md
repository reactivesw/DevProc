# Test and Build 参考指南之四 Publish and Process

本地build镜像或者运行镜像，需要先在本地安装docker。  
示例项目为`reactivesw/customer-web`，请注意将相关内容修改为自己的内容。  
其他变量请根据实际应用情况修改。

## Publish

### 本地Build docker镜像

* 1) 新建dockerFile
在`src/main/docker/`目录下新建文件`DockerFile`:
```
# this base image contains only compiler and jvm, based on Alpine Linux and only has 60MB.
# It is also used by Spring example.
FROM frolvlad/alpine-oraclejdk8:slim
VOLUME /tmp

# the version is defined in build script
ADD customer-web-0.0.1.jar app.jar
RUN sh -c 'touch /app.jar'

# all java apps should define java.security.egd as suggested by
# http://security.stackexchange.com/questions/14386/what-do-i-need-to-configure-to-make-sure-my-software-uses-dev-urandom
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
```

* 2) 在gradle build中加上docker
在`application/build/`下新建文件`docker_build.gradle`:
```
apply plugin: 'docker'

group = "reactivesw"

task buildDocker(type: Docker, dependsOn: build) {
    applicationName = jar.baseName
    dockerfile = file('src/main/docker/Dockerfile')
    doFirst {
        copy {
            from jar
            into stageDir
        }
    }
}
```
然后在`build.gradle`文件中`buildscript`的`dependencies`加上:
```
classpath('se.transmode.gradle:gradle-docker:1.2')
```
再把`docker_build.gradle`文件引入进来，在引入`application_build.gradle`行下面加上
```
apply from: 'application_build/docker_build.gradle'
```

* 3) 本地build镜像
```
./gradlew build buildDocker
```

### 同步到docker hub

* 1) 修改`.travis.yml`文件
在文件中添加:
```
services:
  - docker
  
script:
  - gradle clean
  - gradle wrapper
  - ./gradlew build buildDocker --info    # buildDocker对应docker_build.gradle文件中的task

after_script:
  - docker login --username="$DOCKER_USERNAME" --password="$DOCKER_PASSWORD";
    docker push reactivesw/customer-web;  ＃ 修改成自己的docker镜像名
```

## Process

### 本地运行docker镜像

* 1) 查看当前所有镜像
```
docker images
```
结果类似如下:
```
REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
reactivesw/customer-web      latest              719bbed85f78        About an hour ago   252.6 MB
ubuntu                       latest              c73a085dc378        2 days ago          127.1 MB
frolvlad/alpine-oraclejdk8   slim                f8103909759b        5 days ago          167.1 MB
```

* 2) 运行指定的镜像
```
docker run -p 8080:8080 -t reactivesw/customer-web    # 对应上面的镜像名称
```

### 通用运行文件

在项目根目录下添加文件`runDocker`，内容类似如下:
```
#!/bin/bash

# the first paramerter is the exposed port number
port=8080
if [ $# > 1 ]; then 
  port=$1
fi

containers=`docker ps -a -q`
if [ ! -z "$containers" ]; then 
  echo "stop running containers"
  docker stop $containers
  docker rm $containers
fi

docker run -p ${port}:8080 -t reactivesw/customer-web
```