### 🛠 一、MobX 的安装与基本使用

MobX 的核心有三大类：

| 概念         | 说明                                         |
| ------------ | -------------------------------------------- |
| `Observable` | 可观察状态，类似变量。变化时自动触发 UI 更新 |
| `Action`     | 改变状态的行为，所有状态变更建议通过 action  |
| `Reaction`   | 监听变化后做副作用，比如打印日志、导航等     |

#### 1. 添加依赖在 

#### pubspec.yaml 中：

```yaml
dependencies:
  flutter:
    sdk: flutter
  mobx: ^2.2.0
  flutter_mobx: ^2.0.6

dev_dependencies:
  build_runner: ^2.4.6
  mobx_codegen: ^2.4.0
```

#### 2.创建一个 MobX Store（状态容器）

```dart
// counter_store.dart

import 'package:mobx/mobx.dart';

part 'counter_store.g.dart'; // 自动生成的文件

class CounterStore = _CounterStore with _$CounterStore;

abstract class _CounterStore with Store {
  @observable
  int count = 0;

  @action
  void increment() {
    count++;
  }
}
```

**生成代码命令**：

```bash
flutter pub run build_runner build
# 或者自动监听：
flutter pub run build_runner watch
```

#### 3. 使用 `Observer` 监听状态

```dart
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'counter_store.dart';

class CounterPage extends StatelessWidget {
  final CounterStore counter = CounterStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MobX Counter")),
      body: Center(
        child: Observer(
          builder: (_) => Text(
            '${counter.count}',
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: counter.increment,
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### 📚 二、MobX 核心注解说明

| 注解        | 作用         | 示例                                           |
| ----------- | ------------ | ---------------------------------------------- |
| @observable | 可监听变量   | @observable int count = 0;                     |
| @action     | 状态改变函数 | @action void increment() => count++;           |
| @computed   | 派生状态     | String get fullName => "$firstName $lastName"; |

### 🧩 三、不同类型的 Observer 使用方式

| 类型                     | 使用场景                     | 是否支持 child | 是否自动跟踪依赖 |
| ------------------------ | ---------------------------- | -------------- | ---------------- |
| Observer                 | 通用 UI 刷新                 | ✅              | ✅                |
| Observer.builder         | 自定义构建器                 | ✅              | ✅                |
| ObserverWidget（自定义） | 可封装为组件                 | ❌              | ✅                |
| Observer + child:        | 子组件不依赖状态，可优化性能 | ✅              | ✅                |

#### 1️⃣ 最常用的 `Observer`

适用于所有直接在 build() 方法中监听 observable 状态的场景。

##### ✅ 示例：

```dart
Observer(
  builder: (_) => Text(
    '${counter.count}',
    style: TextStyle(fontSize: 32),
  ),
)
```

每当 counter.count 更新时，Text 会自动重建。



#### 2️⃣ Observer + child 优化重建

用于优化性能：当 UI 中部分元素是静态的，可以通过 child 参数避免重建。

✅ 示例：

```dart
Observer(
  child: Icon(Icons.favorite), // 不会因为状态变化而重建
  builder: (_, child) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      child!,
      SizedBox(width: 8),
      Text('${counter.count}'),
    ],
  ),
)
```

✅ Icon 是静态内容，MobX 不会重复创建，节省性能。



#### 3️⃣ 封装成组件：自定义 ObserverWidget

当你想将 Observer 封装成复用组件时，可创建一个继承自 StatelessWidget 的 Observer 控件。

✅ 示例：

```dart
class CountText extends StatelessWidget {
  final CounterStore store;
  const CountText({required this.store});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Text('${store.count}', style: TextStyle(fontSize: 24)),
    );
  }
}
```

使用方式：

```dart
CountText(store: counterStore)
```

#### 4️⃣ ListView/GridView 中的 Observer

当你需要对列表内容做响应式刷新时，每个 item 可以使用 Observer 包裹。

✅ 示例：

```dart
Observer(
  builder: (_) => ListView.builder(
    itemCount: todoStore.todos.length,
    itemBuilder: (_, index) {
      final todo = todoStore.todos[index];
      return Observer(
        builder: (_) => CheckboxListTile(
          value: todo.done,
          onChanged: (_) => todo.toggleDone(),
          title: Text(todo.title),
        ),
      );
    },
  ),
)
```

每个 CheckboxListTile 都会监听自己对应的 todo.done，提高效率。

#### 🧠 补充：多层 Observer 嵌套性能说明

MobX 的响应式追踪是“精确依赖感知”的，每个 `Observer` 只监听自己用到的 `@observable`，**不会因为 store 中其他字段变化而重建**，比传统 [Provider](https://so.csdn.net/so/search?q=Provider&spm=1001.2101.3001.7020) 更细粒度。



#### ✅ 小结对比

| 类型                                     | 优势               | 适用场景        |
| ---------------------------------------- | ------------------ | --------------- |
| `Observer`                               | 最常用，自动追踪   | 通用响应式 UI   |
| `Observer + child`                       | 性能优化           | 静态元素嵌入 UI |
| 自定义 `StatelessWidget` 包裹 `Observer` | 组件复用           | 通用响应式组件  |
| 列表中嵌套 `Observer`                    | 精细追踪每一项变化 | todo、商品列表  |

------



### ✅ MobX 为什么可以“这么做”——原理解析

##### 一、核心机制：**可观察（Observable） + 自动追踪（Tracking）**

1. @observable 的变量不是普通变量，而是被 MobX 包装成了 可追踪对象（Atom）。

2. 当 Observer 被构建时，MobX 开启一个 “追踪上下文”（Tracking Context）：

3. 在 Observer.builder() 中访问了哪些 @observable，就自动把这些变量注册为“依赖”。
   一旦这些依赖发生变化，MobX 会自动通知 Observer 重新构建 UI。



##### 二、过程举例说明

```dart
@observable
int count = 0;

