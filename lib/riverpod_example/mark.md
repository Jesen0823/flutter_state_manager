# Flutter Riverpod 状态管理库 (v2.5.1)

## 📁 1. 安装依赖

在 `pubspec.yaml` 添加：

```yaml
dependencies:
  flutter_riverpod: ^2.5.1
```

## 🧠 2. 核心概念简述

| 类型             | 描述                         | 示例用途             | 使用场景举例                                                |
| ---------------- | ---------------------------- | -------------------- | ----------------------------------------------------------- |
| Provider         | 只读数据                     | 常量、服务类         | 1. 应用配置和常量定义<br>2. 服务类实例创建<br>3. 依赖注入   |
| StateProvider    | 原始值的可变状态（int/bool） | 计数器、开关         | 1. 简单计数器应用<br>2. 开关状态管理<br>3. 临时UI状态       |
| NotifierProvider | 复杂对象状态 + 控制逻辑      | 列表、对象、业务逻辑 | 1. Todo列表管理<br>2. 用户状态管理<br>3. 购物车功能         |
| FutureProvider   | 异步加载                     | 网络请求、初始化数据 | 1. 网络API数据获取<br>2. 本地存储读取<br>3. 初始化配置加载  |
| StreamProvider   | 实时数据流                   | WebSocket、定时器    | 1. 实时聊天消息<br>2. 股票价格更新<br>3. 传感器数据监听     |
| Family           | 参数化Provider               | 按ID获取数据         | 1. 按ID获取用户信息<br>2. 动态过滤列表<br>3. 配置化服务创建 |
| AutoDispose      | 自动资源管理                 | 临时页面状态         | 1. 临时页面表单数据<br>2. 页面级状态管理<br>3. 避免内存泄漏 |

## 🧪 3. 实战代码讲解

### ✅ `Provider`：静态或只读依赖

```dart
final greetingProvider = Provider<String>((ref) {
  return "Hello, Riverpod!";
});

class GreetingWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greeting = ref.watch(greetingProvider);
    return Text(greeting);
  }
}
```

💡 用于配置、单例、不可变依赖。

### ✅ `StateProvider`：简单状态（如 int、bool）

```dart
final counterProvider = StateProvider<int>((ref) => 0);

class CounterPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Column(
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).state++,
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

💡 简单值状态管理的首选。

### ✅ `NotifierProvider`：结构化业务逻辑（Riverpod 2.0+）

定义模型：

```dart
class Todo {
  final String id;
  final String title;
  final bool completed;
  Todo({required this.id, required this.title, this.completed = false});
  Todo copyWith({String? id, String? title, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
```

定义状态控制器：

```dart
class TodoNotifier extends Notifier<List<Todo>> {
  @override
  List<Todo> build() => [];

  void add(String title) {
    final todo = Todo(id: DateTime.now().toIso8601String(), title: title);
    state = [...state, todo];
  }

  void remove(String id) {
    state = state.where((t) => t.id != id).toList();
  }

  void toggle(String id) {
    state = state.map((t) => t.id == id ? t.copyWith(completed: !t.completed) : t).toList();
  }
}

final todoListProvider = NotifierProvider<TodoNotifier, List<Todo>>(TodoNotifier.new);
```

页面使用：

```dart
class TodoListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);
    return ListView(
      children: todos
          .map((t) => ListTile(
                title: Text(t.title, style: TextStyle(
                  decoration: t.completed ? TextDecoration.lineThrough : null,
                )),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => ref.read(todoListProvider.notifier).remove(t.id),
                ),
                onTap: () => ref.read(todoListProvider.notifier).toggle(t.id),
              ))
          .toList(),
    );
  }
}
```

💡 面向对象式的推荐写法，利于维护与测试。

### ✅ `FutureProvider`：异步加载数据

```dart
final userInfoProvider = FutureProvider<String>((ref) async {
  await Future.delayed(Duration(seconds: 1));
  return "Async User Loaded";
});
```

使用：

```dart
class UserInfoWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoProvider);
    return userInfo.when(
      data: (name) => Text('User: $name'),
      loading: () => CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
    );
  }
}
```

💡 支持 loading/error/data 三种状态，十分方便。

### ✅ `StreamProvider`：实时流监听

```dart
final tickProvider = StreamProvider<int>((ref) async* {
  int count = 0;
  while (true) {
    await Future.delayed(Duration(seconds: 1));
    yield ++count;
  }
});
```

使用：

```dart
class TimerWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tick = ref.watch(tickProvider);
    return tick.when(
      data: (val) => Text('Tick: $val'),
      loading: () => Text('Waiting...'),
      error: (e, _) => Text('Error: $e'),
    );
  }
}
```

💡 非常适合实现 WebSocket、倒计时、后台上传监听等。

### ✅ `Family`：参数化Provider

```dart
final userProvider = FutureProvider.family<User, String>((ref, userId) async {
  return UserService.fetchUser(userId);
});

