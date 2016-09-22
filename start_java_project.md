# Start a Java Project

## 1. Create a GitHub Repository

* using a lowercase name pattern: first_second
* set license to Apache 2.0
* add a .gitignore for java project
* add README.md to describe the project
* add the dev team with write permission

## 2. Create a Gradle Project

* clone the newly-created GitHub project.
* edit .gitignore file with content from https://github.com/reactivesw/development_process/blob/master/GitIgnoreJava.md.
* run `gradle init --type basic` to initialize basic project structure.
* delete `settings.gradle` file if it doesn't have sub-projects. 
* edit `build.gradle` file to fit the projeect needs. 
* if the project has documents, create a `documents` folder.
* commit and push changes for this initial project structure.

## 3. Code Analyze and Test

Google Java style file should be imported into the Java IDE because check style uses Google Java style. 

Create `src/test/groovy` folder and put all tests there. Make all test file packages same as their Java packages. 

Following the instructions in https://github.com/reactivesw/code_analyzer_test repository to configure build system to run code analyzer and unit test. 

## 4. Logging

## 5. gRPC 

## 6. Cloud Native

