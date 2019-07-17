# 模式匹配

模式匹配是检查一个值是否匹配某种模式的机制。一个成功的匹配可以把一个值解析成它的组成部分。它相当于 Java 中 `switch` 的增强版，可以以此来替代一堆的 if/else 语句。

## 语法

一个match表达式有个待匹配的值、 `match` 关键字以及至少一个 `case` 从句。

```scala
import scala.util.Random

val x: Int = Random.nextInt(10)

x match {
  case 0 => "zero"
  case 1 => "one"
  case 2 => "two"
  case _ => "many"
}
```

上面的 `val x` 是0到10之间的要给随机整数。 `x` 是 `match` 操作符的左操作数，右边是4个样例组成的表达式。最后一个样例 `_` 匹配了大于2的所有数字。这些样例也被称为_代值_。

match 表达式有一个返回值。

```scala
def matchTest(x: Int): String = x match {
  case 1 => "one"
  case 2 => "two"
  case _ => "many"
}
matchTest(3)  // many
matchTest(1)  // one
```

这个 match 表达式返回一个 String 类型，那是因为所有的 case 都返回 String 。所以函数 `matchTest` 便返回一个 String 。

## 匹配样例类

样例类在模式匹配中特别有用。

```scala
abstract class Notification

case class Email(sender: String, title: String, body: String) extends Notification

case class SMS(caller: String, message: String) extends Notification

case class VoiceRecording(contactName: String, link: String) extends Notification


```

`Notification` 是一个抽象父类，另外有3个 `Notification` 类型的实现，分别是样例类 `Email` 、 `SMS` 和 `VoiceRecording` 。现在我们可以使用这些样例类进行模式匹配。

```
def showNotification(notification: Notification): String = {
  notification match {
    case Email(email, title, _) =>
      s"You got an email from $email with title: $title"
    case SMS(number, message) =>
      s"You got an SMS from $number! Message: $message"
    case VoiceRecording(name, link) =>
      s"you received a Voice Recording from $name! Click the link to hear it: $link"
  }
}
val someSms = SMS("12345", "Are you there?")
val someVoiceRecording = VoiceRecording("Tom", "voicerecording.org/id/123")

println(showNotification(someSms))  // prints You got an SMS from 12345! Message: Are you there?

println(showNotification(someVoiceRecording))  // you received a Voice Recording from Tom! Click the link to hear it: voicerecording.org/id/123
```

函数 `showNotification` 接受一个抽象类型 `Notification` ，并且用来匹配 `Notification` 类型（它会判断出到底是一个 `Email` 、 `SMS` ，还是一个 `VoiceRecording` ）。在 `case Email(email, title, _)` 中 `email` 和 `title` 用于返回值，而 `body` 则因 `_` 而被忽略。

## 模式守卫

模式守卫是简单的布尔表达式，使得 case 子句更具体，要做到这点只需要在模式后添加 `if <boolean expression>` 。

```
def showImportantNotification(notification: Notification, importantPeopleInfo: Seq[String]): String = {
  notification match {
    case Email(email, _, _) if importantPeopleInfo.contains(email) =>
      "You got an email from special someone!"
    case SMS(number, _) if importantPeopleInfo.contains(number) =>
      "You got an SMS from special someone!"
    case other =>
      showNotification(other) // nothing special, delegate to our original showNotification function
  }
}

val importantPeopleInfo = Seq("867-5309", "jenny@gmail.com")

val someSms = SMS("867-5309", "Are you there?")
val someVoiceRecording = VoiceRecording("Tom", "voicerecording.org/id/123")
val importantEmail = Email("jenny@gmail.com", "Drinks tonight?", "I'm free after 5!")
val importantSms = SMS("867-5309", "I'm here! Where are you?")

println(showImportantNotification(someSms, importantPeopleInfo))
println(showImportantNotification(someVoiceRecording, importantPeopleInfo))
println(showImportantNotification(importantEmail, importantPeopleInfo))
println(showImportantNotification(importantSms, importantPeopleInfo))
```

在 `case Email(email, _, _) if importantPeopleInfo.contains(email)` 中，仅当 `email` 在重要人士的的列表中，该模式才会匹配上。

## 类型匹配

你可以像下面这样匹配类型：

```scala
abstract class Device
case class Phone(model: String) extends Device{
  def screenOff = "Turning screen off"
}
case class Computer(model: String) extends Device {
  def screenSaverOn = "Turning screen saver on..."
}

def goIdle(device: Device) = device match {
  case p: Phone => p.screenOff
  case c: Computer => c.screenSaverOn
}
```

`def goIdle` 根据 `Device` 的类型不同会有不同的行为。当模式中需要调用方法时，这会很有用。一般惯例是使用类型的首字母来作为 case 标识符（如本例子中的 `p` 和 `c` ）。

## 密封类

特质和类都可以被标记为 `sealed` ，这个时候也意味着它的所有子类必须在相同的文件中进行声明。这样做可以保证所有的子类型都是已知的。

```scala
sealed abstract class Furniture
case class Couch() extends Furniture
case class Chair() extends Furniture

def findPlaceToSit(piece: Furniture): String = piece match {
  case a: Couch => "Lie on the couch"
  case b: Chair => "Sit on the chair"
}
```

这种做法对于模式匹配来说非常有用，因为我们不再需要一个额外的“case all”子句了。

## 注意

Scala 的模式匹配语句对于由[样例类](case-classes.md)表示的代数类型的匹配时很有用。另外 Scala 也允许通过使用[提取器对象](extractor-objects.html)的 `unapply` 方法，来定义有别于样例类的的模式。