class UserWidget extends ConsumerWidget {
  final String userId;
  const UserWidget(this.userId, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider(userId));
    return user.when(
      data: (user) => Text('User: ${user.name}'),
      loading: () => CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
    );
  }
}
```

💡 用于需要动态参数的场景，如按ID获取数据。

### ✅ `AutoDispose`：自动资源管理

```dart
final tempFormProvider = StateProvider.autoDispose<String>((ref) => '');

class TempFormWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formValue = ref.watch(tempFormProvider);
    return Column(
      children: [
        TextField(
          onChanged: (value) => ref.read(tempFormProvider.notifier).state = value,
          decoration: InputDecoration(labelText: 'Temp Value'),
        ),
        Text('Current: $formValue'),
      ],
    );
  }
}
```

💡 页面销毁时自动清理状态，避免内存泄漏。

## 🧬 4. Riverpod Provider 的生命周期详解

Riverpod 的每个 `Provider` 都有清晰的**生命周期管理机制**，这是它相比 `Provider`（老版）或 `setState` 更加安全、强大的关键优势之一。

> 生命周期由 Riverpod 自动管理，确保资源释放、缓存优化、避免内存泄漏。

### 🎯 生命周期触发时机概览

| 生命周期阶段 | 描述                                          | 对应钩子函数 / 方法    |
| ------------ | --------------------------------------------- | ---------------------- |
| 创建         | 第一次被 ref.watch() / ref.read() 使用        | provider 的构造函数    |
| 监听中       | 有 widget 或 provider 依赖它                  | ref.watch() 触发监听   |
| 取消监听     | 最后一个监听者移除后，开始进入 dispose 倒计时 | keepAlive 决定回收策略 |
| 销毁         | 无依赖 + 被标记为回收                         | onDispose 触发         |

### 📌 1. Provider 的创建与首次使用

- 只有在首次使用（如 `ref.watch()`）时才真正创建。
- Provider 是懒加载的（Lazy Initialized）。

```dart
final timestampProvider = Provider<DateTime>((ref) {
  print('✅ 创建时间: ${DateTime.now()}');
  return DateTime.now();
});
```

### 📌 2. 自动销毁与缓存策略

### 🔁 默认行为：**自动销毁（AutoDispose）**

- 若无任何 `ref.watch()` 使用该 Provider，它会被自动销毁。
- 优化内存和性能，避免长时间驻留。

```dart
final myProvider = Provider.autoDispose<int>((ref) {
  print('🌀 创建');
  ref.onDispose(() => print('❌ 销毁'));
  return 42;
});
```

使用中断后会触发销毁：

```dart
// 页面离开，或 ref.invalidate()
```

### 📌 3. 保持活跃 `ref.keepAlive()`

```dart
final counterProvider = Provider.autoDispose<int>((ref) {
  final link = ref.keepAlive(); // 👈 阻止销毁

  Future.delayed(Duration(seconds: 30), () {
    print('🚨 30 秒后允许销毁');
    link.close(); // 👈 恢复可销毁
  });

  ref.onDispose(() {
    print('⛔ 被销毁');
  });

  return 123;
});
```

✅ 用于防止高频初始化，如网络缓存、状态记录。

### 📌 4. ref.onDispose()

所有 Provider 都可使用：

```dart
ref.onDispose(() {
  print('🧹 清理资源...');
});
```

常用于：

- 关闭连接（如 WebSocket、Stream、Timer）
- 释放资源（如 Controller、Database）
- 终止订阅

### ✅ 总结：各 Provider 生命周期对比

| Provider 类型                | 是否可自动销毁 | 是否可 keepAlive | 是否有 onDispose |
| ---------------------------- | -------------- | ---------------- | ---------------- |
| Provider                     | ❌ 否（持久）  | ✅ 支持          | ✅ 支持          |
| Provider.autoDispose         | ✅ 是          | ✅ 支持          | ✅ 支持          |
| StateProvider                | ❌ 否          | ✅ 支持          | ✅ 支持          |
| StateProvider.autoDispose    | ✅ 是          | ✅ 支持          | ✅ 支持          |
| NotifierProvider             | ❌ 否          | ✅ 支持          | ✅ 支持          |
| NotifierProvider.autoDispose | ✅ 是          | ✅ 支持          | ✅ 支持          |
| FutureProvider               | ❌ 否          | ✅ 支持          | ✅ 支持          |
| FutureProvider.autoDispose   | ✅ 是          | ✅ 支持          | ✅ 支持          |
| StreamProvider               | ❌ 否          | ✅ 支持          | ✅ 支持          |
| StreamProvider.autoDispose   | ✅ 是          | ✅ 支持          | ✅ 支持          |

## 🛠 5. 应用实战建议

| 场景                          | 建议 Provider 类型               |
| ----------------------------- | -------------------------------- |
| 临时页面数据（如表单页）      | .autoDispose 类型                |
| 全局共享状态（如登录信息）    | 普通 Provider / NotifierProvider |
| 长连接、Timer、Stream         | ref.onDispose + .keepAlive()     |
| 一次性请求缓存（配置、Token） | 使用 keepAlive() 手动控制回收    |
| 按ID获取数据                  | Family 类型                      |

## 🧱 6. Riverpod 与传统 Provider 的关系

### ✅ 简明回答：

**Riverpod 并不是基于传统 Provider 的封装**，它是 **完全重写的一个全新状态管理框架**，由同一个作者 Remi Rousselet 开发，但底层逻辑、API 设计、运行机制都不同。

### 🔍 深度解析：Riverpod 与 Provider 的关系

### 🧠 核心区别举例

### ✅ 传统 Provider 示例

```dart
ChangeNotifierProvider(
  create: (_) => CounterModel(),
  child: MyApp(),
);
```

- 必须包在 widget tree 里，依赖 `BuildContext`。
- 很多依赖关系写在 UI 组件中，不利于拆分测试。

### ✅ Riverpod 示例

```dart
final counterProvider = StateProvider((ref) => 0);
```

- 不依赖 WidgetTree，任何地方都可以 `ref.watch`。
- 甚至可以在纯 Dart 类、后台逻辑中使用，适合模块化架构。

## 📚 7. 工具推荐

| 工具                 | 用途                      |
| -------------------- | ------------------------- |
| `riverpod_lint`      | Riverpod 专用 Lint        |
| `riverpod_generator` | 自动生成 Notifier 等模板  |
| `state_notifier`     | 搭配使用，可手动控制状态  |
| `freezed`            | 状态模型不可变 + 模式匹配 |

## 🧭 8. 最佳实践建议

| 建议                              | 理由或说明                   |
| --------------------------------- | ---------------------------- |
| 使用 Notifier 替代 ChangeNotifier | 更轻量、更明确、更好测试     |
| 避免直接 ref.read().state++       | 推荐封装方法防止状态逻辑混乱 |
| 拆分 Provider 文件                | 提高可读性和可维护性         |
| 将 ref.read() 写到方法中          | 避免在 UI 中写业务逻辑       |
| 使用 autoDispose 管理临时状态     | 避免内存泄漏                 |
| 使用 Family 处理参数化需求        | 代码更简洁，逻辑更清晰       |

## 🧠 9. 为什么 Riverpod 可以"抽离状态逻辑"？

### ✅ 原因：**Riverpod 彻底摆脱了 Flutter 的 `InheritedWidget` 架构**

传统 Provider 的底层依赖的是 Flutter 的 widget 树（`InheritedWidget` + `BuildContext`），所以它的状态：

- **必须嵌套在 widget 树中注册**
- **读值/写值必须用 context（如 context.read）**

而 **Riverpod 的核心设计是"状态 = 纯 Dart 逻辑"**，所以：

- 它不依赖 Widget tree，也不需要 BuildContext。
- 所有状态保存在一个叫做 `ProviderContainer` 的"容器"中。
- UI 组件只是读这个容器里的值，**容器才是状态的大脑**。

## ✨ 10. 原理简述：Riverpod 是如何工作的？

### 核心组件包括：

| 名称              | 作用                                             |
| ----------------- | ------------------------------------------------ |
| ProviderContainer | 所有状态 Provider 的注册、缓存、生命周期管理中心 |
| Provider<T>       | 一个状态提供者，返回类型为 T 的值                |
| ref               | 用来读取其它 Provider，追踪依赖关系              |
| Notifier<T>       | 一个可变状态的控制器                             |
| ConsumerWidget    | 订阅 Provider 的 Flutter Widget                  |

当你 ref.watch(myProvider)，Riverpod 会：

1. 追踪这个 Provider 被哪些组件订阅；
2. 如果状态变化了，只通知这些订阅者刷新；
3. 它会懒加载 Provider，只在真正需要的时候创建；
4. 在无人使用时自动释放内存。

### 🔁 Riverpod 工作流程图（概览）

```dart
          +----------------+
          | Provider<T>    | <---------+
          +----------------+          |
                   |                  |
         ref.watch(provider)          |
                   v                  |
          +----------------+          |
          | ref / Widget   |          |
          | （记录依赖）     |          |
          +----------------+          |
                   |                  |
                   v                  |
          +------------------+        |
          | 构建 Provider 实例 | ------+
          +------------------+
                   |
                   v
          +------------------+
          | 返回状态数据     |
          +------------------+
                   |
                   v
          +------------------+
          | ConsumerWidget   |
          | or HookWidget    |
          +------------------+
                   |
            状态更新时通知刷新
