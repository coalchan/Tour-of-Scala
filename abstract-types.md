# 抽象类型

特质和抽象类可以拥有抽象类型的成员。这意味着具体的实现可以定义实际的类型，下面是示例：

```scala
trait Buffer {
  type T
  val element: T
}
```

这里我们定义了一个抽象的 `type T` ，用来描述 `element` 的类型。我们可以在抽象类中继承该特质，并为 `T` 增加了一个类型上界使之更为具体。

```scala
abstract class SeqBuffer extends Buffer {
  type U
  type T <: Seq[U]
  def length = element.length
}
```

注意我们将如何使用作为类型上界的另一个抽象的 `type U` 。 `class SeqBuffer` 通过声明一个 `Seq[U]`（这里 `U` 是一个新的抽象类型）的子类型 `T` ，使得我们在一个 `Buffer` 中只能存储序列。

拥有抽象成员的特质和[类](classes.md)经常与匿名类的实例化结合使用。为了说明这点，我们来看一段程序，其中涉及到一个指向整数列表的序列缓冲：

```scala
abstract class IntSeqBuffer extends SeqBuffer {
  type U = Int
}


def newIntSeqBuf(elem1: Int, elem2: Int): IntSeqBuffer =
  new IntSeqBuffer {
       type T = List[U]
       val element = List(elem1, elem2)
     }
val buf = newIntSeqBuf(7, 8)
println("length = " + buf.length)
println("content = " + buf.element)
```

这里的工厂方法 `newIntSeqBuf` 用到了 `IntSeqBuf` 的一个匿名实现类（即 `new IntSeqBuffer` ），并将 `type T` 设置为一个 `List[Int]` 。

也可以将抽象类型成员转换为类的类型参数，反之亦然。下面是上述代码的另外一个版本，但仅仅使用了类型参数：

```scala
abstract class Buffer[+T] {
  val element: T
}
abstract class SeqBuffer[U, +T <: Seq[U]] extends Buffer[T] {
  def length = element.length
}

def newIntSeqBuf(e1: Int, e2: Int): SeqBuffer[Int, Seq[Int]] =
  new SeqBuffer[Int, List[Int]] {
    val element = List(e1, e2)
  }

val buf = newIntSeqBuf(7, 8)
println("length = " + buf.length)
println("content = " + buf.element)
```

为了隐藏方法 `new IntSeqBuf` 返回的对象的具体序列实现类型，我们需要用到[型变注解](variances.md)(即 `+T <: Seq[U]` )。此外，有些场景下是不能用类型参数来替换抽象类型的。