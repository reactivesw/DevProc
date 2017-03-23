# Build Scripts
We use multiple build scripts to manage the build process. There is a top level `build.gradle` at the root dicretory of the repoistory. Other applicaiton/DevOps build scripts are defined in the `build_scripts/` directory. 

Additionally, all code style checking, unit test, test coverage and code analysis build scripts are put in the `build_scripts/quality_assurance` folder.

All application build scripts mentioned below can be found in the [resources/build_scripts/ ](resources/build_scripts) folder. You can cusotmize them for your application needs. Some build scripts such as `build_setups.gradle`, `grpc.gradle` and `docker_build.gradle` can be used with very few changes. 

## 1. Initialize `build.gradle`
The top level build file is the `build.gradle` in the repository root folder.  It's recommended to create an `build_scripts/` directory and put all application build scripts there. 

### 1.1. The `buildscript` Section

The `buildscript {}` section of `build.gradle` defines non-standard dependencies dependencies and their repostiories. Some non-standard dependencies examples are 

* `spring-boot-gradle-plugin` for spring boot dependency managment.
* `jacoco-coverage` for unit test code coverage.
* `gradle-docker` for building docker image.  
* `protobuf-gradle-plugin` for gRPC compiler.    

At the begging, define dependency version that may change frequently in the `ext {}`section. 

There is a `repositories {}` section for non-standard dependencies. As a start, we include two standard repositories: `jcenter()` and `mavenCentral()`. Add other repositories ad needed.

Add the non standard dependencies in the `dependencies {}` section. 

### 1.2. Applying Other Scripts
The recommended applying order is `build_ssetups.gradle`, `application_version.gradle`, `application_dependencies.gradle`, other DevOps scripts, and finally quality assurance build scripts. 

Here is a sample [`build.gradle`](resources/build_scripts/build.gradle) file. 

## 2. The `build_setups.gradle` File
The root `build.gradle` should first apply [`buid_scripts/build_setups.gradle`](resources/build_scripts/build_setups.gradle) to initialize repositories, apply java plugin and set gradle wrapper version. 

As a start, we include two standard repositories: `jcenter()` and `mavenCentral()`. If we use other repositories, please add a comments explicitly indicating which dependencies need the additional repositories. 

It is also recommended to explictly define gradle wrapper version here to avoid building chaos. 

## 3. The `application_version.gradle` File
Create an [`build_scripts/application_version.gradle`](resources/build_scripts/application_version.gradle) to set base name and version. Putting application version in a separate file thus we can easilly change it during development. 

## 4. Application Dependencie Script
Create an [`build_scripts/application_dependencies.gradle`](resources/build_scripts/application_dependencies.gradle) file to declare application dependencies and possibly extra repositories 

When use Spring boot plugins, there is no need to specify versions for all Spring boot dependencies. Such dependencies usually have a name starting with `spring-boot` or `spring`. For example: `spring-boot-starter-web` and `spring-session` don't need to specify version.

## 5. Other Build Scripts

Based on the project requirments, you may need to create the other build scripts for DevOps or other tasks. Again, it's better to keep them in separate script files and import them into the root `build.gradle`. Following are some examples.  

### 5.1. Build Docker
Create an `build_scripts/docker_build.gradle` when build docker images. Adding the `gradle-docker` dependency in the `buildscript` section of `build.gradle` and copying the file from [resources/build_scripts/docker_build.gradle](resources/build_scripts/docker_build.gradle) should be enough.

### 5.2. Apply gRPC Build Script 
Create an `build_scripts/grpc_build.gradle` when you use grpc in your application. Adding the `protobuf-gradle-plugin` dependency in the `buildscript` section of `build.gradle` and copying the file from [resources/build_scripts/grpc_build.gradle](resources/build_scripts/grpc_build.gradle) should be enough. 

## 6. Quality Assurance (QA) Tools
There are several quality-checking tasks in the build process. We put them in the `build_scripts/quality_assurance/` subfolder and apply them individually in the root `buiild.gradle` file thus we can have a fina control of the used tools.

Some QA tools may have some configurations that are put under the `build_scripts/quality_assurance/config/` subfolder.  

We put sample QA tools and their configuration files in the [`resources/build_scripts/quality_assurance/`](resources/build_scripts/quality_assurance/) folder. 