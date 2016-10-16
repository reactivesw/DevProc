# Publish Process
## 1. Introduction
Here we introduce the publish code to GitHub and DockerHub. 
### 1.1 The tools we use
- github --- for code base
- travis-ci --- for auto build
- codecov --- for auto check test coverage
- docker hub --- for image base
- kubernetes --- our cloud platform

### 1.2 The basic process
1. first, we fellow the git process to submit our code.
2. second, the auto build & pubulish action will be trrigered after we submit our code.
3. then, travis-ci will build our code just like we do it at our local machine. But it can do more. after build the code, travis-ci will call codecov to check our code coverage and then build a docker image, and at last push it to the docker hub.
4. since we got our docker image, we can publish it to production.(we will add detail later)
 
## 2. Publish to GitHub and Docker
We use travis-ci and codecov to build a GitHub repository and display the results in the repository README.md.   

### 2.1 travis-ci 
Add file `.travis.yml` to the root of your project.
And the content may be:
```yml
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

`script` is for build docker image.

`after_script`  push the docker image to our docker hub.

`after_success` trigger the codecov to check our code coverage, and output a detail report.
` 76aa4e85-79ee-4528-8161-b0120af54a59`  is the project token on codecov.io 

To avoid Gradle version issues, we use gradle wrapper to build the repository. 

### 2.2 codecov
Add file `codecov.yml` to the root of your project and add content:
```yml
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

You can change the content for some special reasons.

Still we should add `bash <(curl -s https://codecov.io/bash) -t 76aa4e85-79ee-4528-8161-b0120af54a59` to `.travis.yml`, so that we can trigger codecov in travis

### 2.3 Link GitHub Repository 
Use team account to turnon project sync in https://travis-ci.org/. From the build result, copy and paste the build result icon url to the top of README.md in the GitHub repository. 

For code coverage result, copy the result icon from https://codecov.io/gh. 

## 3. Publish to DockerHub
Docker hub is a container repository. Use the team account in DockerHub to build docker image from a GitHub commit.

