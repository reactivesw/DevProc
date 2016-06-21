# Java Code Standard 

## Basic Style
We use [Google Java Style](https://google.github.io/styleguide/javaguide.html) published on March 21, 2014. It has a [Chinese version](http://blog.mosil.biz/2014/05/java-style-guide/).

## IDE Settings
There are sytle settings for [IntelliJ](https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml) and [Eclipse](https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml).

## Style checking
For both Java Style and additional code standard, we use [CheckStyle](http://checkstyle.sourceforge.net/) to check styles in both Eclipse editor and in Build phase. 

## Naming Guideline
We shoud name all things by their business meanings. The best guide is using a domain-specific ubiquitous language as suggested by Domain Driven Design. Specifically, after the com.orgranization prefix, the first package level is a name of a microservice. For each microservice, there are domain, resources (for UI), and application in the next level. The "domain" means business domain. In a domain, we usually have business models and services. The "model" has all business entities (aggregates). The "service" has all services for this domain. 

For example, entityies in the 'User' aggreate root in 'identityacces' may be defined in a pakcage named 'com.reactivesw.identityaccess.domain.user'. 

As another example, HTML views of of 'identityaccess' may be defined in a package named 'com.reactivesw.identityaccess.resources.view'. 

