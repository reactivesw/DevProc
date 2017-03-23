# Start a Java Project

## 1. Create a GitHub Repository
In GitHub web site, perform the following steps:
* use repository name style defined in [Git Workflow](../git_workflow.md).
* set license to Apache 2.0
* add a .gitignore for java project
* add README.md to describe the project
* add the dev team with write permission

## 2. Create a Gradle Project
In your local development folder, setup the initial project. 
* clone the newly-created GitHub project.
* copy the sample [resources/gitignore](resources/gitignore) as the `.gitignore` file in respository root.
* run `gradle init --type basic` to initialize basic project structure.
* delete `settings.gradle` file if it doesn't have sub-projects. 
* create gradle build scripts as suggested by the [build scripts](./build_scripts.md) file. 
* if the project has documents, create a `docs/` folder.
* commit and push changes for this initial project structure.

## 3. Source Code and Test 
Google Java style file should be imported into the Java IDE because check style uses Google Java style. 
We recommend to follow gradle default project structure to organize source code files. 
Create `src/test/groovy` folder and put all tests there. Make all test file packages same as their Java packages.

## 4. Build Scripts
There are many things involved in the build process: dependent Java libraries, other git repositories, gRPC code generation, code style checking, unit test, code test coverage, Java code bug checking (PMD, findbug),  and Docker image etc. 

We use multiple gradle build scripts to manage the build process and combine them in the root level `build.gradle` file. To set up the build scripts, please check [build_scripts.md](build_scripts.md) for details.

## 5. Code Publish
When a local change is pushed to Github repository,  it should trigger a sequence of test, build, check and deployment tasks. The [publish_process.md](publish_process.md) describes the configuration and steps to publish changes.  

