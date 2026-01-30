**InheritedWidget:**

1. 只能用在widget tree 中的数据共享，不能直接修改状态
2. 配合 StatefulWidget / StateNotifier管理状态变化。
3. 只有调用dependOnInheritedWidgetOfExactType的Widget 会 rebuild。

**InheritedModel**:
1. 适合多个子组件使用不同“维度”的状态共享。
2. aspect控制更新粒度，减少不必要的重建。
3. 多维度时不推荐滥用，逻辑复杂。

---------------------------------------
- 必须用 BuildContext 获取数据，不可跨树使用。
- 不支持状态持久存储或异步逻辑，需结合其他状态管理使用。
- 配合 InheritedNotifier 更灵活。

【适用于简单夸组传递的场景】

【原理】
> BuildContext.dependOnInheritedWidgetOfExactType<CounterProvider>()
会在Widget树向上查找最近的CounterProvider,也就是最近的InheritedWidget的实现类
（就近原则），也相当于类似注册监听。监听注册好之后，当InheritedWidget通知更新时，当前注册监听的Widget会被重新构建。

> 也就是说，Flutter 的 Widget 是树状结构，每个 Widget 都有自己的 BuildContext；
     Flutter 在构建 Widget 时，允许你使用 context 来“向上”查找上层组件；
     InheritedWidget 被专门设计为“可以被子树中 Widget 订阅”的数据共享组件；
     调用 dependOnInheritedWidgetOfExactType<T>() 时，框架内部会：
     找到最近的类型为 T 的 InheritedWidget；
     把当前 Widget（调用者）注册为“依赖它”；
     如果这个 InheritedWidget 发生变化（通过 updateShouldNotify 返回 true），那么所有依赖它的 Widget 会自动被标记为需要重新构建。

updateShouldNotify()方法对应的维度返回true，则响应的组件或子树重新构建。

实际开发中，如果要管理状态且有多个页面共享，推荐封装为：ChangeNotifier + InheritedNotifier：组合使用；
或使用成熟的状态管理框架（Provider、Riverpod、Bloc、GetX）；
Flutter 内置的状态（比如 Theme.of(context)、MediaQuery.of(context)）也是通过 InheritedWidget 实现的。
