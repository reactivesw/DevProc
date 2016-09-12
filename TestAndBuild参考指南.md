# Test and Build 参考指南

我们的test和build都基于gradle，所以在开始之前，请确认你的环境已安装了gradle并且project是gradle工程。  
Test和build主要包括以下几个部分：
* Test
* Local Build
* Remote Build
* Publish and Process

## Test

### Spock and Groovy Setup

* 1) 在IDE中安装spock和groovy插件

* 2) 在`build.gradle`文件中加入
```
apply plugin: 'groovy'
```
并在dependencies中加入testCompile依赖
```
dependencies {
  testCompile('org.springframework.boot:spring-boot-starter-test')
  testCompile('org.spockframework:spock-spring:1.0-groovy-2.4')
}
```

* 3) 在project目录下建立test目录`src/test/groovy`。

* 4) 在test目录下建立与java文件对应的groovy测试用例。  
test文件的package尽量与java文件的package一致。

> **IDE中spock和groovy版本与gradle版本兼容性的问题：**  
由于eclipse集成的groovy版本为2.3，而gradle 2.13默认apply的groovy版本为2.4，我们在添加依赖时用的是`spock-spring:1.0-groovy-2.4`，所以在IDE中会出现`Spock 1.0.0-groovy-2.4 is not compatible with Groovy 2.3.7`的错误。  
这个错误属于IDE的错误，gradle build的时候会自动引入2.4的版本，所以并不会影响build，可以忽略。

### Test中的注意事项

#### Specification
Specification是spock test的基类（抽象类），所有的test都需要继承Specification。  
测试的时候尽量覆盖所有条件分支（如if...else）以及异常分支。

#### Spring boot下test创建应用上下文：
```
@ContextConfiguration(classes=[ShoppingCartServiceStarter.class])
```
放在groovy的class声明之前，可以将编译运行时所需要的bean，如@Autowired，@Resource等加载到test case。
例如：
```
@ContextConfiguration(classes=[SampleServiceStarter.class])
class SampleServiceTest extends Specification {
}
```

#### 异常分支测试
spock test可以测试异常分支，可以通过thrown()方法捕获并判断异常信息。
```
def "sample test" () {
  when:
  stack.pop()
  then:
  EmptyStackException e = thrown()
  e.cause == null
}
```
如最常见的RuntimeException
```
def "sample test" () {
  when:
  thrown new StatusRuntimeException(status)
  then:
  RuntimeException e = thrown()
  e.message == "ERROR"
}
```
spock还提供了notThrown()的方式。

#### 测试数据的问题
Test过程中可能需要读写数据库等数据操作，为了避免影响生产环境，防止脏数据的产生，所有的数据操作都需要通过Mock来进行测试，而不是直接连接Database。

## Local Build

这部分基本上已经在code_analyze_and_test中集成，我们只需要在`build.gradle`文件引入，然后根据情况修改其中的设置就可以了，project检测可直接参考Code analyze and test部分。
主要包括以下几个部分：
* Unit test and code coverage
* Check Style
* Findbugs
* PMD
* Code analyze and test

### Unit test and code coverage

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

### Check Style

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

### Findbugs

* 1) 在`build.gradle`文件中添加
```
apply plugin: "pmd"
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

### PMD

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

### Code analyze and test

这部分集成了unit test，code coverage，check style，findbugs和pmd检测。

* 1) 将`DevProc/code_analyze_and_test`文件目录拷贝到project根目录。

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

## Remote Build

### Github

上传project到github上。  
application properties设置尽量使用sample数据。  
**注意：一定要整理好project中的隐私数据，避免将敏感数据暴露在外。**

### Travis

* 1) 在project根目录下创建`.travis.yml`文件
```
sudo: required
language: java
jdk: oraclejdk8

services:
  - docker
script:
  - gradle clean
  - gradle wrapper
  - ./gradlew build buildDocker --info

after_success:
  - bash <(curl -s https://codecov.io/bash) -t 76aa4e85-79ee-4528-8161-b0120af54a59


after_script:
  - docker login --username="" --password="";
    docker push go6d/customer_authentication;
```

* 2) 在project根目录下创建`codecov.yml`文件
```
codecov:
  notify:
    require_ci_to_pass: yes

coverage:
  precision: 2
  round: down
  range: "70...100"

  status:
    project: yes
    patch: yes
    changes: no

  parsers:
     gcov:
       branch_detection:
         conditional: yes
         loop: yes
         method: no
         macro: no

comment:
  layout: "header, diff"
  behavior: default
  require_changes: no
```

* 3) 将project更新push到github上。
 > 由于travis－ci的同步是由github的commit-push触发，所以如果project完全提交后才开启同步开关的话，可能会出现travis-ci的repository并没有拉取的情况。建议在同步开关开启后，再进行最后一次commit。

* 4) 登录`https://travis-ci.org/`，打开project同步开关。
 - 用github账户登录，然后可以看到所有的repository列表
 - 点“＋”号后，可以看到同步提示
 - 选择左侧organization，按照提示，找到需要同步的project打开同步开关
 - 如果你的repository同步开关已经开启，可以忽略这步操作
 > 只有在同步开关开启，且github上的project根目录下同时存在`.travis.yml`和`codecov.yml`文件时，travis－ci才会自动从github上同步拉取project并build。

* 5) gradle wrapper
 由于travis-ci的版本兼容性问题，本地build成功可能push上去后build会失败。  
 我们需要在本地执行`gradle wrapper`后将project根目录下的gradle路径下的文件同样上传到github。
 > 上传的时候需要把`gradle/wrapper/`下的jar文件上传，如果你的project下的`.gitignore`文件中屏蔽了jar文件的话，可以在本地暂时放开jar限制然后上传。

## Publish and Process
TBD
