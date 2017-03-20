# Build Scripts
We use multiple build scripts to manage the build process. There is a top level `build.gradle` at the root dicretory of the repoistory. Other applicaiton build scripts are defined int `build_scripts` directory. 

Additionally, for code style, unit test, test coverage and code checking, we use a `code_analyzer_test_local` folder and a git submodule used to manage the configurations and perform tasks.  

All application build scripts mentioned below can be found in [resources/build_scripts](resources/build_scripts). You can cusotmize them for your application needs. Some build scripts such as `build_setups.gradle`, `grpc.gradle` and `docker_build.gradle` can be used with few changes or no changes. 

## 1 Initialize `build.gradle`
The top level build file is the `build.gradle` in the repository root folder.  It's recommended to create an `build_scripts/` directory and put all application-specific build scripts there. 

The `buildscript` section of `build.gradle` defines non-standard dependencies dependencies and their repostiories. Typical non-standard dependencies are 

* `spring-boot-gradle-plugin` for spring boot dependency managment.
* `jacoco-coverage` for unit test code coverage.
* `gradle-docker` for building docker image.  
* `protobuf-gradle-plugin` for gRPC compiler.    

When use the additional plugins, we need to add the corresponding dependencies in this section. Here is a sample [`build.gradle`](resources/build_scripts/build.gradle) file. 

Following are step by step instructions to create the build script files. 

## 2 Apply `build_setups.gradle` file
The first step is to create and apply [`buid_scripts/build_setups.gradle`](resources/build_scripts/build_setups.gradle) to initialize repositories, apply java plugin and set gradle wrapper version. 

## 3 Apply `application_version.gradle` File
Create an [`build_scripts/application_version.gradle`](resources/build_scripts/application_version.gradle) script file. Use this file to set base name and version. 

## 4. Apply Application Dependencies Script
Create an [`build_scripts/application_dependencies.gradle`](resources/build_scripts/application_dependencies.gradle) file to include dependencies used in your application. 

When use Spring boot plugins, there is no need to specify versions for all Spring boot dependencies. Such dependencies usually have a name starting with `spring-boot` or `spring`, , for example: `spring-boot-starter-web` and `spring-session` don't need to specify version.

## 5. Other Build Scripts

Based on the project requirments, you may need to create the following build scripts or other build scripts. Again, it's better to keep them in separate script files and import them into the root `build.gradle`.  

### 5.1. Build Docker
Create an `build_scripts/docker_build.gradle` when you use grpc in your application. Adding the `gradle-docker` dependency in the `buildscript` section of `build.gradle` and copying the file from [resources/build_scripts/docker_build.gradle](resources/build_scripts/docker_build.gradle) should be enough.

### 5.2. Code Style, analyzer and Test 
It's a little bit tricky to perform these quality-checking tasks in the build process. We use a git submodule to store the team-wide configuration. Please follow the instructions in https://github.com/reactivesw/code_analyzer_test repository to configure build system to check code style, run code analyzer and unit test.

### 5.3. Apply gRPC Build Script 
Create an `build_scripts/grpc_build.gradle` when you use grpc in your application. Adding the `protobuf-gradle-plugin` dependency in the `buildscript` section of `build.gradle` and copying the file from [resources/build_scripts/grpc_build.gradle](resources/build_scripts/grpc_build.gradle) should be enough. 