```

### 🧠 核心机制解释

| 步骤                 | 说明                                                                   |
| -------------------- | ---------------------------------------------------------------------- |
| 1️⃣ Provider 定义     | 使用如 Provider, StateProvider, FutureProvider 定义一个状态数据入口。  |
| 2️⃣ ref.watch()       | 在 Widget 中使用 ref.watch(provider) 订阅状态，Riverpod 会记录此依赖。 |
| 3️⃣ 创建 Provider实例 | build() 方法会执行，并保存在 ProviderContainer 中（类似缓存）。        |
| 4️⃣ UI 渲染           | ConsumerWidget 会根据 provider 的值渲染 UI。                           |
| 5️⃣ 状态变更通知      | 当状态更新，Riverpod 会通知所有 watch 了它的 Widget 自动刷新。         |
| 6️⃣ 自动销毁（可选）  | 对于 autoDispose Provider，无依赖时自动释放，节省内存。                |

## 📝 11. 注解使用方法（Riverpod Generator）

### 安装依赖

```yaml
dependencies:
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.1.0

dev_dependencies:
  build_runner: ^2.4.0
  riverpod_generator: ^2.2.0
```

### 使用注解定义 Provider

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_provider.g.dart';

@riverpod
int counter(CounterRef ref) {
  return 0;
}

@riverpod
class TodoList extends _$TodoList {
  @override
  List<Todo> build() => [];

  void add(String title) {
    final newTodo = Todo(id: DateTime.now().toString(), title: title);
    state = [...state, newTodo];
  }

  void remove(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}
```