Observer(
  builder: (_) => Text('$count'),
)
```

➡ MobX 做了什么？

1. 初次 build 时读取了 `count`，MobX 会记录下这个“读取动作”：

   > “这个 Observer 正在依赖 count！”

2. 后续调用 `count++`（即修改 observable）时：

   > MobX 发现 `count` 改了，它就通知所有依赖 `count` 的观察者（也就是这个 `Observer`）重新执行 `builder`，从而刷新 UI。

##### 三、底层依赖追踪的原理：**Atom + Reaction**

MobX 的核心类是：

| 类         | 说明                                                      |
| ---------- | --------------------------------------------------------- |
| Atom       | 每个 observable 变量都是一个 Atom,可追踪对象              |
| Reaction   | 每个 Observer 内部注册了一个 reaction                     |
| Context    | 每次执行 builder() 时，MobX 开启上下文收集依赖            |
| Derivation | 指的是任何依赖 observable 的函数，比如 computed、Observer |

##### 四、Flutter 中 UI 为什么可以重建？

因为 Observer 继承自 StatelessWidget，而其内部逻辑其实是这样的（伪代码）：

```dart
class Observer extends StatelessWidget {
  final Reaction _reaction;

  Observer({required WidgetBuilder builder}) {
    _reaction = Reaction(() {
      // 当依赖的 observable 改变时，调用 setState 或 rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    // 启动依赖收集
    _reaction.track(() {
      builder(context); // 在这个过程中读取 observable，就会注册依赖
    });
  }
}
```

##### ✅ 总结一句话

>  **MobX 可以“这么做”，是因为它在 `Observer.builder` 执行时自动收集依赖变量，一旦这些变量变化，MobX 会主动通知刷新 UI。你不需要写 setState，它已经帮你自动“追踪 + 通知 + 重建”了。**



### ✅ 七、总结：MobX 值得用吗？

MobX 让状态管理变得优雅和现代化：

- 不用写 `setState`
- 不需要 `notifyListeners`
- 自动依赖收集
- 最细粒度响应更新

适合追求响应式编程和简洁架构的开发者。如果你喜欢 Vue、Svelte 那种“写了就动”的感觉，MobX 会让你爱不释手。



### 🧰 附加建议

- 推荐将每个 Store 模块化、组件化；
- 可结合依赖注入工具如 GetIt 使用；
- 想要更复杂管理？可引入 `reaction` 或 `when` 进行副作用管理。
