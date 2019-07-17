# 特质

特质用于在类之间共享接口和字段，这点和 Java8 中的接口很像。类和对象可以继承特质，但是特质不能被实例化，因此没有参数。

## 定义一个特质
最简化的特质就是关键字`trait`和一个标识符：

```scala
trait HairColor
```

特质在用于泛型类型和抽象方法时特别有用。

```scala
trait Iterator[A] {
  def hasNext: Boolean
  def next(): A
}
```

继承 `trait Iterator[A]` 需要一个类型 `A` ，并且实现方法 `hasNext` 和 `next` 。

## 使用特质
使用 `extends` 关键字可以继承一个特质。实现特质中的任何一个抽象方法时使用 `override` 关键字：

```scala
trait Iterator[A] {
  def hasNext: Boolean
  def next(): A
}

class IntIterator(to: Int) extends Iterator[Int] {
  private var current = 0
  override def hasNext: Boolean = current < to
  override def next(): Int =  {
    if (hasNext) {
      val t = current
      current += 1
      t
    } else 0
  }
}


val iterator = new IntIterator(10)
iterator.next()  // returns 0
iterator.next()  // returns 1
```

`IntIterator` 类的参数 `to` 用来作为上界。 `extends Iterator[Int]` 表示其中的 `next` 方法必须返回一个 `Int` 值。

## 子类型化

凡是需要特质的地方，都可以由该特质的子类型来替换。

```scala
import scala.collection.mutable.ArrayBuffer

trait Pet {
  val name: String
}

class Cat(val name: String) extends Pet
class Dog(val name: String) extends Pet

val dog = new Dog("Harry")
val cat = new Cat("Sally")

val animals = ArrayBuffer.empty[Pet]
animals.append(dog)
animals.append(cat)
animals.foreach(pet => println(pet.name))  // Prints Harry Sally
```

特质 `Pet` 有个抽象字段 `name` ，分别在 `Cat` 和 `Dog` 中的构造方法中得到了实现。最后一行，我们调用 `pet.name` 必须是在特质 `pet` 的任何子类型中得到了实现。