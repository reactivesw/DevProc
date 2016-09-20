# Test and Build 参考指南之二 Local Build

这部分基本上已经在code_analyze_and_test中集成，我们只需要在`build.gradle`文件引入，然后根据情况修改其中的设置就可以了，project检测可直接参考Code analyze and test部分。
主要包括以下几个部分：
* Unit test and code coverage
* Check Style
* Findbugs
* PMD
* Code analyze and test

## Unit test and code coverage

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

## Check Style

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

## Findbugs

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
> `!it.path.contains`表示不包括的路径，经试验发现仅支持具体路径，不支持模糊匹配。需要模糊匹配，可以使用exclude或者excludeFilter。

* 2) 检查结果可以查看`build/reports/findbugs/findbugs.html`。

> 这部分gradle文件在`code_analyze_and_test`已经集成，我们只用根据project需要在`code_analyzer.gradle`文件中修改exclude部分就可以了。

## PMD

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

## Code analyze and test

这部分集成了unit test，code coverage，check style，findbugs和pmd检测。

* 1) 拉取远程code_analyzer仓库作为本地仓库的submodule
在本地project仓库下执行
```
git submodule add https://github.com/reactivesw/code_analyzer.git
```
习惯用ssh的可以用
```
git submodule add git@github.com:reactivesw/code_analyzer.git
```
这样在project路径下会出现文件`.gitmodules`和`code_analyzer`，提交project文件的时候，把生成的这两个文件一起push上去
> 每个project下的`code_unit_test.gradle`和`code_analyzer.gradle`可能需要进行特殊设置（比如每个project需要exclude的文件是不一样的），这时候我们要先在code_analyzer下面创建project对应的branch（如`customer_authentication`），然后在project下面的`.gitmodules`文件中加上分支属性
```
branch = customer_authentication
```
修改后，`.gitmodules`文件如下
```
[submodule "code_analyzer"]
	path = code_analyzer
	url = https://github.com/reactivesw/code_analyzer.git
	branch = customer_authentication
```
先在code_analyzer里把分支上修改的`code_unit_test.gradle`和`code_analyzer.gradle`文件commit然后push上去（**注意一定是push到远程仓库project对应的分支上，否则会影响其他project**），push上去之后可以看到project下的`code_analyzer`文件发生了改变，再在project下把`code_analyzer`文件commit并push上去。

* 2) 在project的builld.gradle文件中引入
```
apply from: 'code_analyze_and_test/code_unit_test.gradle'
apply from: 'code_analyze_and_test/code_analyzer.gradle'
buildscript {
    repositories {
        jcenter()
        mavenLocal()
        mavenCentral()
    }
    dependencies {
        classpath('com.palantir:jacoco-coverage:0.4.0')
    }
}
```

* 3) 修改文件`code_analyze_and_test/code_unit_test.gradle`和`code_analyze_and_test/code_analyzer.gradle`，exclude掉不需要检测的文件和目录。

* 4) `gradle clean build`，并根据build结果和report报告对project进行规范和优化。