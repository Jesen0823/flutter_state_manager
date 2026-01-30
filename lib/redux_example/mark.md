### 先看一个redux的计数器的代码例子

#### ✅ 1. pubspec.yaml 添加依赖

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_redux: ^0.10.0
  redux: ^5.0.0
```

#### ✅ 2. 完整 main.dart 文件

```dart
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() {
  // 初始化 Store
  final store = Store<AppState>(
    counterReducer,
    initialState: AppState(counter: 0),
  );

  runApp(MyApp(store: store));
}

// 应用状态
class AppState {
  final int counter;
  AppState({required this.counter});
}

// 动作
enum CounterAction { increment }

// Reducer
AppState counterReducer(AppState state, dynamic action) {
  if (action == CounterAction.increment) {
    return AppState(counter: state.counter + 1);
  }
  return state;
}

// 根组件
class MyApp extends StatelessWidget {
  final Store<AppState> store;
  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Redux Counter',
        home: CounterPage(),
      ),
    );
  }
}

// 页面组件
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, int>(
      converter: (store) => store.state.counter,
      builder: (context, counter) => Scaffold(
        appBar: AppBar(title: Text('Redux Counter')),
        body: Center(
          child: Text(
            'Count: $counter',
            style: TextStyle(fontSize: 24),
          ),
        ),
        floatingActionButton: StoreConnector<AppState, VoidCallback>(
          converter: (store) {
            return () => store.dispatch(CounterAction.increment);
          },
          builder: (context, callback) => FloatingActionButton(
            onPressed: callback,
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
```

#### 🧠 架构解释

| 部分               | 内容                                                  |
| ------------------ | ----------------------------------------------------- |
| AppState           | 存储整个 App 的状态（这里只有一个 counter）           |
| enum CounterAction | 定义 Action，表示操作类型                             |
| counterReducer     | Reducer 是一个纯函数，接收旧状态和 Action，返回新状态 |
| StoreProvider      | 全局注入 Store                                        |
| StoreConnector     | 获取状态或触发 dispatch                               |

#### 🧩 点击按钮到底发生了什么？

```dart
 用户点击按钮（onPressed）
         │
         ▼
callback 被触发：store.dispatch(CounterAction.increment)
         │
         ▼
Reducer 被调用：counterReducer 接收 oldState 和 Action
         │
         ▼
返回新状态 newState：AppState(counter: +1)
         │
         ▼
Store 内部调用 notifyListeners() 通知所有订阅者
         │
         ▼
StoreConnector 监听状态变化，触发 builder 重建
         │
         ▼
UI 组件重新构建，显示最新 counter 数值

```

#### 🔁 每个阶段详细拆解：

##### 1️⃣ `onPressed → dispatch`

用户点击按钮时：

```dart
onPressed: callback
```

这个 callback 就是：

```dart
() => store.dispatch(CounterAction.increment)
```

它会向 Redux `store` 发出一个 Action。

##### 2️⃣ `Reducer 处理 Action，生成新状态`

```dart
AppState counterReducer(AppState state, dynamic action) {
  if (action == CounterAction.increment) {
    return AppState(counter: state.counter + 1);
  }
  return state;
}
```

- 如果 Action 是 `CounterAction.increment`
- 就返回一个新的 `AppState(counter + 1)`

注意：**状态是不可变的**，所以必须返回一个新的 `AppState` 实例，而不是修改旧的。

##### 3️⃣ Store 自动触发 UI 重建

当 `store` 的状态改变时：

```dart
final store = Store<AppState>(
  counterReducer,
  initialState: AppState(counter: 0),
);
```

- Store 会通知所有使用 `StoreConnector` 的 widget
- 它们会重新调用 `builder` 构建函数

##### 4️⃣ `StoreConnector` 构建最新界面

这段代码中的 `StoreConnector` 会被重新构建：

```dart
StoreConnector<AppState, int>(
  converter: (store) => store.state.counter,
  builder: (context, counter) => Text('Count: $counter'),
)
```

新的 `AppState` 会被传入，`counter` 发生变化，于是界面上的文本 `Count: x` 就会更新。

#### ✅ 总结一句话：

> 点击按钮 → 发出 Action → Reducer 生成新状态 → Store 更新 → UI 自动刷新（响应式）

------



### 进阶用法

Redux 在 Flutter 中除了基础用法（`State`、`Action`、`Reducer`、`Store`）之外，还有许多 **进阶用法**，可以让项目结构更清晰、功能更强大。

下面我结合代码示例说明几种常见的 Redux 进阶用法：

#### ✅1. Middleware 能做什么？

Redux 中的 **Middleware（中间件）** 是连接 `dispatch()` 与 `reducer` 的中间层，允许你在 **Action 发出与 State 更新之间** 做一些额外处理。

| 用途         | 举例                                          |
| ------------ | --------------------------------------------- |
| 日志记录     | 打印所有 Action 和 State                      |
| 处理异步     | 配合 `redux_thunk` 发起网络请求               |
| 权限校验     | 登录验证、跳转拦截                            |
| 状态持久化   | 把 state 保存到本地（如 `SharedPreferences`） |
| 拦截非法操作 | 比如某 Action 不满足条件就不继续传递          |

##### ✅ Middleware 使用方法

##### 1️⃣ 函数签名

```dart
typedef MiddlewareClass<State> = void Function(
  Store<State> store,
  dynamic action,
  NextDispatcher next,
);
```

- `store`：当前 Redux 的状态仓库
- `action`：被 dispatch 的 action
- `next(action)`：把 action 继续传递给下一个中间件或 reducer（必须调用！）

##### ✅ 简单日志中间件示例

```dart
void loggingMiddleware<State>(
  Store<State> store,
  dynamic action,
  NextDispatcher next,
) {
  print('[🌀 Dispatching] $action');
  next(action); // 一定要调用，否则 reducer 永远收不到
  print('[✅ New State] ${store.state}');
}
```

注册方式：

```dart
final store = Store<AppState>(
  appReducer,
  initialState: AppState.initial(),
  middleware: [loggingMiddleware],
);
```

#### 一个完整的Redux 的Middleware 是例子

我们构建一个登录后才能点击“点赞”的 App，包含以下功能：

| 功能点           | 实现方式                                     |
| ---------------- | -------------------------------------------- |
| ✅ 通用日志中间件 | 每个 action 自动打印日志（带模块 tag）       |
| ✅ Auth 中间件    | 未登录时禁止 dispatch 点赞，并提示“请先登录” |
| ✅ Loading 中间件 | 点赞时展示 loading 状态，完成后消失          |
| ✅ 通知机制       | 成功点赞后弹出 SnackBar 通知“点赞成功”       |

##### ✅ 目录结构（精简示意）

```dart
lib/
├── main.dart                # 启动入口
├── redux/
│   ├── app_state.dart       # 全局状态 AppState
│   ├── reducers.dart        # combineReducers
│   ├── actions.dart         # 所有 action
│   ├── middleware.dart      # 所有中间件
│   └── models/              # 模块化状态模型（auth, like）
├── pages/
│   └── home_page.dart       # 主界面
```

##### ✅ 总结：包含的中间件功能

| 名称           | 功能                                 |
| -------------- | ------------------------------------ |
| Logger 中间件  | 打印所有 Action 和新状态             |
| Auth 中间件    | 未登录拦截 Like 操作并提示           |
| Loading 中间件 | 2 秒后模拟点赞成功并更新点赞数       |
| Toast 中间件   | 所有 `ShowToastAction` 弹出 SnackBar |

##### ⚠️ 使用中间件的注意事项

| 注意事项                 | 说明                                                     |
| ------------------------ | -------------------------------------------------------- |
| ✅ 必须调用 next(action)  | 否则 reducer 不会收到这个 action，导致状态不更新         |
| ✅ 中间件顺序重要         | 比如日志写在异步前后位置不同，输出不同                   |
| ✅ 避免副作用污染 reducer | 所有副作用都应在 middleware 完成，reducer 必须保持纯函数 |
| ✅ 多中间件组合           | 多个 middleware 会按数组顺序依次执行                     |
| ✅ 检查 Action类型        | 通常你需要判断 if (action is XxxAction) 再处理           |

------



#### ✅ 2. redux_thunk 的作用

`redux_thunk` 是 Redux 的一个中间件，用于支持**异步操作**，比如网络请求、定时任务等。

在默认 Redux 中，只能 dispatch 一个**普通对象**：

```dart
store.dispatch(MyAction()); // ✅ 正常
store.dispatch(() async {}); // ❌ 错误，不支持函数
```

👉 有了 `redux_thunk` 后，你就可以 dispatch 一个函数（Thunk），这个函数里可以执行异步任务，最后再手动 dispatch 正常的 Action。

##### ✅ 安装依赖

在 `pubspec.yaml` 中添加：

```yaml
dependencies:
  redux_thunk: ^0.4.0
```

##### ✅ 使用步骤

第一步：注册中间件

```dart
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

final store = Store<AppState>(
  appReducer,
  initialState: AppState.initial(),
  middleware: [thunkMiddleware],
);
```

第二步：定义异步 action（Thunk）

```dart
import 'package:redux_thunk/redux_thunk.dart';

class UpdateCounterAction {
  final int newValue;
  UpdateCounterAction(this.newValue);
}

ThunkAction<AppState> fetchCounterFromServer() {
  return (Store<AppState> store) async {
    // 模拟网络请求
    await Future.delayed(Duration(seconds: 2));
    int response = 42;

    // 请求完成后，dispatch 普通 Action
    store.dispatch(UpdateCounterAction(response));
  };
}
```

第三步：在界面中使用

```dart
ElevatedButton(
  onPressed: () {
    store.dispatch(fetchCounterFromServer());
  },
  child: Text("异步获取计数"),
);
```

第四步：在 reducer 中处理 `UpdateCounterAction`

```dart
AppState reducer(AppState state, dynamic action) {
  if (action is UpdateCounterAction) {
    return state.copyWith(counter: action.newValue);
  }
  return state;
}
```

##### ✅ Thunk vs 普通 Action 对比表

| 项目          | 普通 Action           | Thunk Action                 |
| ------------- | --------------------- | ---------------------------- |
| 类型          | 普通对象              | 函数 `(Store) => void`       |
| 是否异步      | 否                    | ✅ 可以处理异步逻辑           |
| 何时 dispatch | 直接 dispatch         | 异步完成后手动 dispatch      |
| 使用场景      | UI 改变、同步状态更新 | 网络请求、延迟任务、条件判断 |

##### ✅ 使用技巧

| 技巧                  | 示例                                                    |
| --------------------- | ------------------------------------------------------- |
| ✅ 配合 Loading Action | dispatch(ShowLoading)，请求完成后 dispatch(HideLoading) |
| ✅ 条件判断执行        | if (!state.loggedIn) return;                            |
| ✅ 错误处理            | try/catch 包裹网络请求，dispatch 错误 Action            |
| ✅ 链式 dispatch       | 在 thunk 里 dispatch 多个普通 action 来控制流程         |



------

#### ✅ 3. **模块化 reducer（combineReducers）**

模块化 reducer（`combineReducers`）是 Redux 在管理**大型复杂状态树**时非常重要的机制，尤其适用于 Flutter Redux 项目的**模块化设计与状态解耦**。

##### ✅ 一、什么是 combineReducers？

`combineReducers` 是 Redux 提供的一个方法，用于**组合多个子 reducer**，把每个 reducer 管理的状态片段组合成一个**整体 AppState**。

##### ✅ 二、基本用法

```dart
final Reducer<AppState> appReducer = combineReducers<AppState>([
  TypedReducer<AppState, dynamic>((state, action) => AppState(
    auth: authReducer(state.auth, action),
    counter: counterReducer(state.counter, action),
    cart: cartReducer(state.cart, action),
  )),
]);
```

> **推荐做法：手动组合多个 reducer，并封装到 `AppState` 的构造函数中。**

##### ✅ 三、典型项目模块结构

```dart
lib/
└── redux/
    ├── app_state.dart          // 全局状态树
    ├── reducers.dart           // 所有 reducer 组合入口
    ├── auth/
    │   ├── auth_state.dart
    │   ├── auth_reducer.dart
    ├── counter/
    │   ├── counter_state.dart
    │   ├── counter_reducer.dart
    └── cart/
        ├── cart_state.dart
        ├── cart_reducer.dart

```

**app_state.dart**

```dart
import 'auth/auth_state.dart';
import 'counter/counter_state.dart';
import 'cart/cart_state.dart';

class AppState {
  final AuthState auth;
  final CounterState counter;
  final CartState cart;

  AppState({
    required this.auth,
    required this.counter,
    required this.cart,
  });

  static AppState initial() => AppState(
    auth: AuthState.initial(),
    counter: CounterState.initial(),
    cart: CartState.initial(),
  );
}
```

**reducers.dart**

```dart
import 'auth/auth_reducer.dart';
import 'counter/counter_reducer.dart';
import 'cart/cart_reducer.dart';
import 'app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    auth: authReducer(state.auth, action),
    counter: counterReducer(state.counter, action),
    cart: cartReducer(state.cart, action),
  );
}
```

> ✅ 每个子 reducer 只处理自己的 state，组合后构建成新的 AppState。

##### ✅ 五、技巧 & 注意事项

| ✅ 技巧                            | 💡 描述                                                       |
| --------------------------------- | ------------------------------------------------------------ |
| 每个模块只处理自己                | 子 reducer 只操作对应的子状态，如 authReducer 只管 auth      |
| 不要在 reducer 中跨模块访问 state | 比如 cartReducer 不应该操作 auth 的状态                      |
| 状态必须有初始值                  | 每个模块的 State 应有 initial() 方法，避免 null 异常         |
| 结合 ViewModel 解耦 UI            | 搭配 StoreConnector + ViewModel 映射使用                     |
| 结构扁平化更清晰                  | 尽量避免深度嵌套，如 appState.user.profile.address.detail... |
| 支持嵌套组合                      | 多层模块可以使用多级 combineReducers（示例见下）             |
| 合并时返回新实例                  | reducer 不能修改旧状态，要返回 copyWith 后的新状态           |

##### ✅ 六、嵌套 combineReducers（高级）

如果某模块本身有多个子模块，也可以进一步拆分 reducer：

```dart
class UserState {
  final ProfileState profile;
  final SettingsState settings;

  UserState({required this.profile, required this.settings});
}

UserState userReducer(UserState state, dynamic action) {
  return UserState(
    profile: profileReducer(state.profile, action),
    settings: settingsReducer(state.settings, action),
  );
}

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    user: userReducer(state.user, action),
    cart: cartReducer(state.cart, action),
  );
}
```

##### ✅ 七、是否使用 Redux 官方 `combineReducers()`？

在 Flutter 中，我们**不推荐使用 redux.dart 提供的 `combineReducers<>()`** 函数，因为它基于 `TypedReducer` 是不可读的：

```dart
final appReducer = combineReducers<AppState>([
  TypedReducer<AppState, SomeAction>(someHandler),
]);
```

👉 推荐自己写 `AppState` 的构造函数手动组合 reducer，**更清晰、更好调试、更好拓展。**

##### ✅ 八、总结

| 优点             | 描述                                          |
| ---------------- | --------------------------------------------- |
| 🎯 清晰的模块边界 | 每个 reducer 只处理自己的状态                 |
| 🎯 易于扩展       | 新模块只需新建 reducer 并在 appReducer 中组合 |
| 🎯 易于测试       | 每个 reducer 都可以独立单元测试               |
| 🎯 易于维护       | 状态树结构一目了然                            |



------

#### ✅ 4. **ViewModel 映射（StoreConnector + ViewModel）**

ViewModel 映射（通过 `StoreConnector<AppState, ViewModel>`）是 Flutter Redux 中的核心设计模式之一，它的**主要目的是**：

##### ✅ 一、使用目的

| 目的             | 说明                                                   |
| ---------------- | ------------------------------------------------------ |
| 解耦 UI 与 Store | 避免在 UI 中频繁直接访问 store.state.xxx，让 UI 更干净 |
| 优化性能         | ViewModel 实现 == 或 props 可以精细控制 build 触发时机 |
| 集中事件处理     | 所有 UI 操作都抽象成 viewModel.onXxx()，便于测试和维护 |
| 提升可测试性     | ViewModel 可以被独立测试，UI 层只管展示                |

##### ✅ 二、基本结构

```dart
StoreConnector<AppState, MyViewModel>(
  converter: (store) => MyViewModel.fromStore(store),
  builder: (context, vm) => UI(vm),
)
```

##### ✅ 三、ViewModel 示例

```dart
class MyViewModel {
  final bool isLoggedIn;
  final int count;
  final List<String> cartItems;

