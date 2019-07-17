# 注解

注解将元信息和定义关联起来。例如，注解方法前的 `@deprecated` 会使得编译器在该方法被调用时打印一条警告。

```
object DeprecationDemo extends App {
  @deprecated("deprecation message", "release # which deprecates method")
  def hello = "hola"

  hello  
}
```

上述代码可以通过编译但是编译器会打印一条警告：“there was one deprecation warning”。

注解子句用于其后的第一个定义或者声明。一个定义或者声明的前面可以出现不止一个注解子句，而它们的顺序并不重要。

## 确保编码正确的注解

某些注解会在条件不满足的情况下导致编译失败。例如，注解 `@tailrec` 可以确保一个方法是[尾递归](https://en.wikipedia.org/wiki/Tail_call)。尾递归可以使得内存需求是固定的。下面是该注解在计算阶乘的方法中的使用情况：

```scala
import scala.annotation.tailrec

def factorial(x: Int): Int = {

  @tailrec
  def factorialHelper(x: Int, accumulator: Int): Int = {
    if (x == 1) accumulator else factorialHelper(x - 1, accumulator * x)
  }
  factorialHelper(x, 1)
}
```

`factorialHelper` 方法拥有注解 `@tailrec` ，可以确保该方法的确是尾递归的。如果我们按照下面的方式改变该方法的实现，则会编译失败：

```
import scala.annotation.tailrec

def factorial(x: Int): Int = {
  @tailrec
  def factorialHelper(x: Int): Int = {
    if (x == 1) 1 else x * factorialHelper(x - 1)
  }
  factorialHelper(x)
}
```

我们将得到提示信息“Recursive call not in tail position”。

## 影响代码生成的注解

有些注解（如 `@inline` ）会影响代码的生成（即生成的jar文件跟不使用注解相比可能具有不同的字节大小）。内联（inlining）的意思是将方法体中的代码直接插入到调用的位置。这样生成的字节码会更长，但是运行会更快。使用注解 `@inline` 无法确保一个方法会变成内联的，当且仅当通过了关于生成代码规模的一些尝试之后，编译器会将该方法变成内联的。

### Java 注解

在写与 Java 进行互操作的 Scala 代码时，在注解的语法上有些不同点需要注意。

**注：**在使用 Java 注解时必须带上选项 `-target:jvm-1.8` 。

Java 可以通过[注解](https://docs.oracle.com/javase/tutorial/java/annotations/)的形式来拥有用户自定义的元数据。注解的关键特性是依赖于对指定的名-值对进行初始化。例如我们需要一个注解来追踪某些类的来源，可能会这样来定义：

```
@interface Source {
  public String URL();
  public String mail();
}
```

接下来可以这样来使用：

```
@Source(URL = "http://coders.com/",
        mail = "support@coders.com")
public class MyClass extends HisClass ...
```

在 Scala 中使用注解像是在调用构造器，要实例化一个 Java 注解需要指定参数名：

```
@Source(URL = "http://coders.com/",
        mail = "support@coders.com")
class MyScalaClass ...
```

当注解仅有一个元素的时候这种语法便有点繁琐。所以习惯上，如果元素名称被指定为 `value` ，那么在 Java 中可以用类似于构造器的语法：

```
@interface SourceURL {
    public String value();
    public String mail() default "";
}
```

然后这样使用：

```
@SourceURL("http://coders.com/")
public class MyClass extends HisClass ...
```

这个例子中，Scala 的用法也是类似的：

```
@SourceURL("http://coders.com/")
class MyScalaClass ...
```

这里 `mail` 元素被指定了一个默认值，所以不需要为它显式提供一个值。然而，如果需要给它提供值，在 Java 中不能混搭这两种形式：

```
@SourceURL(value = "http://coders.com/",
           mail = "support@coders.com")
public class MyClass extends HisClass ...
```

Scala 则在这方面提供了更多的灵活性：

```
@SourceURL("http://coders.com/",
           mail = "support@coders.com")
    class MyScalaClass ...
```