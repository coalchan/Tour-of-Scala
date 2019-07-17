# 类型推断

Scala 编译器经常可以推断出一个表达式的类型，所以你可以不必显示地进行声明。

## 类型省略

```scala
val businessName = "Montreux Jazz Café"
```

编译器可以发现 `businessName` 是一个字符串。对于方法，也是类似的：

```scala
def squareOf(x: Int) = x * x
```

编译器可以推断出返回类型是 `Int` ，所以不需要显式的返回类型。

对于递归方法，编译器不能推断出它的返回类型。下面的这段程序正是这个原因导致了编译失败：

```scala
def fac(n: Int) = if (n == 0) 1 else n * fac(n - 1)
```

同样地，在调用[多态方法](polymorphic-methods.md)或者实例化[泛型类](generic-classes.md)时，也不需要强制明确类型参数。Scala编译器会从上下文和实际的方法（或者构造器）中的参数类型推断出缺失的类型参数。

下面有2个例子：

```scala
case class MyPair[A, B](x: A, y: B);
val p = MyPair(1, "scala") // type: MyPair[Int, String]

def id[T](x: T) = x
val q = id(1)              // type: Int
```

编译器使用 `MyPair` 的参数类型确定了 `A` 和 `B` 的类型，后面 `x` 的类型也是一样的。

## 参数

编译器永远不会推断方法的参数类型。然而，在某些特定例子中，当一个匿名函数作为参数传入时，是可以推断出函数的参数类型的。

```scala
Seq(1, 3, 4).map(x => x * 2)  // List(2, 6, 8)
```

`map` 的参数是 `f: A => B` 。因为我们将整数放入 `Seq` ，所以编译器知道 `A` 是 `Int` （即 `x` 是一个整数）。因此，编译器可以从 `x * 2` 推断出 `B` 是 `Int` 类型。

## 何时不依赖于类型推断

一般认为，对于暴露在公共 API 中的成员进行显式声明类型更具可读性。因此，我们推荐对于那些将暴露给你的用户的 API ，进行显式声明类型。

同时，类型推断有时会推断出一个尤其特殊的类型。假如我们这样写：

```scala
var obj = null
```

那么我们不能继续这样的重新赋值：

```scala
obj = new AnyRef
```

这样不会通过编译，因为 `obj` 的类型推断是 `Null` ，而该类型的唯一值是 `null` ，所以不可能分配一个不同的值。