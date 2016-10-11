# Build Scripts
We use multiple build scripts to manage the build process. There is one top level `build.gradle` at the root dicretory of the repoistory. Other applicaiton build scripts are defined int `application_build` directory. 

Additionally, for code style, unit test, test coverage and code checking, we use a `code_analyzer_test_local` folder and a git submodule used to manage the configurations and perform tasks.  

All application build scripts mentioned below can be found in [resources/build_scripts](resources/build_scripts). You can cusotmize them for your application needs. Some build Scripts such as `init_build.gradle`, `grpc.gradle` and `docker_build.gradle` can be used with minor changes or no changes. 

The order matters in applying these scripts. The suggested order is as the following

```groovy
// first is the init script
apply from: 'application_build/init_build.gradle'

// the second is version settings
apply from: 'application_build/version.gradle'

// the third is application build
apply from: 'application_build/application_build.gradle'

// then grpc and others -- the order shouldn't matter after this point
apply from: 'application_build/grpc.gradle'

//code analyzer and test
apply from: 'code_analyzer_test_local/code_analyzer.gradle'
apply from: 'code_analyzer_test_local/code_unit_test.gradle'

// build docker image task
apply from: 'application_build/docker_build.gradle'
```

## 1 Initialize `build.gradle`
The top level build file is the `build.gradle` in the repository root folder.  It's recommended to create an `application_build` directory and put all used build scripts there. 

The `buildscript` section of `build.gradle` defines extra dependencies and their repostiories. Typical dependencies include 

* `spring-boot-gradle-plugin` for spring boot and spring boot dependency managment.
* `jacoco-coverage` for unit test code coverage.
* `protobuf-gradle-plugin` for gRPC compiler.    
* `gradle-docker` for building docker image.  

When use the additional plugins, we need to add the corresponding dependencies in this section. The completed sample `build.gradle` file is given at the end of this document. Following are step by step instructions to create the build script files. 

## 2 Apply `init_build.gradle` file
The first step is to create and apply `application_build/init_build.gradle` to initialize repositories, apply java plugin and set gradle wrapper version. The file has the following content: 

```groovy
// Setting the common Java and gradle wrapper, this should be the first `apply from` file.

repositories {
    jcenter()
    mavenLocal()
    mavenCentral()
    maven {
      url 'https://repo.spring.io/libs-milestone'
    }
  }

apply plugin: 'java'

compileJava {
  sourceCompatibility = JavaVersion.VERSION_1_8
  targetCompatibility = JavaVersion.VERSION_1_8
}


// Specify the gradle wrapper version
task wrapper(type: Wrapper) {
  gradleVersion = '3.1'
}
```

## 3 Apply `version.gradle` File
Create an `application_build/version.gradle` script file. Use this file to set group, base name and version of the build result and docker image. A typical one is as the following: 

```groovy
group = 'reactivesw'

// for Java jar file basename
archivesBaseName = 'myapplication-name'
version = '0.0.42'
```

## 4. Apply Application Build Script
Create an `application_build/Application.gradle` file to include dependencies used in your application. 

When apply Spring boot plugin using command `apply plugin: 'spring-boot'`, there is no need to specify versions for all Spring boot dependencies. Such dependencies usually have a name starting with 'spring-boot', for example: `spring-boot-starter-thymeleaf`, `spring-session`, `spring-boot-starter-data-jpa`, and `spring-boot-starter-redis` etc. 

A sample application build script is as the following: 

```groovy
// for spring boot
apply plugin: 'spring-boot'

dependencies {
  //database
  compile("mysql:mysql-connector-java:5.1.26")
  compile("org.springframework.boot:spring-boot-starter-data-jpa")
  //security, like password encoder.
  compile('org.springframework.security:spring-security-crypto')
  compile('org.springframework.boot:spring-boot-starter-redis')

  // some tools used in project
  compile("org.apache.commons:commons-lang3:3.4")
  compile ("commons-validator:commons-validator:1.4.0")
  //email tools
  compile('com.sun.mail:javax.mail:1.5.1')
}
```

## 5. Apply gRPC Build Script 
Create an `application_build/grpc.gradle` when you use grpc in your application. Adding the `protobuf-gradle-plugin` dependency in the `buildscript` section of `build.gradle` and copying the file from [resources/build_scripts/grpc.gradle](resources/build_scripts/grpc.gradle) should be enough. 

## 6. Build Docker
Create an `application_build/docker_build.gradle` when you use grpc in your application. Adding the `gradle-docker` dependency in the `buildscript` section of `build.gradle` and copying the file from [resources/build_scripts/docker_build.gradle](resources/build_scripts/docker_build.gradle) should be enough.

## 7. Code Style, analyzer and Test 
It's a little bit tricky to perform these quality-checking tasks in the build process. We use a git submodule to store the team-wide configuration. Please follow the instructions in https://github.com/reactivesw/code_analyzer_test repository to configure build system to check code style, run code analyzer and unit test. 



## 8. A Sample `build.gradle` File

```groovy
buildscript {
  ext { springBootVersion = '1.4.1.RELEASE' }

  repositories {
    jcenter()
    mavenLocal()
    mavenCentral()
    maven {
      url "http://dl.bintray.com/robfletcher/gradle-plugins"
      url 'https://repo.spring.io/libs-milestone'
    }
  }
  dependencies {
    // for spring boot
    classpath("org.springframework.boot:spring-boot-gradle-plugin:${springBootVersion}")

    //for docker build
    classpath('se.transmode.gradle:gradle-docker:1.2')

    // for unit test code coverage  -- need to find a way to put it in its file
    classpath('com.palantir:jacoco-coverage:0.4.0')

    //for proto buffer
    classpath('com.google.protobuf:protobuf-gradle-plugin:0.8.0')
  }
}

// init repository, java, wrapper
apply from: 'application_build/init_build.gradle'

// init application version settings
apply from: 'application_build/version.gradle'

// application build script
apply from: 'application_build/application_build.gradle'

//build grpc files
apply from: 'application_build/grpc.gradle'

// build docker image task
apply from: 'application_build/docker_build.gradle'

// these two files are for code analyzer, unit test and code coverage check
apply from: 'code_analyzer_test_local/code_analyzer.gradle'
apply from: 'code_analyzer_test_local/code_test_coverage.gradle'
```
