#Build Process

##Build Steps
项目中目前使用的是Gradle 3.0，每次在build项目时会走一下几步：1、运行单元测试用例；2、检查代码的测试覆盖率（目前要求的是`80%`的line覆盖率）；3、检查代码风格（目前采用的是google java的编码风格）；4、进行代码检查（分别使用了findbug和pmd）
###在项目中，如果有不需要检查或者测试的文件或目录，请在自己的项目中exclude掉。

## 1&2，单元测试以及覆盖率的检测
项目约定使用spock测试框架，[参见](https://github.com/reactivesw/DevProc/blob/master/Build/Guides/Spock.md)
代码测试覆盖率由Jacoco完成，并输出html格式的报告。[参见](https://github.com/palantir/gradle-jacoco-coverage)
使用方式：将[resources/code_analyze_and_test](code_analyze_and_test)文件夹拷到你的项目根目录下，在`build.gradle`中添加一下代码

```
apply from: 'code_analyze_and_test/code_unit_test.gradle'

buildscript {
    dependencies {
        classpath('com.palantir:jacoco-coverage:0.4.0')
    }
}
```
这样就可以完成代码测试的运行以及代码覆盖率的检查了。
如果需要设置哪些文件不进行检测和测试，可以在`code_analyze_and_test/code_unit_test.gradle`文件中进行设置，具体设置方法可以参见里面的示例


## Java代码风格(CheckStyle)
项目约定使用[Google Java Style](http://checkstyle.sourceforge.net/reports/google-java-style.html),可以将其导入到eclipse中，在编码的时候格式化代码，即可保持风格一致。

## Findbug
参见[官网](http://findbugs.sourceforge.net/)

## pmd
参见[Pmd的在线文档](https://pmd.github.io/pmd-5.5.1/index.html)


以上checkstyle、findbug、pmd的使用方式：

将[resources/code_analyze_and_test](code_analyze_and_test)文件夹拷到你的项目根目录下，并在`build.gradle`中添加
```
apply from: 'code_analyze_and_test/code_analyzer.gradle'
```
这样就完成了代码的风格、bug等的检查了。

##使用Sample
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


###以上四步中，只要有一步的检查没有通过，都会导致build失败，所以在项目中，如果有不需要检查或者测试的文件或目录，请在自己的项目中exclude掉。如果build失败，可以在terminal中查看build结果，也可以在相应的report目录查看各个检查的结果，以便修改。
###同时，可以预先在本机build成功之后，再行提交代码到github，这样会提高开发效率。


## Build 方式：
```
gradle clean build
```
