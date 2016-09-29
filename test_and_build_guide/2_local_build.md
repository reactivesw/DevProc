# Test and Build 参考指南之二 Local Build

这部分基本上已经在code_analyzer_test中集成，我们只需要直接参考第一部分Code analyzer and test，后面为各个部分的详细说明。
主要包括以下几个部分：
* Code analyzer and test
* Unit test and code coverage
* Check Style
* Findbugs
* PMD

## 1. Code analyzer and test

这部分集成了unit test，code coverage，check style，findbugs和pmd检测。

* 1) 拉取远程code_analyzer_test仓库作为本地仓库的submodule
在本地project仓库下执行
```
git submodule add https://github.com/reactivesw/code_analyzer_test.git
git submodule update --init --recursive
```
习惯用ssh的可以用
```
git submodule add git@github.com:reactivesw/code_analyzer_test.git
git submodule update --init --recursive
```
这样在project路径下会出现文件`.gitmodules`和`code_analyzer_test`，提交project文件的时候，把生成的这两个文件一起push上去
> code_analyzer_test为公共文件，不需要修改。 git和submodle流程可以参考[git_workflow.md](https://github.com/reactivesw/development_process/blob/master/git_workflow.md)

* 2) 在project根目录下新建文件夹`code_analyzer_test_local`。
新建文件`code_analyzer.gradle`，文件内容根据project情况修改exclude:
```
apply plugin: 'checkstyle'
apply plugin: 'pmd'
apply plugin: 'findbugs'

// apply all configurations
apply from:'code_analyzer_test/code_analyzer_config.gradle'

ext {
    application_java = 'io/reactivesw/customerweb/Application.java'
}

/*************checkstyle(use google java style)***************/
checkstyle{
    //exclude the package you do not want to check
}

/*************PMD(Project Manager Design)***************/
tasks.withType(Pmd) {
    //exclude the package you do not want to check
    exclude application_java
}

/*************find bug***************/
tasks.withType(FindBugs) {
    //exclude the package you do not want to check
    // findBugs doesn't work if the filter is empty. Comment all if nothing to exclude
    // classes = classes.filter {
    //     !it.path.contains(grcp_folder)
    // }
}
```
新建文件`code_test_coverage.gradle`，文件内容根据project情况修改exclude:
```
// for spock unit test
apply plugin: 'groovy'
dependencies {
  testCompile('org.springframework.boot:spring-boot-starter-test')
  testCompile('org.spockframework:spock-spring')
}

// for code coverage
apply plugin: 'com.palantir.jacoco-coverage'
apply from:'code_analyzer_test/test_coverage_config.gradle'

// config of coverage check
// see document: https://github.com/palantir/gradle-jacoco-coverage
jacocoCoverage {
  // Scopes can be exempt from all coverage requirements by exact scope name or scope name pattern.
  fileThreshold 0.0, "Application.java"
  //    packageThreshold 0.0, "org/company/module"
  //    fileThreshold 0.0, ~".*Test.java"
}

//exclude the folders we do not want to check
jacocoTestReport {
  afterEvaluate {
    classDirectories = files(classDirectories.files.collect {
      fileTree(dir: it, exclude: [
        'io/reactivesw/customerauthentication/grpc/*'
      ])
    })
  }
}
```

* 3) 在project的builld.gradle文件中引入
在`buildscript`的`dependencies`中添加:
```
classpath('com.palantir:jacoco-coverage:0.4.0')
```
并在文件的最后引入gradle文件:
```
// these two files are for code analyzer, unit test and code coverage check
apply from: 'code_analyzer_test_local/code_analyzer.gradle'
apply from: 'code_analyzer_test_local/code_test_coverage.gradle'
```

* 4) `gradle clean build`，并根据build结果和report报告对project进行规范和优化。

## 2. Unit test and code coverage

* 1) 依照Test为project创建各个unit test。

