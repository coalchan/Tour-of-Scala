# 样例类

样例类就像普通类，但是有一些关键的区别，我们后面会提到。样例类很擅长构建不可变数据。接下来，我们会发现它们在[模式匹配](pattern-matching.md)中很有用。

## 定义一个样例类

一个最简化的样例类需要关键字 `case class` 、标识符以及一个参数列表（也有可能是空的）。

```scala
case class Book(isbn: String)

val frankenstein = Book("978-0486282114")
```

注意这里实例化样例类 `Book` 时并没有使用关键字 `new` 。这是因为样例类默认有一个 `apply` 方法来构造对象。

当你创建一个带有参数的样例类时，这些参数默认是公有（ `val` ）的。

```
case class Message(sender: String, recipient: String, body: String)
val message1 = Message("guillaume@quebec.ca", "jorge@catalonia.es", "Ça va ?")

println(message1.sender)  // prints guillaume@quebec.ca
message1.sender = "travis@washington.us"  // this line does not compile
```

你不能对 `message1.sender` 重新赋值，因为它是一个 `val` （即不可变的）。当然，也可以在样例类中使用 `var` ，但是不鼓励这样做。

## 比较

样例类比较的是其中的结构而非引用：

```
case class Message(sender: String, recipient: String, body: String)

val message2 = Message("jorge@catalonia.es", "guillaume@quebec.ca", "Com va?")
val message3 = Message("jorge@catalonia.es", "guillaume@quebec.ca", "Com va?")
val messagesAreTheSame = message2 == message3  // true
```

虽然 `message2` 和 `message3` 指向不同的对象，但是它们的值是相等的。

## 复制

你可以直接使用 `copy` 方法来复制一个样例类的实例，甚至可以改变其构造器的参数。

```
case class Message(sender: String, recipient: String, body: String)
val message4 = Message("julien@bretagne.fr", "travis@washington.us", "Me zo o komz gant ma amezeg")
val message5 = message4.copy(sender = message4.recipient, recipient = "claire@bourgogne.fr")
message5.sender  // travis@washington.us
message5.recipient // claire@bourgogne.fr
message5.body  // "Me zo o komz gant ma amezeg"
```

`message4` 中的 recipient 值传给了 `message5` 中的 sender，而 `message4` 中的 `body` 被直接复制过去了。