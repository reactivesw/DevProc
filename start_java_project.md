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
* delete `settings.gradle` file if this is a single-module project. 
* edit `build.gradle` file to fit the projeect needs. 
* if has documents, create a documents folder.
* commit and push changes.




