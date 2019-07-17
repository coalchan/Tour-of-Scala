# 包和导入

Scala 使用包来创建命名空间，允许你对程序进行模块化设计。

## 创建包

通过在Scala文件顶部声明一个或者多个包名来创建包。

```scala
package users

class User
```

一般而言包的命名是和包含 Scala 文件的目录相同的，然而实际上 Scala 并不关心文件布局。一个 sbt 项目中 users 包的目录结构可能如下所示：

```
- ExampleProject
  - build.sbt
  - project
  - src
    - main
      - scala
        - users
          User.scala
          UserProfile.scala
          UserPreferences.scala
    - test
```

注意 users 目录是怎样包含在 Scala 目录中，以及是如何包含了多个 Scala 文件的。包中的每个 Scala 文件都可以有相同的包声明。另外有一种声明包的方式是使用花括号：

```scala
package users {
  package administrators {
    class NormalUser
  }
  package normalusers {
    class NormalUser
  }
}
```

正如你所见，该方式允许进行包嵌套，且提供了对于作用域和封装方面更强的控制力。

包名应该全部小写，另外如果是一个拥有网站的组织来开发代码，那应该按照以下的格式约定： `<顶级域名>.<域名>.<项目名>` 。例如，如果谷歌有个项目叫做 `SelfDrivingCar` ，那么包名应该如下：

```scala
package com.google.selfdrivingcar.camera

class Lens
```

这一般会对应到下面的目录结构： `SelfDrivingCar/src/main/scala/com/google/selfdrivingcar/camera/Lens.scala` 。

## 导入

导入语句用于访问其他包中的成员（如类、特质、函数等）。访问相同包中的成员不需要导入语句。导入语句有下面几种方式可选：

```scala
import users._  // import everything from the users package
import users.User  // import the class User
import users.{User, UserPreferences}  // Only imports selected members
import users.{UserPreferences => UPrefs}  // import and rename for convenience
```

Scala 中不同于 Java 的一点是导入语句可以被用在任何地方：

```scala
def sqrtplus1(x: Int) = {
  import scala.math.sqrt
  sqrt(x) + 1.0
}
```

如果存在包冲突且需要从项目的根目录导入某些东西的时候，可以在包前面加上 `_root_` ：

```scala
package accounts

import _root_.users._
```

注意： `scala` 和 `java.lang` 包以及 `object Predef` 是默认导入的。