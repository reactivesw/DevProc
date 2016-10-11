# Build scripts

## 1 Initialize `build.gradle`
The top level build file is the `build.gradle` in the repository root folder. Its `buildscript` section defines extra dependencies and their repostiories. Typical dependencies include 

* `spring-boot-gradle-plugin` for spring boot and spring boot dependency managment.
* `jacoco-coverage` for unit test code coverage.
* `protobuf-gradle-plugin` for gRPC compiler.    
* `gradle-docker` for building docker image.  

## 2 Apply `init_build.gradle` file
Then it applies an initial build script file `application_build/init_build.gradle`. This file defines all repositories, applies Java plugin, defines Java version and gradle wrapper version. The `init_build.gradle` has the following content: 

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
## 3 Apply `version.gradle` file
Both Java jar file and docker image require a base name and a version. We use this file to manage the base name and version number. 

## 4. Code Style, analyzer and Test
Google Java style file should be imported into the Java IDE because check style uses Google Java style. 

Create `src/test/groovy` folder and put all tests there. Make all test file packages same as their Java packages. 

Following the instructions in https://github.com/reactivesw/code_analyzer_test repository to configure build system to run code analyzer and unit test. 

## 5. gRPC 

