# Java Code Standard 

## 1. Basic Style
We use [Google Java Style](https://google.github.io/styleguide/javaguide.html) published on March 21, 2014. It has a [Chinese version](http://blog.mosil.biz/2014/05/java-style-guide/).

## 2. IDE Settings
This is the sytle settings for [IntelliJ](https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml). In IntelliJ IDEA, using Preferences --> Editor --> Code Style --> Manage...--> Import... to import the file. 

## 3. Style checking
For both Java Style and additional code standard, we use [CheckStyle](http://checkstyle.sourceforge.net/) to check styles in both Eclipse editor and in Build phase. 

## 4. Naming Guideline
We shoud name all things by their business meanings. The best guide is using a domain-specific ubiquitous language as suggested by Domain Driven Design. Specifically, after the com.orgranization prefix(in our case, it's io.reactivesw), the first package level is a name of a microservice. For each microservice, there are domain, infrastructure, resources (for UI), and application in the next level. The "domain" means business domain. The infrastructure may have the repository implementations (the repository interface is defined in the domain model package). In a domain, we usually have business models and services. The "model" has all business entities (aggregates). The "service" has all services for this domain. 

io.reactivesw.mymicroservice -->

    domain -->
    
        model -->
        
            user -->
            
                User
                
        service -->
        
    infrastructure -->
    
        persistence -->
        
            SpringJpaUserRepository
            
    resources -->
    
        view -->
        
            UserView.html
            
    application -->  // anything involving more than one services belongs to here
        
            
For example, entityies in the 'User' aggregate root in 'identityacces' may be defined in a pakcage named 'io.reactivesw.identityaccess.domain.user'. 

As another example, HTML views of of 'identityaccess' may be defined in a package named 'io.reactivesw.identityaccess.resources.view'. 

