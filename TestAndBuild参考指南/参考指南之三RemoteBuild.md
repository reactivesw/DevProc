# Test and Build 参考指南之三 Remote Build

## Github

上传project到github上。  
application properties设置尽量使用sample数据。  
**注意：一定要整理好project中的隐私数据，避免将敏感数据暴露在外。**

## Travis

* 1) 在project根目录下创建`.travis.yml`文件
```
sudo: required
language: java
jdk: oraclejdk8

services:
  - docker
script:
  - gradle clean
  - gradle wrapper
  - ./gradlew build buildDocker --info

after_success:
  - bash <(curl -s https://codecov.io/bash) -t 76aa4e85-79ee-4528-8161-b0120af54a59


after_script:
  - docker login --username="" --password="";
    docker push go6d/customer_authentication;
```

* 2) 在project根目录下创建`codecov.yml`文件
```
codecov:
  notify:
    require_ci_to_pass: yes

coverage:
  precision: 2
  round: down
  range: "70...100"

  status:
    project: yes
    patch: yes
    changes: no

  parsers:
     gcov:
       branch_detection:
         conditional: yes
         loop: yes
         method: no
         macro: no

comment:
  layout: "header, diff"
  behavior: default
  require_changes: no
```

* 3) 将project更新push到github上。
 > 由于travis－ci的同步是由github的commit-push触发，所以如果project完全提交后才开启同步开关的话，可能会出现travis-ci的repository并没有拉取的情况。建议在同步开关开启后，再进行最后一次commit。

* 4) 登录`https://travis-ci.org/`，打开project同步开关。
 - 用github账户登录，然后可以看到所有的repository列表
 - 点“＋”号后，可以看到同步提示
 - 选择左侧organization，按照提示，找到需要同步的project打开同步开关
 - 如果你的repository同步开关已经开启，可以忽略这步操作
 > 只有在同步开关开启，且github上的project根目录下同时存在`.travis.yml`和`codecov.yml`文件时，travis－ci才会自动从github上同步拉取project并build。

* 5) gradle wrapper  
 由于travis-ci的版本兼容性问题，本地build成功可能push上去后build会失败。  
 我们需要在本地执行`gradle wrapper`后将project根目录下的gradle路径下的文件同样上传到github。
 > 上传的时候需要把`gradle/wrapper/`下的jar文件上传，如果你的project下的`.gitignore`文件中屏蔽了jar文件的话，可以在本地暂时放开jar限制然后上传。

* 6) 添加build标签图片  
 同步到travis-ci进行build后，在页面上可以看到build结果的图标，点击图标会弹出图片地址的对话框。  
 把图片地址复制下来，编辑到project的`README.md`里。