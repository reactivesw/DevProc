#lombok setup
## 1. Introduction
From lombok project on github:

>Project Lombok makes java a spicier language by adding 'handlers' that know how to build and compile simple, boilerplate-free, not-quite-java code. 

## 2. IDEA Plugin
### 2.1 install lombok plugin for IDEA
Intellij Idea -> Preferences(command + ,) -> Plugins -> type in `lombok` -> Search in Repositories -> install -> restart IDEA

### 2.2 config lombok plugin

Enabling annotation processing will make it work

But if you are on a Mac, make sure you enable annotation processing(tick the checkbox) from both the places available.

1. Intellij Idea -> Preferences -> Build, Execution, Deployment -> Compiler -> Annotation Processors
2. File -> Other Settings -> Default Settings -> Build, Execution, Deployment -> Compiler -> Annotation Processors

## 3. use lombok
### 3.1 import lombok

In gradle build file, use following script to import lombok

`compile('org.projectlombok:lombok:1.16.12')`

### 3.2 use lombok
Before using lombok:
```java
public class User {
  private String name;
  private Integer age;

  public User(String name, Integer age) {
    this.name = name;
    this.age = age;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Integer getAge() {
    return age;
  }

  public void setAge(Integer age) {
    this.age = age;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }

    User user = (User) o;

    if (name != null ? !name.equals(user.name) : user.name != null) {
      return false;
    }
    return age != null ? age.equals(user.age) : user.age == null;

  }

  @Override
  public int hashCode() {
    int result = name != null ? name.hashCode() : 0;
    result = 31 * result + (age != null ? age.hashCode() : 0);
    return result;
  }         
  
  @Override
  public String toString() {
    return "User{" +
        "name='" + name + '\'' +
        ", age=" + age +
        '}';
  }
}
```

Use lombok:
```java
@Getter
@Setter
@ToString
@EqualsAndHashCode
@AllArgsConstructor
public class User {
  private String name;
  private Integer age;
}
```

## 4. lombok features
you can find the introduction from [lombok project](https://projectlombok.org/features/index.html)
