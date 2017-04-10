# JAVA File Structure

## 1. Introduction

Here we introduce the java project structure and special specifications.

## 2. java project structure

### 2.1 project structure

We use gradle to build and compile our java project, following is project structure:

```
project -->
  build_scripts -->
    quality_assurance
    application_dependencies.gradle
    application_version.gradle
    build_setups.gradle
    docker_build.gradle
  deploy
  docs
  src -->
    main -->
      java
      resources
    test -->
      groovy
  .gitignore
  .travis.yml
  build.gradle
  codecov.yml
  README.md
```

#### 2.1.1 build_scripts
Pleaes check [./build_scripts.md](./build_scripts.md) for details. 

#### 2.1.2 deploy

Here is kubernetes deploy script used in travis, including two file: `deploy.sh`, `k8s.yaml`

* deploy.sh

  This file defines how to connect to gke and deploy project to kubernetes on gke, here is the [template](https://github.com/reactivesw/development-process/blob/master/devops/CD%20to%20k8s%20on%20gke%20by%20travis.md#42-deploy-staginsh%E6%A8%A1%E7%89%88)

* k8s.yaml

  This file is used to deploy kubernetes service and deployment, here is the [reference](https://kubernetes.io/docs/reference/)

#### 2.1.3 docs

Here is document file directory, including `design.md` and `api.md`.

* design.md

  This file define the project's features and how to achieve them.

* api.md

  This file define Rest Api provided by project.
  Here is template:

```
# Title

## introduction
project introduction

## View Model

### ExampleView

| field name | field type | comments |
|-|-|-|
| exampleName | exampleType | example comment |

## API

### Example API

* Url : api url
* method : http method
* request body(or param):

  | name | type | required |
  |-|-|-|
  | requestName | requestType | required |

* response : responseType(String, ExampleView e.g.)
```

#### 2.1.4 src

This is the reource directory, including `main/java`, `main/resources`, `test/groovy`, `test/resources`

* main/java

  directory for java code source root.

* main/resources

  directory for resources root, including `application.yml` and `logback.xml`.

* test/groovy

  directory for test source root.
  we use spock to test our code, which need groovy install of java.

* test/resources

  directory for test resources root.

#### 2.1.5 .travis.yml

This file is used by travis-ci, here is the [reference](https://docs.travis-ci.com/).
This file defines build script, docker push script, deploy script.

#### 2.1.6 codecov.yml

This file define code coverage require.
Here is template:

```yaml
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

#### 2.1.7 README.md

This is project readme file.

### 2.2 package

In our business project, we define three main package named `application`, `domain`, `infrastructure`, under the root package named `io.reactivesw.projectName`.
Following is package structure:

```
src -->
  main -->
    java -->
      io.reactivesw.projectName -->
        application -->
          controller
          model -->
            action
            mapper
          service
          admin -->
            controller
            model
            service
        domain -->
          model
          service
        infrastructure -->
          util
          configuration
          validator
          repository
```

#### 2.2.1 application

* controller

  This package is for controller class.

* service

  This package is for application class which is across service class or service project.

* model

  This package is for view model which is used in controller as request and response.

* model/action

  This package is for update action which is used in update service.

* model/mapper

  This package is for model mapper, whick is used to convert view model and domain model.

* admin

  This package is for controller, model and application used in admin web.

#### 2.2.2 domain

* model

  This package is for domain model which is map to JPA entity and Database table.

* service

  This package is for domain service which only handles domain model.

#### 2.2.3 infrastructure

* configuration

  Project configuration package, including `Corsconfiguration` class and `AuditorAwareConfig` class.

* repository

  Domain model repository package.

* validator

  This package is for validator class which is used to valid some field like version, name e.g.

* util

  Project util package, including `UpdateActionUtils` class, `ReferenceTypes` class, `ZonedDateTimeAuditorAware` e.g.

* exception

  This package is for exception class which is defined and used in the project.

* update

  Update util package.

* Router.java

  This file define the Url used in controller class.


## 3. special specifications

Here is the special specifications we define in java project.

### 3.1 mapper method

In mapper class, usually define two types method: `map View Model to Entity Model` or `map Entity Model to View Model`.
Name method `map View Model to Entity Model` to be `toEntity`, name method `map Entity Model to View Model` to be `toModel`.
if mapper class has method which build an object from anthod type object, like building an order from cart, name the method to be `build`.

### 3.2 method order

In class, make `public` method above `private` method.

### 3.3 Injection Types

Use `constructor` to inject dependency class.
This [article](http://vojtechruzicka.com/field-dependency-injection-considered-harmful/) explain the reason.

### 3.4 boolean field

Don't use `isXXX` as a boolean filed, use adjective.
example:

```java
boolean isSelected;  //this is bad.
boolean selected;  //this is OK.
```

### 3.5 file name

File name should be lower case letters and connected by underline.