  final VoidCallback onLogin;
  final VoidCallback onIncrement;
  final Function(String) onAddToCart;

  MyViewModel({
    required this.isLoggedIn,
    required this.count,
    required this.cartItems,
    required this.onLogin,
    required this.onIncrement,
    required this.onAddToCart,
  });

  factory MyViewModel.fromStore(Store<AppState> store) {
    return MyViewModel(
      isLoggedIn: store.state.auth.loggedIn,
      count: store.state.counter.count,
      cartItems: store.state.cart.items,
      onLogin: () => store.dispatch(LoginAction()),
      onIncrement: () => store.dispatch(IncrementAction()),
      onAddToCart: (item) => store.dispatch(AddItemAction(item)),
    );
  }
}
```

##### ✅ 四、常见技巧与注意事项

###### ✅ 1. 使用 `==` 优化性能

实现 `==` 和 `hashCode` 或用 `Equatable`，避免不必要重建 UI。

```dart
class MyViewModel extends Equatable {
  ...
  @override
  List<Object?> get props => [isLoggedIn, count, cartItems];
}
```

✅ 2. 使用 `distinct: true` 避免重复 build

```dart
StoreConnector<AppState, MyViewModel>(
  distinct: true, // 只有当 ViewModel 改变时才 rebuild
  converter: ...,
  builder: ...,
)
```

> ⚠️ 前提：你的 ViewModel 必须实现正确的 `==`

✅ 3. 拆分局部 ViewModel

如果某个小部件只依赖 `counter`，可以定义小型 ViewModel，减少 rebuild 粒度：

```dart
StoreConnector<AppState, int>(
  converter: (store) => store.state.counter.count,
  builder: (context, count) => Text('$count'),
)
```

✅ 4. 将所有业务逻辑从 UI 层抽离到 ViewModel

```dart
ElevatedButton(
  onPressed: vm.onAddToCart, // 不写 store.dispatch(...)
  child: Text("加购物车"),
)
```

> 这让 UI 更像“纯 View”，不含状态操作。

✅ 5. 可以测试 ViewModel 的逻辑

```dart
final store = Store<AppState>(...);
final vm = MyViewModel.fromStore(store);

