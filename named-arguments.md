# 带名参数

调用方法时，可以使用参数名给参数带上标签，正如：

```scala
def printName(first: String, last: String): Unit = {
  println(first + " " + last)
}

printName("John", "Smith")  // Prints "John Smith"
printName(first = "John", last = "Smith")  // Prints "John Smith"
printName(last = "Smith", first = "John")  // Prints "John Smith"
```

注意，带名参数的顺序可以重新调整。然而，如果有些参数是带名的，有些则不是，那么不带名的参数必须在最前面，并且是按照方法定义中参数的顺序出现。

```scala
printName(last = "Smith", "john") // error: positional after named argument
```

注意带名参数不适用于调用 Java 方法。