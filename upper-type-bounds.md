# 类型上界

在 Scala 中，[类型参数](generic-classes.md)和[抽象类型](abstract-types.md)可能受到类型边界的约束。这些类型边界限制了具体的类型变量，同时揭示了关于该类型成员更多的信息。一个类型上界 `T <: A` 表明了类型变量 `T` 是类型 `A` 的子类型。

这里有个例子演示了类 `PetContainer` 的类型参数的类型上界：

```scala
abstract class Animal {
 def name: String
}

abstract class Pet extends Animal {}

class Cat extends Pet {
  override def name: String = "Cat"
}

class Dog extends Pet {
  override def name: String = "Dog"
}

class Lion extends Animal {
  override def name: String = "Lion"
}

class PetContainer[P <: Pet](p: P) {
  def pet: P = p
}

val dogContainer = new PetContainer[Dog](new Dog)
val catContainer = new PetContainer[Cat](new Cat)
```

```scala
val lionContainer = new PetContainer[Lion](new Lion) // this would not compile
```

`class PetContainer` 接受一个类型参数 `P` ，它是 `Pet` 的子类型。 `Dog` 和 `Cat` 是 `Pet` 的子类型，因此我们可以创建一个新的 `PetContainer[Dog]` 和 `PetContainer[Cat]` 。然而，如果我们试图创建一个 `PetContainer[Lion]` ，则会得到下面的错误：

`type arguments [Lion] do not conform to class PetContainer's type parameter bounds [P <: Pet]`

这是因为 `Lion` 不是 `Pet` 的子类型。