# 单例对象

对象是只有一个实例的类。当它被引用的时候才会被惰性创建，就像一个惰性的 `val` 。

作为顶层值，对象是单例的。

不论作为封闭类成员还是本地值，它表现得完全像一个惰性的 `val` 。

# 定义一个单例对象

对象是一个值。对象的定义跟类差不多，只不过使用的关键字是 `object` ：

```scala
object Box
```

下面是带方法的对象的例子：

```
package logging

object Logger {
  def info(message: String): Unit = println(s"INFO: $message")
}
```

方法 `info` 可以在程序的任何位置导入使用。创建这样的工具方法是单例对象的常见用法。

让我们看下如何在另外一个包里使用 `info` 方法：

```
import logging.Logger.info

class Project(name: String, daysToComplete: Int)

class Test {
  val project1 = new Project("TPS Reports", 1)
  val project2 = new Project("Website redesign", 5)
  info("Created projects")  // Prints "INFO: Created projects"
}
```

因为使用了导入语句 `import logging.Logger.info` ，所以 `info` 在这里是可见的。

导入语句对于被导入的对象来说需要一个“可靠的路径”，而对象就是一个“可靠的路径”。

注意：如果一个对象不是处于顶层，而是嵌套在其他的类或者对象当中，那么这个对象则与其他成员一样是“路径依赖”的。也就是说，如果给定两种类型的饮料： `class Milk` 和 `class OrangeJuice` ，另外有一个类成员 `object NutritionInfo` ，它依赖于相对于它封闭的实例——牛奶或者橙汁，这种情况下 `milk.NutritionInfo` 和 `oj.NutritionInfo` 则是完全不同的东西。

## 伴生对象

与类同名的对象被称为伴生对象。相对地，这个类也是该对象的伴生类。一个伴生类或者对象可以互相访问同伴的私有成员。虽然伴生对象的方法不属于其伴生类的实例，但是我们可以在这个类中使用它们。

```
import scala.math._

case class Circle(radius: Double) {
  import Circle._
  def area: Double = calculateArea(radius)
}

object Circle {
  private def calculateArea(radius: Double): Double = Pi * pow(radius, 2.0)
}

val circle1 = new Circle(5.0)

circle1.area
```

类 `class Circle` 有一个明确声明的成员 `area` ，它属于该类所有的实例，而单例 `object Circle` 有一个方法 `calculateArea` ，它对于所有的实例也都是可用的。

每个伴生对象都可以拥有工厂方法：

```scala
class Email(val username: String, val domainName: String)

object Email {
  def fromString(emailString: String): Option[Email] = {
    emailString.split('@') match {
      case Array(a, b) => Some(new Email(a, b))
      case _ => None
    }
  }
}

val scalaCenterEmail = Email.fromString("scala.center@epfl.ch")
scalaCenterEmail match {
  case Some(email) => println(
    s"""Registered an email
       |Username: ${email.username}
       |Domain name: ${email.domainName}
     """)
  case None => println("Error: could not parse email")
}
```

对象 `Email` 包含了一个工厂方法 `fromString` ，它接收一个 String 来创建一个 `Email` 实例。这里返回了 `Option[Email]` 以防转换错误。

注意：如果一个类或者对象具有伴生对象或者伴生类，那么必须要定义在同一个文件当中。如果要在交互式解释器（REPL）当中定义伴生类和伴生对象的话，要么把它们定义在同一行，要么进入 `:paste` 模式。

## Java 程序员需要注意

Java 中的 `static` 成员，在 Scala 中被设计为一个伴生对象的普通成员。如果在 Java 代码中使用一个伴生对象，会在其伴生类中使用 `static` 修饰符来定义成员。这被称为_静态转发_。即使你并没有定义一个伴生类，这也会自动发生。