# For 表达式

Scala 为了表达序列解析提供了一种轻量级的符号。表达式的形式如 `for (enumerators) yield e` ，其中 `enumerators` 是以分号分隔的枚举器列表。一个枚举器要么是产生新变量的生成器，要么是一个过滤器。表达式对于由枚举器生成的每一个绑定的主体 `e` 进行赋值，并且返回这些值的一个序列。

下面是示例：

```scala
case class User(val name: String, val age: Int)

val userBase = List(new User("Travis", 28),
  new User("Kelly", 33),
  new User("Jennifer", 44),
  new User("Dennis", 23))

val twentySomethings = for (user <- userBase if (user.age >=20 && user.age < 30))
  yield user.name  // i.e. add this to a list

twentySomethings.foreach(name => println(name))  // prints Travis Dennis
```

这里的 `for` 循环使用了 `yield` 语句会生成一个 `List` 。因为这里的 `yield user.name` 是一个 `List[String]` 。 `user <- userBase` 是一个生成器，而 `if (user.age >=20 && user.age < 30)` 是一个守卫，用于过滤出20多岁的用户。

这里有一个更加复杂的例子，使用了2个生成器，用来计算出介于 `0` 到 `n-1` 之间所有可能的数值对，且它们的和等于给定的值 `v` ：

```scala
def foo(n: Int, v: Int) =
   for (i <- 0 until n;
        j <- i until n if i + j == v)
   yield (i, j)

foo(10, 10) foreach {
  case (i, j) =>
    println(s"($i, $j) ")  // prints (1, 9) (2, 8) (3, 7) (4, 6) (5, 5)
}

```

在这里 `n == 10` ， `v == 10` 。在第一次迭代中， `i == 0` 且 `j == 0` 则 `i + j != v` ，因而没有值生成。在 `i` 递增到 `1` 之前， `j` 会递增9次。如果没有守卫条件，则会输出如下：

```
(0, 0) (0, 1) (0, 2) (0, 3) (0, 4) (0, 5) (0, 6) (0, 7) (0, 8) (0, 9) (1, 1) ...
```

注意，表达式并不局限于列表。所有支持 `withFilter` 、 `map` 和 `flatMap` 操作的数据类型都可以用于序列解析。

你可以在表达式中省略 `yield` 。那样的话，表达式会返回 `Unit` 。这点在你需要执行具有副作用的操作时比较有用。下面是一个和之前完全类似的程序，只不过没有使用 `yield` ：

```scala
def foo(n: Int, v: Int) =
   for (i <- 0 until n;
        j <- i until n if i + j == v)
   println(s"($i, $j)")

foo(10, 10)
```