test('登录后状态变更', () {
  vm.onLogin();
  expect(store.state.auth.loggedIn, true);
});
```

##### ✅ 五、什么时候不用 ViewModel？

- 很小的 App 或 UI 页面很简单时（状态少）
- 无状态展示组件，如 `LoadingSpinner` 等

但中大型项目，强烈建议用 `ViewModel + StoreConnector` 模式。

##### ✅ 六、结论：ViewModel 模式的核心价值

| 优点             | 描述                                      |
| ---------------- | ----------------------------------------- |
| ✅ 让 UI 无状态化 | `Widget` 不感知任何 `store`，只接受 props |
| ✅ 清晰职责划分   | 状态转换逻辑集中在 ViewModel 中           |
| ✅ 更易测试       | UI 可以 mock ViewModel 测试渲染逻辑       |
| ✅ 性能更优       | 可细粒度控制更新、避免冗余 build          |

------

#### ✅ 5. **多个子模块 state 的拆分（State 树）**

在 Redux 中进行多个子模块 `State` 的拆分，是构建**大型 Flutter Redux 项目**的基础。

##### ✅ 一、什么是 State 拆分？

> 将全局状态 `AppState` 拆分成多个子模块状态（如 `AuthState`、`CounterState`、`CartState`），每个模块各自维护自己的状态、Action 和 Reducer，最终组合成一个全局状态树。

##### ✅ 二、典型结构示意（项目拆分）

```dart
AppState {
  AuthState auth,
  CounterState counter,
  CartState cart,
}
```

##### ✅ 三、示例：拆出 `Auth + Counter + Cart` 三个模块

1️⃣ AppState.dart

```dart
class AppState {
  final AuthState auth;
  final CounterState counter;
  final CartState cart;

