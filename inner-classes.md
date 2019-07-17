# 内部类

在 Scala 中，可以在类中拥有别的类作为其成员。与 Java 语言中内部类是包含它的类的成员相反，Scala 中这些内部类是绑定在它的外部对象上的。如果想要在混合属于不同图的节点的时候，编译器能够在编译时阻止我们，那么路径依赖类型（Path-dependent types）提供了一种方案。

为了说明二者的区别，我们快速实现了图类型：

```scala
class Graph {
  class Node {
    var connectedNodes: List[Node] = Nil
    def connectTo(node: Node) {
      if (connectedNodes.find(node.equals).isEmpty) {
        connectedNodes = node :: connectedNodes
      }
    }
  }
  var nodes: List[Node] = Nil
  def newNode: Node = {
    val res = new Node
    nodes = res :: nodes
    res
  }
}
```

该程序表明图是节点的列表（ `List[Node]` ）。每个节点拥有一个连接到其他节点（ `connectedNodes` ）的列表。 `class Node` 由于嵌套在 `class Graph` 当中，因而是路径依赖类型。因此， `connectedNodes` 中的所有节点必须由 `Graph` 的相同实例来使用 `newNode` 进行创建。

```scala
val graph1: Graph = new Graph
val node1: graph1.Node = graph1.newNode
val node2: graph1.Node = graph1.newNode
val node3: graph1.Node = graph1.newNode
node1.connectTo(node2)
node3.connectTo(node1)
```

这里我们显式地声明了 `node1` 、 `node2` 和 `node3` 为 `graph1.Node` ，其实编译器也能推断出来。因为我们在调用 `graph1.newNode` 时，它调用了 `new Node` ，该方法使用的其实是特定实例 `graph1` 的 `node` 实例。

如果我们有2个图，Scala 的类型系统不允许我们把不同图的节点混合在一起，因为不同图的节点的类型是不一样的。

下面是错误示例：

```
val graph1: Graph = new Graph
val node1: graph1.Node = graph1.newNode
val node2: graph1.Node = graph1.newNode
node1.connectTo(node2)      // legal
val graph2: Graph = new Graph
val node3: graph2.Node = graph2.newNode
node1.connectTo(node3)      // illegal!
```

`graph1.Node` 与 `graph2.Node` 的类型是不同的。而在 Java 中，上面这段程序的最后一行是正确。对于不同图的节点来说，Java 会分配相同的类型 `Graph.Node` （即类 `Graph` 是 `Node` 的前缀）。在 Scala 中这种类型可以被写作 `Graph#Node` 。如果想要连接不同图的节点，我们需要按照下面的方式改变最开始对于图的实现：

```scala
class Graph {
  class Node {
    var connectedNodes: List[Graph#Node] = Nil
    def connectTo(node: Graph#Node) {
      if (connectedNodes.find(node.equals).isEmpty) {
        connectedNodes = node :: connectedNodes
      }
    }
  }
  var nodes: List[Node] = Nil
  def newNode: Node = {
    val res = new Node
    nodes = res :: nodes
    res
  }
}
```