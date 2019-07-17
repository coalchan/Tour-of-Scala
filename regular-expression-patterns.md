# 正则表达式模式

正则表达式是一个字符串，可以被用来在数据中查找某种模式（或者没有该模式）的数据。任何字符串只要使用了 `.r` 方法就可以转化为一个正则表达式。

```scala
import scala.util.matching.Regex

val numberPattern: Regex = "[0-9]".r

numberPattern.findFirstMatchIn("awesomepassword") match {
  case Some(_) => println("Password OK")
  case None => println("Password must contain a number")
}
```

上述例子当中， `numberPattern` 是一个 `Regex` （正则表达式），可以用来确定密码中是否包含数字。
你可以使用圆括号来搜索正则表达式组。

```scala
import scala.util.matching.Regex

val keyValPattern: Regex = "([0-9a-zA-Z-#() ]+): ([0-9a-zA-Z-#() ]+)".r

val input: String =
  """background-color: #A03300;
    |background-image: url(img/header100.png);
    |background-position: top center;
    |background-repeat: repeat-x;
    |background-size: 2160px 108px;
    |margin: 0;
    |height: 108px;
    |width: 100%;""".stripMargin

for (patternMatch <- keyValPattern.findAllMatchIn(input))
  println(s"key: ${patternMatch.group(1)} value: ${patternMatch.group(2)}")
```

这里我们解析出了字符串中的键值对。每个匹配都包含了一组子匹配，下面是输出：

```
key: background-color value: #A03300
key: background-image value: url(img
key: background-position value: top center
key: background-repeat value: repeat-x
key: background-size value: 2160px 108px
key: margin value: 0
key: height value: 108px
key: width value: 100
```