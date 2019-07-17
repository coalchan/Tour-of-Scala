# 多态方法

Scala 中的方法可以通过类型和值来进行参数化。它的语法和泛型类是接近的。类型参数是用方括号括起来，而值参数是用圆括号括起来。

下面是示例：

```scala
def listOfDuplicates[A](x: A, length: Int): List[A] = {
  if (length < 1)
    Nil
  else
    x :: listOfDuplicates(x, length - 1)
}
println(listOfDuplicates[Int](3, 4))  // List(3, 3, 3, 3)
println(listOfDuplicates("La", 8))  // List(La, La, La, La, La, La, La, La)
```

方法 `listOfDuplicates` 接受一个类型参数 `A` 以及值参数 `x` 和 `length` 。值 `x` 是 `A` 类型的。如果 `length < 1` 我们会返回一个空的列表。否则我们会通过递归调用来将 `x` 加到列表副本的前面。（注： `::` 意味着将左边的元素加入到右边列表的前面。）

第一次调用的时候，我们通过写下 `[Int]` 从而显式提供了类型参数。因此第一个参数必定为一个 `Int` 且返回类型是 `List[Int]` 。

第二次调用表明你不必总是显式地提供类型参数。编译器一般可以根据上下文或者值参数的类型来推断出来。这个例子当中， `"La"` 是一个 `String` 所以编译器知道 `A` 必定为 `String` 。