### 运行代码生成

```bash
flutter pub run build_runner build
```

### 使用生成的 Provider

```dart
class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('Count: $count');
  }
}
```

💡 注解方式可以减少模板代码，提高开发效率。

## 🎯 12. ConsumerWidget vs StatelessWidget

### ✅ 两者的区别

| 特性       | ConsumerWidget              | StatelessWidget              |
| ---------- | --------------------------- | ---------------------------- |
| 构造函数   | 提供 `WidgetRef ref` 参数   | 无 `ref` 参数                |
| 状态监听   | 直接通过 `ref.watch()` 监听 | 需要额外获取 `ref`           |
| 代码简洁度 | 更简洁，直接使用 `ref`      | 相对繁琐，需要额外代码       |
| 性能       | 优化的重建机制              | 可能需要整个 widget 重建     |
| 推荐程度   | Riverpod 官方推荐           | 不推荐用于 Riverpod 状态管理 |

### ✅ 在 StatelessWidget 中使用 Riverpod

虽然 ConsumerWidget 是官方推荐的方式，但在某些情况下，你仍然可以在 StatelessWidget 中使用 Riverpod：

```dart
final counterProvider = StateProvider<int>((ref) => 0);

class StatelessCounterWidget extends StatelessWidget {
  const StatelessCounterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: _CounterContent(),
    );
  }
}

class _CounterContent extends ConsumerWidget {
  const _CounterContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Column(
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).state++,
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

### ✅ 使用场景对比

| 场景                   | 推荐使用        | 理由                     |
| ---------------------- | --------------- | ------------------------ |
| 主要使用 Riverpod 状态 | ConsumerWidget  | 直接访问 `ref`，代码简洁 |
| 混合使用其他状态管理   | StatelessWidget | 可以包含其他状态管理逻辑 |
| 简单的无状态组件       | StatelessWidget | 不需要状态监听时使用     |
| 复杂的状态管理         | ConsumerWidget  | 更好的性能和代码组织     |

## 🎯 13. 注解与非注解实现对比

### ✅ 基本对应关系

| 非注解实现                                     | 注解实现                                                    | 对应关系                      |
| ---------------------------------------------- | ----------------------------------------------------------- | ----------------------------- |
| `Provider<T>((ref) => value)`                  | `@riverpod T provider(ProviderRef ref)`                     | 一对一对应                    |
| `StateProvider<T>((ref) => initial)`           | `@riverpod class Provider extends _$Provider`               | 通过 `state` 属性管理         |
| `NotifierProvider<N, T>(N.new)`                | `@riverpod class Provider extends _$Provider`               | 完全对应，注解更简洁          |
| `FutureProvider<T>((ref) => future)`           | `@riverpod Future<T> provider(ProviderRef ref)`             | 自动处理异步状态              |
| `StreamProvider<T>((ref) => stream)`           | `@riverpod Stream<T> provider(ProviderRef ref)`             | 自动处理流状态                |
| `Provider.family<T, Arg>((ref, arg) => value)` | `@riverpod T provider(ProviderRef ref, {required Arg arg})` | 通过参数传递                  |
| `Provider.autoDispose<T>((ref) => value)`      | `@riverpod T provider(AutoDisposeProviderRef ref)`          | 使用 `AutoDisposeProviderRef` |

### ✅ 代码对比示例

#### 非注解实现（手动）

```dart
// 简单 Provider
final greetingProvider = Provider<String>((ref) {
  return "Hello, Riverpod!";
});

