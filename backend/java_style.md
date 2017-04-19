# Java Code Standard 

## 1. Basic Style
We use [Google Java Style](https://google.github.io/styleguide/javaguide.html) published on March 21, 2014. It has a [Chinese version](http://blog.mosil.biz/2014/05/java-style-guide/).

## 2. IntelliJ Idea IDE Settings

### 2.1. Google Java Style
This is the [Google Java sytle settings for IntelliJ](https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml). In IntelliJ IDEA, using Preferences --> Editor --> Code Style --> Manage...--> Import... to import the file.

After import, go to `Preferences` -> `Editor` -> `Code Style` -> `Java`, select the google scheme import above, go to `Imports` tab, edit `Import Layout` as following:

```java
import static all other imports
<blank line>
import com.*
<blank line>
import com.braintreegateway.*
<blank line>
import io.*
<blank line>
import lombok.*
<blank line>
import org.*
<blank line>
import java.*
<blank line>
import javax.*
<blank line>
import all other imports
<blank line>
```

### 2.2. No Auothor and Date in Java Class File Header
Don't put author name and creation date in class file. To change the default IDE setting, in Preferences --> Editor --> File and Code Templates --> Includes Tab --> File Header, delete the autho and date, the file header only has empty comments as the following: 

```java
/**
 * 
 */
```

Every Java class file should have comments describing the class purpose/functions.  

### 2.3. Show Quick Documentation
IN preference --> Editor --> General, in "Ohter" group, check checkbox "Show quick documentation on mouse move". 

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

