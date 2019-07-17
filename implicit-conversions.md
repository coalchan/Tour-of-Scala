# 隐式转换

从类型 `S` 到类型 `T` 的隐式转换，由一个拥有函数类型 `S => T` 的隐式值，或者一个可转换为指定类型的隐式方法所定义。

隐式转换适用于以下2中场景：

- 如果一个表达式 `e` 是 `S` 类型的，且 `S` 类型不能转换成表达式所期望的 `T` 类型。
- 在一个 `S` 类型的 `e` 的选择器 `e.m` 中，如果 `m` 不是 `S` 的成员。

第一种场景中，会去查找一个适用于 `e` 且其返回类型可以转换为 `T` 的转换 `c` 。

第二种场景中，则会去查找一个适用于 `e` 且其返回结果包含了一个名为 `m` 的成员的转换 `c` 。

如果隐式方法 `List[A] => Ordered[List[A]]` 和 `Int => Ordered[Int]` 都在作用域内，那么对于下面两个 `List[Int]` 类型的列表的操作是合法的：

```
List(1, 2, 3) <= List(4, 5)
```

隐式方法 `Int => Ordered[Int]` 由 `scala.Predef.intWrapper` 自动提供。下面提供了一个 `List[A] => Ordered[List[A]]` 的隐式方法的实现样例：

```scala
import scala.language.implicitConversions

implicit def list2ordered[A](x: List[A])
    (implicit elem2ordered: A => Ordered[A]): Ordered[List[A]] =
  new Ordered[List[A]] { 
    //replace with a more useful implementation
    def compare(that: List[A]): Int = 1
  }
```

隐式导入的对象 `scala.Predef` 声明了几个预定义的类型（比如 `Pair` ）和方法（比如 `assert` ），以及一些隐式转换。

例如，在调用一个Java方法且需要一个 `java.lang.Integer` 时，你可以传入一个 `scala.Int` 来代替。这是因为 `Predef` 中包含了以下的隐式转换：

```scala
import scala.language.implicitConversions

implicit def int2Integer(x: Int) =
  java.lang.Integer.valueOf(x)
```

因为随意使用隐式转换可能出现难以预料的问题，所以在编译隐式转换的定义时编译器会发出警告。

可以通过以下任意一种方法来关闭警告：

- 导入 `scala.language.implicitConversions` 到隐式转换定义的作用域中。
- 给编译器带上参数 `-language:implicitConversions`

这样在做转换时，编译器将不会发生警告。