  AppState({
    required this.auth,
    required this.counter,
    required this.cart,
  });

  static AppState initial() => AppState(
        auth: AuthState.initial(),
        counter: CounterState.initial(),
        cart: CartState.initial(),
      );
}
```

##### ✅ 四、每个子模块包含什么？

每个模块应当包含以下三部分：

| 文件               | 内容                             |
| ------------------ | -------------------------------- |
| `xxx_state.dart`   | 状态数据结构                     |
| `xxx_actions.dart` | 所有该模块相关 Action 类型       |
| `xxx_reducer.dart` | 专属 reducer，只处理自己的 state |

##### ✅ 五、示例：Cart 模块（购物车）

**cart_state.dart**

```dart
class CartState {
  final List<String> items;

  CartState({required this.items});

  CartState copyWith({List<String>? items}) {
    return CartState(items: items ?? this.items);
  }

  static CartState initial() => CartState(items: []);
}
```

**cart_actions.dart**

```dart
class AddItemAction {
  final String item;
  AddItemAction(this.item);
}

class RemoveItemAction {
  final String item;
  RemoveItemAction(this.item);
}
```

**cart_reducer.dart**

```dart
import 'cart_state.dart';
import 'cart_actions.dart';

CartState cartReducer(CartState state, dynamic action) {
  if (action is AddItemAction) {
    return state.copyWith(items: List.from(state.items)..add(action.item));
  } else if (action is RemoveItemAction) {
    return state.copyWith(items: List.from(state.items)..remove(action.item));
  }
  return state;
}
```

##### ✅ 六、在总 Reducer 中组合

**reducers.dart**

```dart
import 'auth/auth_reducer.dart';
import 'counter/counter_reducer.dart';
import 'cart/cart_reducer.dart';
import 'app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    auth: authReducer(state.auth, action),
    counter: counterReducer(state.counter, action),
    cart: cartReducer(state.cart, action),
  );
}
```

##### ✅ 七、在 UI 层访问子状态

```dart
StoreConnector<AppState, _ViewModel>(
  converter: (store) => _ViewModel(
    isLoggedIn: store.state.auth.loggedIn,
    count: store.state.counter.count,
    cartItems: store.state.cart.items,
  ),
  builder: (context, vm) => ...
)
```

##### 🎯 八、State 拆分技巧与注意事项

|技巧	                           |说明|
|--|--|
|✅ 保持每个模块状态独立	         |每个 State 仅维护自己数据，互不干扰|
|✅ 所有状态都必须初始值	         |每个模块必须有 initial() 方法|
|✅ 不要跨模块访问状态	           |不能在 cartReducer 中访问 auth 的状态|
|✅ 状态命名清晰	               |如 auth.loggedIn、cart.items，不要混乱结构|
|✅ 模块目录结构标准化	           |每个模块文件夹三件套：state + actions + reducer|
|✅ 配合 ViewModel 封装访问逻辑	 |UI 层不要直接操作 state.xxx.xxx，通过 VM 抽象简洁|

##### ✅ 九、可选：嵌套模块结构（高级）

甚至可以这样嵌套：

```dart
AppState {
  user: {
    profile: {...},
    settings: {...}
  },
  cart: {...}
}
```

这种情况下，你需要在 `userReducer` 中进一步拆分 `profileReducer` 和 `settingsReducer`，使用 `combineReducers` 组合子 reducer。

##### ✅ 十、总结：State 拆分带来的优势

| 优势       | 描述                               |
| ---------- | ---------------------------------- |
| 🎯 更易维护 | 每个模块只管理自己的状态和 reducer |
| 🎯 更清晰   | 状态结构层级明确，不混乱           |
| 🎯 更易测试 | 每个模块可以单独单元测试           |
| 🎯 更易扩展 | 新模块只需增加 reducer，不改原代码 |



------



#### ✅ 6. **持久化（如本地缓存）**

在 Flutter 中使用 Redux 时，**实现状态持久化（Redux Persistence）**可以让用户数据在应用关闭后仍能保留，比如登录状态、购物车、设置偏好等。

##### ✅ 一、持久化 Redux 状态的常用方式

| 方式                                   | 描述                                    |
| -------------------------------------- | --------------------------------------- |
| `shared_preferences` + `redux_persist` | ✅ 最推荐，支持自动保存和恢复            |
| 自定义 `middleware` + 手动写入本地     | 灵活但麻烦，适合特殊场景                |
| 使用 `hydrated_redux`                  | 类似 `hydrated_bloc`，不过支持不如 BLoC |

##### ✅ 二、推荐方案：使用 `redux_persist` + `shared_preferences`

📦 添加依赖：

```yaml
dependencies:
  redux: ^5.0.0
  flutter_redux: ^0.10.0
  redux_persist: ^0.8.3
  redux_persist_flutter: ^0.8.3
  shared_preferences: ^2.0.15
