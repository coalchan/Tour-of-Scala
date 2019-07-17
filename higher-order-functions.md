# 高阶函数

高阶函数使用其他函数作为参数，或者返回一个函数。这是可行的，因为在 Scala 中函数是“头等公民”。关于这点在术语上可能让人有点困惑，我们把那些使用函数作为参数或者返回函数的方法和函数都称为“高阶函数”。

最常见的例子之一是用于 Scala 中集合的高阶函数 `map` 。

```scala
val salaries = Seq(20000, 70000, 40000)
val doubleSalary = (x: Int) => x * 2
val newSalaries = salaries.map(doubleSalary) // List(40000, 140000, 80000)
```

`doubleSalary` 是一个接收 `Int` 类型的 `x` ，返回 `x*2` 的函数。箭头 `=>` 左侧的元组是一个参数列表，右侧是返回值。第三行，函数 `doubleSalary` 被应用于列表 `salaries` 中的每一个元素。

为了简化代码，我们可以使用匿名函数，并且直接将它作为参数传给 `map` ：

```
val salaries = Seq(20000, 70000, 40000)
val newSalaries = salaries.map(x => x * 2) // List(40000, 140000, 80000)
```

注意在上面的例子当中 `x` 并没有被声明为 `Int` 。这是因为编译器可以根据函数 `map` 需要的类型来推断出它的类型。这段代码还有一种更惯用的写法是：

```scala
val salaries = Seq(20000, 70000, 40000)
val newSalaries = salaries.map(_ * 2)
```

由于 Scala 编译器已经知道了参数的类型（一个 `Int` ），你仅仅需要提供函数的右侧即可。唯一需注意的是要用 `_` 来替代参数名（在前面的例子中是 `x` ）。

## 方法强制转换为函数

也可以将方法作为参数传递给高阶函数，因为 Scala 编译器会将方法强制转换为函数。

```
case class WeeklyWeatherForecast(temperatures: Seq[Double]) {

  private def convertCtoF(temp: Double) = temp * 1.8 + 32

  def forecastInFahrenheit: Seq[Double] = temperatures.map(convertCtoF) // <-- passing the method convertCtoF
}
```

这里的方法 `convertCtoF` 被传递给 `forecastInFahrenheit` 。这样做是可以的，因为编译器会会将 `convertCtoF` 强制转换成函数 `x => convertCtoF(x)` (注： `x` 是自动生成的，并且在其作用域内保证了唯一性)。

## 接受函数的函数

使用高阶函数的其中一个理由是为了减少冗余代码。假设你想用一些方法来提高某人的工资，并且通过不同的乘法因子。如果不使用高阶函数，那么可能要这样来写：

```scala
object SalaryRaiser {

  def smallPromotion(salaries: List[Double]): List[Double] =
    salaries.map(salary => salary * 1.1)

  def greatPromotion(salaries: List[Double]): List[Double] =
    salaries.map(salary => salary * math.log(salary))

  def hugePromotion(salaries: List[Double]): List[Double] =
    salaries.map(salary => salary * salary)
}
```

注意这3个方法唯一的不同在于乘法因子。为了简化代码，你可以将重复的代码提取到高阶函数当中，如下所示：

```scala
object SalaryRaiser {

  private def promotion(salaries: List[Double], promotionFunction: Double => Double): List[Double] =
    salaries.map(promotionFunction)

  def smallPromotion(salaries: List[Double]): List[Double] =
    promotion(salaries, salary => salary * 1.1)

  def bigPromotion(salaries: List[Double]): List[Double] =
    promotion(salaries, salary => salary * math.log(salary))

  def hugePromotion(salaries: List[Double]): List[Double] =
    promotion(salaries, salary => salary * salary)
}
```

这个新的方法 `promotion` 接受一个类型为 `Double => Double` （即接受一个 Double 并返回一个 Double 的函数）的加薪函数作为参数，然后返回乘积。

## 返回函数的函数

有些特定场景下，你可能希望生成一个函数。下面是一个返回函数的方法的例子。

```scala
def urlBuilder(ssl: Boolean, domainName: String): (String, String) => String = {
  val schema = if (ssl) "https://" else "http://"
  (endpoint: String, query: String) => s"$schema$domainName/$endpoint?$query"
}

val domainName = "www.example.com"
def getURL = urlBuilder(ssl=true, domainName)
val endpoint = "users"
val query = "id=1"
val url = getURL(endpoint, query) // "https://www.example.com/users?id=1": String
```

注意 urlBuilder 的返回类型是 `(String, String) => String` 。这意味着返回的匿名函数接受两个字符串并返回一个字符串。在这个例子中，返回的匿名函数是 `(endpoint: String, query: String) => s"https://www.example.com/$endpoint?$query"` 。