#Build Process

##Build Steps
项目中目前使用的是Gradle 3.0，每次在build项目时会走一下几步：1、运行单元测试用例；2、检查代码的测试覆盖率（目前要求的是`80%`的line覆盖率）；3、检查代码风格（目前采用的是google java的编码风格）；4、进行代码检查（分别使用了findbug和pmd）
###在项目中，如果有不需要检查或者测试的文件或目录，请在自己的项目中exclude掉。

## 1&2，单元测试以及覆盖率的检测
项目约定使用spock测试框架，[参见](https://github.com/reactivesw/DevProc/blob/master/Build/Guides/Spock.md)
代码测试覆盖率由Jacoco完成，并输出html格式的报告。[参见](https://github.com/palantir/gradle-jacoco-coverage)
使用方式：在`build.gradle`中添加一下代码

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
