# 自身类型

自身类型是声明一个特质必须混入另外一种特质的方法，即使它并不继承。这使得不需要引入就可以使用依赖的成员。

自身类型可以缩短 `this` 类型或者其他别名为 `this` 的标识符。这种语法看起来像是普通的函数语法，但意思是完全不同的。

为了在特质中使用自身类型，需要写一个混入的其他特质的类型的标识符，以及一个 `=>`（例如 `someIdentifier: SomeOtherTrait =>` ）。

```scala
trait User {
  def username: String
}

trait Tweeter {
  this: User =>  // reassign this
  def tweet(tweetText: String) = println(s"$username: $tweetText")
}

class VerifiedTweeter(val username_ : String) extends Tweeter with User {  // We mixin User because Tweeter required it
	def username = s"real $username_"
}

val realBeyoncé = new VerifiedTweeter("Beyoncé")
realBeyoncé.tweet("Just spilled my glass of lemonade")  // prints "real Beyoncé: Just spilled my glass of lemonade"
```

当我们在 `trait Tweeter` 中写到 `this: User =>` ，这时在 `tweet` 方法中 `username` 变量便处于作用域当中。这也意味着 `VerifiedTweeter` 要继承 `Tweeter` 的话，还必须要混入 `User` （使用 `with User` ）。