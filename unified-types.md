# 统一类型

在 Scala 中，所有的值都有类型，包括数值和函数。下图阐述了类型层次结构的一个子集。

![](img/unified-types-diagram.svg)

## Scala 类型层次结构

[`Any`](http://www.scala-lang.org/api/2.12.1/scala/Any.html)是所有类型的超类型，也称为顶级类
型。它定义了一些通用的方法如 `equals` 、 `hashCode` 和 `toString` 。 `Any` 有两个直接子类： `AnyVal` 和 `AnyRef` 。

`AnyVal` 代表值类型。有9个预定义的非空的值类型分别是： `Double` 、 `Float` 、 `Long` 、 `Int` 、 `Short` 、 `Byte` 、 `Char` 、 `Unit` 和 `Boolean` 。 `Unit` 是不带任何意义的值类型，它仅有一个实例可以像这样声明： `()` 。所有的函数必须有返回，所以说有时候 `Unit` 也是有用的返回类型。

`AnyRef` 代表引用类型。所有非值类型都被定义为引用类型。在 Scala 中，每个用户自定义的类型都是 `AnyRef` 的子类型。如果 Scala 被应用在 Java 的运行环境中， `AnyRef` 相当于 `java.lang.Object` 。

这里有一个例子，说明了字符串、整型、布尔值和函数都是对象，这一点和其他对象一样：

```scala
val list: List[Any] = List(
  "a string",
  732,  // an integer
  'c',  // a character
  true, // a boolean value
  () => "an anonymous function returning a string"
)

list.foreach(element => println(element))
```

这里定义了一个类型 `List<Ant>` 的变量 `list` 。这个列表里由多种类型进行初始化，但是它们都是 `scala.Any` 的实例，所以可以把它们加入到列表中。

下面是程序的输出：

```
a string
732
c
true
<function>
```

## 类型转换

值类型可以按照下面的方向进行转换：

![](img/unified-types-diagram.svg)

例如：

```scala
val x: Long = 987654321
val y: Float = x  // 9.8765434E8 (note that some precision is lost in this case)

val face: Char = '☺'
val number: Int = face  // 9786
```

转换是单向，且不是编译期的。

```scala
val x: Long = 987654321
val y: Float = x  // 9.8765434E8
val z: Long = y  // Does not conform
```

你可以将一个类型转换为子类型，这点将在后面的文章介绍。

## Nothing和Null

`Nothing` 是所有类型的子类型，也称为底部类型。没有一个值是 `Nothing` 类型的。它的用途之一是给出非正常终止的信号，如抛出异常、程序退出或者一个无限循环（可以理解为它是一个不对值进行定义的表达式的类型，或者是一个不能正常返回的方法）。

`Null` 是所有引用类型的子类型（即 `AnyRef` 的任意子类型）。它有一个单例值由关键字 `null` 所定义。 `Null` 主要用于和其他 JVM 语言的互操作性，但是几乎不应该在 Scala 代码中使用。我们将在后面的章节中介绍 `null` 的替代方案。