// 复杂状态管理
class TodoNotifier extends Notifier<List<Todo>> {
  @override
  List<Todo> build() => [];

  void add(String title) {
    final newTodo = Todo(id: DateTime.now().toString(), title: title);
    state = [...state, newTodo];
  }
}
final todoProvider = NotifierProvider<TodoNotifier, List<Todo>>(TodoNotifier.new);

// Family Provider
final userProvider = FutureProvider.family<User, String>((ref, userId) async {
  return UserService.fetchUser(userId);
});
```

#### 注解实现（代码生成）

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

// 简单 Provider
@riverpod
String greeting(GreetingRef ref) {
  return "Hello, Riverpod!";
}

// 复杂状态管理
@riverpod
class Todo extends _$Todo {
  @override
  List<TodoItem> build() => [];

  void add(String title) {
    final newTodo = TodoItem(id: DateTime.now().toString(), title: title);
    state = [...state, newTodo];
  }
}

// Family Provider
@riverpod
Future<User> user(UserRef ref, {required String userId}) async {
  return UserService.fetchUser(userId);
}
```

### ✅ 记忆方法

#### 🔍 核心记忆点

1. **简单值用函数注解**：对于返回简单值的 Provider，使用 `@riverpod` 注解函数
2. **复杂状态用类注解**：对于需要管理状态的 Provider，使用 `@riverpod` 注解类并继承 `_$ClassName`
3. **参数传递用函数参数**：Family 模式通过函数参数实现
4. **自动销毁用特殊 Ref**：AutoDispose 模式通过使用 `AutoDisposeProviderRef` 实现
5. **异步操作自动处理**：Future 和 Stream 类型会自动处理加载、错误和数据状态

