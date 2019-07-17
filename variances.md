# 型变

型变是复杂类型的子类型关系与它们组件的类型的子类型关系之间的关联性。Scala 支持 [泛型类](generic-classes.md)的类型参数上的型变注解，可以使得它们是协变的、逆变的或者不变的（如果没有使用注解的话）。型变在类型系统中的使用使得我们在复杂的类型之间建立起了直观的联系，反之如果没有型变则限制了抽象类的重用。

```scala
class Foo[+A] // 协变类
class Bar[-A] // 逆变类
class Baz[A]  // 不变类
```

### 协变

泛型类的类型参数 `A` 可以通过使用注解 `+A` 变成协变的。对于某个 `class List[+A]` ，让 `A` 协变意味着对于类型 `A` 和 `B` ，如果 `A` 是 `B` 的子类型，那么 `List[A]` 则是 `List[B]` 的子类型。这让我们可以使用泛型类来创建非常有用且直观的子类型关系。

现在来看下面这个简单的类结构：

```scala
abstract class Animal {
  def name: String
}
case class Cat(name: String) extends Animal
case class Dog(name: String) extends Animal
```

`Cat` 和 `Dog` 都是 `Animal` 的子类型。Scala的标准库中有一个常用的不可变类 `sealed abstract class List[+A]` ，它的类型参数 `A` 就是协变的。这意味着 `List[Cat]` 是一个 `List[Animal]` 而 `List[Dog]` 也是一个 `List[Animal]` 。从直观上，一个猫的列表和一个狗的列表都是一个动物列表是讲得通的。因而你可以把它们其中任意一个替换为 `List[Animal]` 来使用。

下面的例子当中，方法 `printAnimalNames` 会接受一个动物列表作为参数，并且依次在新的一行里打印它们的名字。如果 `List[A]` 不是协变的，则下面两个方法的调用不会通过编译，这将严重限制了 `printAnimalNames` 方法的使用。

```scala
object CovarianceTest extends App {
  def printAnimalNames(animals: List[Animal]): Unit = {
    animals.foreach { animal =>
      println(animal.name)
    }
  }

  val cats: List[Cat] = List(Cat("Whiskers"), Cat("Tom"))
  val dogs: List[Dog] = List(Dog("Fido"), Dog("Rex"))

  printAnimalNames(cats)
  // Whiskers
  // Tom

  printAnimalNames(dogs)
  // Fido
  // Rex
}
```

### 逆变

泛型类的类型参数 `A` 可以通过使用注解 `-A` 变成逆变的。这使得我们在类和相似的类型参数之间建立起了子类型关系，而结果正好与协变相反。也就是说，对于某个类 `class Writer[-A]` ，让 `A` 逆变意味着对于类型 `A` 和 `B` ，如果 `A` 是 `B` 的子类型，那么 `Writer[B]` 则是 `Writer[A]` 的子类型。

想想上面定义的类 `Cat` 、 `Dog` 和 `Animal` ，在下面例子中的应用：

```scala
abstract class Printer[-A] {
  def print(value: A): Unit
}
```

一个 `Printer[A]` 是一个简单的类，它知道该如何打印出类型 `A` 。下面我们为具体的类型来定义一些子类吧：

```scala
class AnimalPrinter extends Printer[Animal] {
  def print(animal: Animal): Unit =
    println("The animal's name is: " + animal.name)
}

class CatPrinter extends Printer[Cat] {
  def print(cat: Cat): Unit =
    println("The cat's name is: " + cat.name)
}
```

如果一个 `Printer[Cat]` 知道如何打印 `Cat` 到控制台，而一个 `Printer[Animal]` 知道如何打印 `Animal` 到控制台，那么一个 `Printer[Animal]` 从道理上讲也应该知道如何打印 `Cat` 。反过来则不适用，因为一个 `Printer[Cat]` 不知道如何打印一个 `Animal` 到控制台。因此我们应该能够用 `Printer[Animal]` 来替换 `Printer[Cat]` ，要做到这点的话，需要让 `Printer[A]` 成为逆变的。

```scala
object ContravarianceTest extends App {
  val myCat: Cat = Cat("Boots")

  def printMyCat(printer: Printer[Cat]): Unit = {
    printer.print(myCat)
  }

  val catPrinter: Printer[Cat] = new CatPrinter
  val animalPrinter: Printer[Animal] = new AnimalPrinter

  printMyCat(catPrinter)
  printMyCat(animalPrinter)
}
```

该程序的输出如下：

```
The cat's name is: Boots
The animal's name is: Boots
```

### 不变

Scala 中的泛型类默认是不变的。这意味着它们既不是协变的，也不是逆变的。下面的例子中， `Container` 类是不变的，则 `Container[Cat]` 不是 `Container[Animal]` ，反过来也不是。

```scala
class Container[A](value: A) {
  private var _value: A = value
  def getValue: A = _value
  def setValue(value: A): Unit = {
    _value = value
  }
}
```

看起来似乎一个 `Container[Cat]` 应该也是一个 `Container[Animal]` ，但是允许一个可变的泛型类协变其实是不安全的。这个例子中， `Container` 是不变的，这点很重要。如果 `Container` 是协变的，类似于下面的事情可能就会发生：

```
val catContainer: Container[Cat] = new Container(Cat("Felix"))
val animalContainer: Container[Animal] = catContainer
animalContainer.setValue(Dog("Spot"))
val cat: Cat = catContainer.getValue // Oops, we'd end up with a Dog assigned to a Cat
```

幸运的是，在我们犯错前编译器就会阻止我们。

### 其他示例

另外有一个可以帮助我们理解型变的例子，是源于 Scala 标准库里的 `trait Function1[-T, +R]` 。 `Function1` 是带有一个参数的函数，第一个类型参数 `T` 表示参数类型，第二个类型参数 `R` 表示返回类型。 `Function1` 在它的参数类型上是逆变的，在返回类型上是协变的。一般我们会使用字面量 `A => B` 来表示 `Function1[A, B]` 。

假如我们已经有了和之前类似的 `Cat` 、 `Dog` 、 `Animal` 继承树，外加下面这些：

```scala
abstract class SmallAnimal extends Animal
case class Mouse(name: String) extends SmallAnimal
```

假设现在我们有个函数接受动物类型，返回它们吃的食物类型。我们想要的可能是 `Cat => SmallAnimal` （因为猫会吃小动物），但是如果替换为 `Animal => Mouse` ，我们的程序也可以正常运行。直观上说 `Animal => Mouse` 也可以接受一个 `Cat` 作为参数，因为 `Cat` 是一个 `Animal` ，并且返回一个 `Mouse` ，而它也是一个 `SmallAnimal` 。我们可以安全且隐形地用后者进行替换，因而我们可以说 `Animal => Mouse` 是 `Cat => SmallAnimal` 的子类型。

### 和其他语言比较

和 Scala 类似的一些语言对于支持型变的方式是不一样的。例如，Scala 中的型变注解其实和 C# 非常类似，它们都是在抽象类的定义时添加了注解（称为“声明式型变”）。而在 Java 中，型变注解是在一个抽象类使用时由使用者给定的（称为“使用式型变”）。