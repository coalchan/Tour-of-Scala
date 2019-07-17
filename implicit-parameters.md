# 隐式参数

一个方法可以拥有隐式参数列表，它由_implicit_关键字在参数列表的开头作为标记。如果这个参数列表的参数没有正常传递的话， Scala 会去查找一个正确类型的隐式值，如果找到了，则会自动传递。

Scala 查找找些参数的位置分以下2种类型：

- 在带有隐式参数块的方法被调用时，Scala 首先会查找可以直接访问（不需要加前缀）的隐式定义和隐式参数。
- 然后会查找与隐式候选类型相关联的所有伴生对象中标记为 implicit 的成员。

关于 Scala 查找隐式值的位置，在[the FAQ](https://docs.scala-lang.org/tutorials/FAQ/finding-implicits.html)中有更加详细的讲解。

下面的例子中我们定义了一个方法 `sum` ，通过使用 `Monid` 的 `add` 和 `unit` 的操作来计算列表中元素的和。注意下面的隐式值不能在顶层。

```scala
abstract class Monoid[A] {
  def add(x: A, y: A): A
  def unit: A
}

object ImplicitTest {
  implicit val stringMonoid: Monoid[String] = new Monoid[String] {
    def add(x: String, y: String): String = x concat y
    def unit: String = ""
  }
  
  implicit val intMonoid: Monoid[Int] = new Monoid[Int] {
    def add(x: Int, y: Int): Int = x + y
    def unit: Int = 0
  }
  
  def sum[A](xs: List[A])(implicit m: Monoid[A]): A =
    if (xs.isEmpty) m.unit
    else m.add(xs.head, sum(xs.tail))
    
  def main(args: Array[String]): Unit = {
    println(sum(List(1, 2, 3)))       // uses IntMonoid implicitly
    println(sum(List("a", "b", "c"))) // uses StringMonoid implicitly
  }
}
```

这里 `Monid` 类定义了一个方法 `add` ，用来组合一对 `A` 类型的值并且返回一个 `A` 类型的值，另外定义了一个 `unit` 方法用来创建一个具体的 `A` 类型的值。

为了展示隐式参数是如何起作用的，我们首先定义了针对字符串和整数的 `Monoid` ，分别是 `StringMonoid` 和 `IntMoniod` 。关键字 `implicit` 表明了相关的对象可以被隐式使用。

方法 `sum` 接受一个 `List[A]` 并且返回一个 `A` ，它从 `unit` 方法中获取一个 `A` 类型的初始值，然后使用 `add` 方法，对于列表中的每一个 `A` 类型的值进行组合。这里我们让参数 `m` 成为隐式的，意味着在调用方法的时候仅需要提供 `xs` 参数，其中前提是 Scala 可以查找到一个隐式的 `Monoid[A]` 来用于隐式的 `m` 参数。

在 `main` 方法中我们调用了 `sum` 两次，但是仅仅提供了 `xs` 参数。 Scala 会在上文提到的范围中寻找一个隐式值。第一次调用 `sum` 方法传递了一个 `List[Int]` 给 `xs` ，意味着 `A` 是 `Int` 。隐式参数列表 `m` 被忽略了，所以 Scala 会去查找一个 `Monoid[Int]` 类型的隐式值。首先应用第一条查找规则

> 在带有隐式参数块的方法被调用时， Scala 首先会查找可以直接访问（不需要加前缀）的隐式定义和隐式参数。

`intMonoid` 是一个隐式的定义，且可以在 `main` 方法中直接访问，并且是正确的类型，所以会自动地传递给 `sum` 方法。

第二次调用 `sum` 时传递了一个 `List[String]` ，意味着 `A` 是 `String` 。此时隐式查找的方式会和 `Int` 一样，但这次查找到的是 `stringMonoid` ，并且自动传递给参数 `m` 。

该程序输出如下

```
6
abc
```