#### 🎯 快速判断表

| 需求              | 推荐实现方式 | 代码结构                                        |
| ----------------- | ------------ | ----------------------------------------------- |
| 只读常量/配置     | 注解函数     | `@riverpod T provider(ProviderRef ref)`         |
| 简单状态管理      | 注解类       | `@riverpod class P extends _$P`                 |
| 复杂业务逻辑      | 注解类       | `@riverpod class P extends _$P`                 |
| 异步数据获取      | 注解函数     | `@riverpod Future<T> provider(ProviderRef ref)` |
| 实时数据流        | 注解函数     | `@riverpod Stream<T> provider(ProviderRef ref)` |
| 带参数的 Provider | 注解函数/类  | 添加函数参数                                    |
| 临时状态管理      | 注解函数/类  | 使用 `AutoDisposeProviderRef`                   |

## 🎯 14. 总结

Riverpod 2.5.1 是一个强大、灵活、类型安全的状态管理库，通过以下特性为 Flutter 应用提供了优秀的状态管理解决方案：

1. **编译时安全**：提前发现类型错误
2. **独立于 Widget 树**：业务逻辑层直接访问状态
3. **丰富的 Provider 类型**：满足各种状态管理需求
4. **强大的生命周期管理**：自动资源释放，避免内存泄漏
5. **灵活的依赖注入**：轻松处理复杂的依赖关系
6. **支持注解**：减少模板代码，提高开发效率
7. **多种 Widget 集成方式**：支持 ConsumerWidget 和 StatelessWidget

Riverpod 不仅是一个状态管理库，更是一种应用架构模式，它鼓励开发者将业务逻辑与 UI 分离，构建更加模块化、可测试、可维护的应用。通过选择合适的实现方式（注解或非注解）和 Widget 类型（ConsumerWidget 或 StatelessWidget），你可以根据项目需求灵活地使用 Riverpod 的强大功能。
| ConsumerWidget |
| or HookWidget |
+------------------+
|
状态更新时通知刷新

```


🧠 核心机制解释

| 步骤                | 说明                                                         |
| ------------------- | ------------------------------------------------------------ |
| 1️⃣ Provider 定义     | 使用如 Provider, StateProvider, FutureProvider 定义一个状态数据入口。 |
| 2️⃣ ref.watch()       | 在 Widget 中使用 ref.watch(provider) 订阅状态，Riverpod 会记录此依赖。 |
| 3️⃣ 创建 Provider实例 | build() 方法会执行，并保存在 ProviderContainer 中（类似缓存）。 |
| 4️⃣ UI 渲染           | ConsumerWidget 会根据 provider 的值渲染 UI。                 |
| 5️⃣ 状态变更通知      | 当状态更新，Riverpod 会通知所有 watch 了它的 Widget 自动刷新。 |
| 6️⃣ 自动销毁（可选）  | 对于 autoDispose Provider，无依赖时自动释放，节省内存。      |
```