# 泛型类

泛型类是接受类型作为参数的类。这对于集合类特别有用。

## 定义一个泛型类

泛型类使用方括号 `[]` 接受类型作为参数。尽管可以使用任何参数名，但是一般约定使用字母 `A` 来作为类型参数标识符。

```scala
class Stack[A] {
  private var elements: List[A] = Nil
  def push(x: A) { elements = x :: elements }
  def peek: A = elements.head
  def pop(): A = {
    val currentTop = peek
    elements = elements.tail
    currentTop
  }
}
```

这里 `Stack` 类的实现接受任意类型 `A` 作为参数。这意味着下面的列表 `var elements: List[A] = Nil` ，只能存储 `A` 类型的元素。方法 `def push` 仅仅接受类型 `A` 的参数（注意： `elements = x :: elements` 通过将 `x` 加到当前这个 `elements` 的头部，来将 `elements` 重新分配到一个新的列表）。

## 用法

要使用一个泛型类，就将类型替换 `A` 放在方括号中。

```
val stack = new Stack[Int]
stack.push(1)
stack.push(2)
println(stack.pop)  // prints 2
println(stack.pop)  // prints 1
```

上述的 `stack` 实例仅接受 `Int` 类型。然而，如果类型参数有子类型，下面的做法也能通过：

```
class Fruit
class Apple extends Fruit
class Banana extends Fruit

val stack = new Stack[Fruit]
val apple = new Apple
val banana = new Banana

stack.push(apple)
stack.push(banana)
```

类 `Apple` 和 `Banana` 都继承自 `Fruit` ，因此我们可以把 `apple` 和 `banana` 加入到栈 `Fruit` 中。

注意：泛型的子类型是不可变的。这意味着如果有个字符类型的栈 `Stack[Char]` ，那么它是不能作为一个整数类型的栈 `Stack[Int]` 来使用的。这听起来有点不对劲，事实上我们应该能够把纯整数放进一个字符栈中的。总之，只有在 `B=A` 的时候， `Stack[A]` 才是 `Stack[B]` 的子类型。这个其实是有局限性的，于是 Scala 提供了一种[类型参数的注解机制](variances.md)来控制泛型类型的子类型的行为。