* 2) 在`build.gradle`中加入
```
apply plugin: "com.palantir.jacoco-coverage"
```
并加入code coverage检测的设置，可以在exclude中加入不需要检测的文件或目录
```
jacocoTestReport {
  afterEvaluate {
    classDirectories = files(classDirectories.files.collect {
      fileTree(dir: it, exclude: [
        'io/reactivesw/shoppingcart/ShoppingCartServiceStarter*',
        'io/reactivesw/shoppingcart/grpc/*'
      ])
    })
  }
}
```
以及覆盖率的配置，我们的覆盖率要求为80%
```
jacocoCoverage { fileThreshold 0.8 }
```
> 这部分gradle文件在`code_analyze_and_test`已经集成，我们只用根据project需要在`code_unit_test.gradle`进行修改。

## 3. Check Style

* 1) 在IDE中导入code style文件：`Preferences... > Java > Code Style > Formatter`。我们选用的是google

* 2) 按照规范组织Import的顺序：`Preferences... > Java > Code Style > Organize Imports`。import顺序为：
```
com
io
org
java
javax
```

* 3) 每次保存java文件的时候执行formatter：`右键 > Source > Format`，快捷键`Shift+Command+F`。

* 4)在`build.gradle`文件中添加
```
apply plugin: "checkstyle"
```
并加入check style设置
```
checkstyle {
  toolVersion='6.15'
  ignoreFailures = false
  sourceSets = [sourceSets.main]
  configFile = 'code_analyze_and_test/config/checkstyle/checkstyle.xml' as File
  //exclude the package you do not want to check
}
```
project中有自动生成或者不需要style检验的，可以将文件或路径加到exclude中，如
```
//exclude the package you do not want to check
checkstyleMain.exclude 'io/reactivesw/shoppingcart/grpc/*'
```
> 这部分gradle文件在`code_analyze_and_test`已经集成，我们只用根据project需要在`code_analyzer.gradle`文件中修改exclude部分就可以了。

## 4. Findbugs

* 1) 在`build.gradle`文件中添加
```
apply plugin: "findbugs"
```
并加入设置
```
findbugs {
  sourceSets = [sourceSets.main]
  ignoreFailures = false
  effort = "max"
  reportLevel = "medium"
}
tasks.withType(FindBugs) {
  //exclude the package you do not want to check
  classes = classes.filter {
    !it.path.contains('io/reactivesw/shoppingcart/grpc/')
  }
  reports {
    xml.enabled false
    html.enabled true
    html { destination "build/reports/findbugs/findbugs.html" }
  }
}
```
不需要检测的目录设置如
```
classes = classes.filter {
  !it.path.contains('io/reactivesw/shoppingcart/grpc/')
}
```
> `!it.path.contains`表示不包括的路径，经试验发现仅支持具体路径，不支持模糊匹配。需要模糊匹配，可以使用exclude或者excludeFilter（需要定义excludeFilter.xml文件）。

* 2) 检查结果可以查看`build/reports/findbugs/findbugs.html`。

> 这部分gradle文件在`code_analyze_and_test`已经集成，我们只用根据project需要在`code_analyzer.gradle`文件中修改exclude部分就可以了。

## 5. PMD

* 1) 定义PMD规则。  
`code_analyze_and_test/config/pmd/rulesets`路径下包括了所有PMD规范，`code_analyze_and_test/config/pmd/ruleset.xml`文件则定义了project执行PMD检测时对各个规范的设置。有不需要的规范，可以在`ruleset.xml`文件中找到对应的项，然后加上exclude。如：
```
<rule ref="code_analyze_and_test/config/pmd/rulesets/controversial.xml">
  <exclude name="AtLeastOneConstructor" />
</rule>
```

* 2) 在`build.gradle`文件中添加
```
apply plugin: "pmd"
```
并加入设置
```
pmd.toolVersion='5.5.0'
pmd  {
  ignoreFailures=false
  ruleSetFiles = files("code_analyze_and_test/config/pmd/ruleset.xml")
  sourceSets = [sourceSets.main]
}
tasks.withType(Pmd) {
  exclude 'io/reactivesw/shoppingcart/grpc/*'
}
```
不需要检测的文件或者目录设置，如
```
exclude 'io/reactivesw/shoppingcart/grpc/*'
```

* 3) 检测报告可查看`build/reports/pmd/main.html`。

> 这部分gradle文件在`code_analyze_and_test`已经集成，我们只用根据project需要在`code_analyzer.gradle`文件中修改exclude部分就可以了。