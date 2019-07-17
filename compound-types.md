# 复合类型

有时候需要表达一个对象的类型是多个其他类型的子类型，在 Scala 中使用*复合类型*可以做到，这时它是多个类型的交集。

假设已有2个特质 `Cloneable` 和 `Resetable` ：

```scala
trait Cloneable extends java.lang.Cloneable {
  override def clone(): Cloneable = {
    super.clone().asInstanceOf[Cloneable]
  }
}
trait Resetable {
  def reset: Unit
}
```

现在如果我们需要写一个函数 `cloneAndReset` ，它接受一个对象，克隆并且重置它：

```
def cloneAndReset(obj: ?): Cloneable = {
  val cloned = obj.clone()
  obj.reset
  cloned
}
```

现在问题来了，参数 `obj` 到底是什么类型的呢？如果是 `Cloneable` 的，那么只能被 `clone` 但不能 `reset` ；如果是 `Resetable` 的，那么却又只能 `reset` 但不能进行 `clone` 操作。这种情况下，为了避免类型转换，我们可以声明 `obj` 的类型既是 `Cloneable` 又是 `Resetable` 。这种复合类型在Scala中写作： `Cloneable with Resetable` 。

下面是修改后的函数：

```
def cloneAndReset(obj: Cloneable with Resetable): Cloneable = {
  //...
}
```

复合类型可以包含多个对象类型，它有一种改良（refinement）可以用来缩短现有对象成员的签名。

基本形式如下： `A with B with C ... { refinement }`

关于改良的用法，在[抽象类型](abstract-types.md)一节中有案例介绍。