# Test and Build 参考指南之一 Test

## Spock and Groovy Setup

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

## Test中的注意事项

### Specification
Specification是spock test的基类（抽象类），所有的test都需要继承Specification。  
测试的时候尽量覆盖所有条件分支（如if...else）以及异常分支。

### Spring boot下test创建应用上下文：
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
**由于test的时候不能对数据库操作（使用Mock），以及远程build的时候无法连接数据库，所以有数据库连接及mock测试的时候不能使用boot。**

### 异常分支测试
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

### 测试数据的问题
Test过程中可能需要读写数据库等数据操作，为了避免影响生产环境，防止脏数据的产生，所有的数据操作都需要通过Mock来进行测试，而不是直接连接Database。
