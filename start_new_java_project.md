# Start a Java Project

## 1. Create a GitHub Repository
In GitHub web site, perform the following steps:
* using a lowercase name pattern: first_second
* set license to Apache 2.0
* add a .gitignore for java project
* add README.md to describe the project
* add the dev team with write permission

## 2. Create a Gradle Project
In your local development folder, setup the initial project. 
* clone the newly-created GitHub project.
* copy `.gitignore` file from the sample [resources/.gitignore](resources/.gitignore).
* run `gradle init --type basic` to initialize basic project structure.
* delete `settings.gradle` file if it doesn't have sub-projects. 
* edit `build.gradle` file to fit the projeect needs. 
* if the project has documents, create a `documents` folder.
* commit and push changes for this initial project structure.

## 3. Build scripts
There are many things involved in the build process: dependent Java libraries, other git repositories, gRPC code generation, code style checking, unit test, code test coverage, Java code bug checking (PMD, findbug),  and Docker image etc. 

We use multiple gradle build scripts to manage the build process and combine them in the root level `build.gradle` file. To set up the build scripts, please check [build_scripts.md](build_scripts.md) for details.

## 4. Release 


