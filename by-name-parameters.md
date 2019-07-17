# 传名（By-name)参数

_传名参数_只有在使用时才会被计算。相对地是_传值（by-value）参数_。要使得参数可以通过传名来调用，只需要在它的类型前加上 `=>` 。

```scala
def calculate(input: => Int) = input * 37
```

传名参数的优点在于如果它们没有在函数体中使用，就不会被计算。另一方面，传值参数的优点在于它们仅会被计算一次。

这里有个例子，介绍了我们如何实现一个while循环：

```scala
def whileLoop(condition: => Boolean)(body: => Unit): Unit =
  if (condition) {
    body
    whileLoop(condition)(body)
  }

var i = 2

whileLoop (i > 0) {
  println(i)
  i -= 1
}  // prints 2 1
```

方法 `whileLoop` 使用多参数列表来接受一个条件和一个循环体。如果 `condition` 为真，则 `body` 被执行然后递归调用 whileLoop 。如果 `condition` 为假， `body` 将永远不会被计算，因为我们在 `body` 类型的前面加了 `=>` 。

现在我们传入 `i > 0` 作为我们的 `condition` 和 `println(i); i-= 1` 作为 `body` ，它的表现类似于许多语言中的标准 while 循环。

这种使得参数延迟到使用时才被计算的能力，在当参数是计算密集型的或者是一段比较耗时的代码块（比如抓取一个 URL ）的时候，可以帮助我们提高性能。