# 类型下界

[类型上界](upper-type-bounds.md)限制了一个类型是另外一个类型的子类型，而*类型下界*则声明了一个类型是另外一个类型的父类型。 `B >: A` 表明了类型参数 `B` 或者抽象类型 `B` 是类型 `A` 的超类。在大多数场景中， `A` 是作为类的类型参数，而 `B` 会作为方法的类型参数。

这里有个十分有用的例子：

```scala
trait Node[+B] {
  def prepend(elem: B): Node[B]
}

case class ListNode[+B](h: B, t: Node[B]) extends Node[B] {
  def prepend(elem: B): ListNode[B] = ListNode(elem, this)
  def head: B = h
  def tail: Node[B] = t
}

case class Nil[+B]() extends Node[B] {
  def prepend(elem: B): ListNode[B] = ListNode(elem, this)
}
```

这个程序实现了一个单向链表。 `Nil` 表示一个空的元素（比如一个空的列表）。 `class ListNode` 是一个 `Node` ，它包含了一个类型 `B` 的元素（ `head` ）和一个列表中其余元素的引用（ `tail` ）。 `class Node` 和它的子类型是协变的，因为这里有 `+B` 。

然而，这个程序不能通过编译，因为 `prepend` 方法中的参数 `elem` 是 `B` 类型的，且声明了为协变的。这之所以行不通，是在于函数在它们的参数类型上是逆变的，而在它们的返回类型上是协变的。

为了解决这个问题，我们需要转变 `prepend` 方法中参数类型的型变。我们可以引用新的类型 `U` ，它的类型下界是 `B` ，从而实现这一转变。

```scala
trait Node[+B] {
  def prepend[U >: B](elem: U): Node[U]
}

case class ListNode[+B](h: B, t: Node[B]) extends Node[B] {
  def prepend[U >: B](elem: U): ListNode[U] = ListNode(elem, this)
  def head: B = h
  def tail: Node[B] = t
}

case class Nil[+B]() extends Node[B] {
  def prepend[U >: B](elem: U): ListNode[U] = ListNode(elem, this)
}
```

现在我们便可以像下面这样操作了：

```scala
trait Bird
case class AfricanSwallow() extends Bird
case class EuropeanSwallow() extends Bird


val africanSwallowList= ListNode[AfricanSwallow](AfricanSwallow(), Nil())
val birdList: Node[Bird] = africanSwallowList
birdList.prepend(new EuropeanSwallow)
```

`Node[Bird]` 被分配到 `africanSwallowList` ，但是仍然可以接受 `EuropeanSwallow` 。