```

##### ✅ 三、持久化流程图

```dart
+-----------------+
| App 启动        |
+--------+--------+
         |
         v
+--------v--------+      +-------------------------+
| 读取本地存储的  |<-----| shared_preferences      |
| JSON State      |      +-------------------------+
+--------+--------+
         |
         v
+--------v--------+
| 初始化 Redux    |
| Store，注入     |
| middleware +    |
| persistedState  |
+--------+--------+
         |
         v
+--------v--------+
| UI 使用状态     |
+-----------------+

```

##### ✅ 四、完整示例代码（精简版）

1️⃣ `app_state.dart`

```dart
import 'dart:convert';

class AppState {
  final bool loggedIn;

  AppState({required this.loggedIn});

  AppState copyWith({bool? loggedIn}) {
    return AppState(loggedIn: loggedIn ?? this.loggedIn);
  }

  static AppState initial() => AppState(loggedIn: false);

  Map<String, dynamic> toJson() => {'loggedIn': loggedIn};
  static AppState fromJson(dynamic json) =>
      AppState(loggedIn: json['loggedIn'] ?? false);
}
```

2️⃣ `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'app_state.dart';

class LoginAction {}

AppState reducer(AppState state, dynamic action) {
  if (action is LoginAction) {
    return state.copyWith(loggedIn: true);
  }
  return state;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final persistor = Persistor<AppState>(
    storage: FlutterStorage(),
    serializer: JsonSerializer<AppState>(AppState.fromJson),
  );

  final initialState = await persistor.load();

  final store = Store<AppState>(
    reducer,
    initialState: initialState ?? AppState.initial(),
    middleware: [persistor.createMiddleware()],
  );

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Redux 持久化',
        home: StoreConnector<AppState, bool>(
          converter: (store) => store.state.loggedIn,
          builder: (context, loggedIn) => Scaffold(
            appBar: AppBar(title: Text('Redux 持久化')),
            body: Center(
              child: loggedIn
                  ? Text('✅ 已登录')
                  : ElevatedButton(
                      onPressed: () =>
                          store.dispatch(LoginAction()),
                      child: Text('登录')),
            ),
          ),
        ),
      ),
    );
  }
}
```

##### ✅ 五、注意事项和技巧

| ⚠️ 项目                                       | 建议                                               |
| -------------------------------------------- | -------------------------------------------------- |
| 只保存需要的字段                             | 不建议保存整个 UI 状态，只保存核心业务数据         |
| 避免存储 Widget、Function、Controller 等类型 | JSON 序列化失败                                    |
| 大状态建议拆模块持久化                       | 如 userState.toJson()、cartState.toJson() 分开管理 |
| 状态变化频繁时考虑节流（Throttle）           | 否则频繁写入磁盘会影响性能                         |
| 支持版本迁移处理                             | 新字段建议加默认值，否则老版本 json 会报错         |
| 使用 debugPrint() 打印序列化日志调试         | 查看是否正确持久化与加载                           |

##### ✅ 七、结语

状态持久化是 Redux 应用走向**真实业务场景**的必经之路。

| 能力             | 带来好处                    |
| ---------------- | --------------------------- |
| ✅ 状态恢复       | 提升用户体验                |
| ✅ 离线缓存       | 支持断网操作                |
| ✅ 重启不丢失数据 | 支持会话继续                |
| ✅ 状态回放与测试 | 可导出 JSON 做 diff、测试等 |



-------------------

#### 🚀 总结：进阶 Redux 用法清单

| 用法               | 说明                          | 示例/关键方法                     |
| ------------------ | ----------------------------- | --------------------------------- |
| Middleware         | 拦截 Action，做日志或异步处理 | loggingMiddleware、redux_thunk    |
| Thunk Action       | 异步调用网络接口              | ThunkAction<AppState>             |
| ViewModel          | 抽离 UI 与状态逻辑            | StoreConnector -> ViewModel       |
| combineReducers    | 拆分多个模块的 reducer        | combineReducers([...])            |
| State 模块化       | 拆分不同模块状态              | AppState(counterState, authState) |
| 状态持久化（存储） | 保存状态到本地                | 通过 Middleware 存入本地存储      |
| 嵌套模块结构       | 深度模块化状态管理            | nested state + nested reducers    |

------

### 📁 完整示例目录结构

为了方便理解和使用 Redux 的各种特性，项目中提供了以下完整的示例目录：

#### ✅ 1. `base_example` - 基础计数器示例
- **功能**：演示 Redux 基本用法，包含 increment、decrement、reset 操作
- **特点**：使用 ViewModel 模式，代码结构清晰
- **文件**：`redux_base_example.dart`

#### ✅ 2. `midware_redux_example` - 中间件示例
- **功能**：演示多个中间件的使用，包括日志、权限校验、异步处理、通知
- **特点**：多个中间件组合使用，实现登录验证和异步点赞功能
- **文件**：
  - `pages/midware_page.dart` - UI 页面
  - `redux/middleware.dart` - 中间件实现
  - `redux/mw_actions.dart` - 动作定义
  - `redux/mw_app_state.dart` - 状态定义
  - `redux/mw_reduces.dart` -  reducer 实现

#### ✅ 3. `combine_reducers_example` - 模块化 reducer 示例
- **功能**：演示使用 combineReducers 模式管理多个状态模块
- **特点**：包含 AuthState、CounterState、UserState 三个独立模块
- **文件**：
  - `pages/combine_reducers_page.dart` - UI 页面
  - `redux/app_state.dart` - 模块化状态结构
  - `redux/actions.dart` - 模块化动作定义
  - `redux/reducers.dart` - 组合 reducer 实现

#### ✅ 4. `redux_persistence_example` - 状态持久化示例
- **功能**：演示使用 redux_persist 实现状态持久化
- **特点**：支持状态保存到本地，应用重启后自动恢复
- **文件**：
  - `pages/redux_persistence_page.dart` - UI 页面
  - `redux/app_state.dart` - 支持序列化的状态结构
  - `redux/actions.dart` - 持久化相关动作
  - `redux/reducers.dart` - 持久化支持的 reducer

#### ✅ 5. `nested_modules_example` - 嵌套模块结构示例
- **功能**：演示深度嵌套的状态结构和 reducer 组合
- **特点**：包含多层嵌套的状态模块，如 User -> Profile -> Address
- **文件**：
  - `pages/nested_modules_page.dart` - UI 页面
  - `redux/app_state.dart` - 嵌套状态结构
  - `redux/actions.dart` - 嵌套模块动作
  - `redux/reducers.dart` - 嵌套 reducer 实现

#### ✅ 6. `viewmodel_example` - ViewModel 映射示例
- **功能**：演示 StoreConnector 和 ViewModel 模式的最佳实践
- **特点**：清晰的 UI 与状态逻辑分离，支持性能优化
- **文件**：
  - `pages/viewmodel_example_page.dart` - UI 页面
  - `redux/app_state.dart` - 状态结构
  - `redux/actions.dart` - 动作定义
  - `redux/reducers.dart` - reducer 实现

#### ✅ 7. `thunk_example` - 异步操作示例
- **功能**：演示使用 redux_thunk 处理复杂异步操作
- **特点**：包含加载状态、错误处理、异步数据获取
- **文件**：
  - `pages/thunk_example_page.dart` - UI 页面
  - `redux/app_state.dart` - 支持异步状态的结构
  - `redux/actions.dart` - 包含 ThunkAction 定义
  - `redux/reducers.dart` - 处理异步状态的 reducer

### 🎯 示例使用指南

1. **运行单个示例**：每个示例都有独立的 `..._example_app.dart` 文件，可以直接运行
2. **查看代码结构**：每个示例都遵循相同的目录结构，便于理解和对比
3. **学习最佳实践**：示例中包含了 Redux 的各种最佳实践，如模块化设计、清晰的状态命名、ViewModel 模式等
4. **扩展功能**：可以基于示例代码扩展自己的业务逻辑

### 📚 参考资源

- **Redux 官方文档**：https://redux.js.org/
- **Flutter Redux 文档**：https://pub.dev/packages/flutter_redux
- **Redux Thunk 文档**：https://pub.dev/packages/redux_thunk
- **Redux Persist 文档**：https://pub.dev/packages/redux_persist

### 🔧 版本依赖

```yaml
dependencies:
  flutter_redux: ^0.10.0
  redux: ^5.0.0
  redux_thunk: ^0.4.0
  redux_persist: ^0.8.3
  redux_persist_flutter: ^0.8.3
```

### 🎉 总结

通过以上示例，你可以全面了解 Redux 在 Flutter 中的应用，从基础用法到高级特性，包括：

- **基础架构**：State、Action、Reducer、Store 的核心概念
- **进阶特性**：Middleware、Thunk、ViewModel、combineReducers
- **高级用法**：状态持久化、模块化设计、嵌套状态结构
- **最佳实践**：代码组织、性能优化、错误处理

Redux 虽然学习曲线较陡，但在管理复杂状态的大型应用中，其清晰的数据流和可预测性会带来显著的开发效率和维护性提升。
