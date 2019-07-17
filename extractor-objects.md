# 提取器对象

一个提取器对象会有一个 `unapply` 方法。 `apply` 方法类似于接受参数并创建对象的构造器，反过来 `unapply` 则是接受一个对象并试图返回原来的参数。这一点在模式匹配和偏函数中经常使用。

```scala
import scala.util.Random

object CustomerID {

  def apply(name: String) = s"$name--${Random.nextLong}"

  def unapply(customerID: String): Option[String] = {
    val stringArray: Array[String] = customerID.split("--")
    if (stringArray.tail.nonEmpty) Some(stringArray.head) else None
  }
}

val customer1ID = CustomerID("Sukyoung")  // Sukyoung--23098234908
customer1ID match {
  case CustomerID(name) => println(name)  // prints Sukyoung
  case _ => println("Could not extract a CustomerID")
}
```

`apply` 方法由一个 `name` 创建了一个 `CustomerID` 字符串。 `unapply` 则反过来获得了 `name` 。当我们调用 `CustomerID("Sukyoung")` 时，其实是 `CustomerID.apply("Sukyoung")` 的一种简写形式。而当我们调用 `case CustomerID(name) => println(name)` 时，则实际调用的是 `unapply` 方法。

另外 `unapply` 方法也可以用来分配一个值。

```scala
val customer2ID = CustomerID("Nico")
val CustomerID(name) = customer2ID
println(name)  // prints Nico
```

这个其实和 `val name = CustomerID.unapply(customer2ID).get` 是等价的。

```scala
val CustomerID(name2) = "--asdfasdfasdf"
```

如果没有匹配上，则抛出一个 `scala.MatchError`：

```scala
val CustomerID(name3) = "-asdfasdfasdf"
```

关于 `unapply` 的返回类型有以下几种选择：

- 如果仅仅是一个判断，则返回一个 `Boolean` 。例如 `case even()` 。
- 如果要返回 `T` 类型的单个子值，则返回一个 `Option[T]` 。
- 如果要返回多个子值如 `T1,...,Tn` ，则可以把它们组合起来放在一个可选的元组 `Option[(T1,...,Tn)]` 当中。

有时候子值的数量不固定，我们则可以返回一个序列。因此这时候，你就可以通过定义 `unapplySeq` 的方式来返回一个 `Option[Seq[T]]` ，这种用法常见于 `case List(x1, ..., xn)` 模式中。