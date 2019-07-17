# 操作符

在 Scala 中，操作符也是方法。任何带有单个参数的方法可以作为_中缀操作符_来使用。例如： `+` 可以用点表达式来调用：

```
10.+(1)
```

然而，使用中缀操作符更加便于阅读：

```
10 + 1
```

## 定义和使用操作符

你可以使用任何合法的标识符来作为操作符。这包括名称（如 `add` ）以及符号（如 `+` ）。

```scala
case class Vec(val x: Double, val y: Double) {
  def +(that: Vec) = new Vec(this.x + that.x, this.y + that.y)
}

val vector1 = Vec(1.0, 1.0)
val vector2 = Vec(2.0, 2.0)

val vector3 = vector1 + vector2
vector3.x  // 3.0
vector3.y  // 3.0
```

`Vec` 类有一个方法 `+` 用于将 `vector` 和 `vector2` 相加。通过圆括号，你可以用易读的语法来构建复杂的表达式。这里定义了类 `MyBool` ，其中包括方法 `and` 和 `or` ：

```scala
case class MyBool(x: Boolean) {
  def and(that: MyBool): MyBool = if (x) that else this
  def or(that: MyBool): MyBool = if (x) this else that
  def negate: MyBool = MyBool(!x)
}
```

现在可以使用 `and` 和 `or` 来作为中缀操作符了：

```scala
def not(x: MyBool) = x.negate
def xor(x: MyBool, y: MyBool) = (x or y) and not(x and y)
```

这有助于让 `xor` 的定义更加可读。

## 优先级

当一个表达式使用了多个操作符，它们会基于第一个字符的优先级进行评估：

```
(characters not shown below)
* / %
+ -
:
= !
< >
&
^
|
(all letters)
```

以上优先级会应用到你定义的函数当中去。例如，下面的表达式：

```
a + b ^? c ?^ d less a ==> b | c
```

相当于

```
((a + b) ^? (c ?^ d)) less ((a ==> b) | c)
```

由于 `?^` 以字符 `?` 开头所以具有最高优先级， `+` 具有第二优先级，接着是 `==>` 、 `^?` 、 `|` 和 `less` 。