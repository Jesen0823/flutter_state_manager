# state_manager

A new Flutter project of all stateManager.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

------

# 🦩Flutter的状态管理



| 状态管理方式                       | 官方/文档链接                                                |
| ---------------------------------- | ------------------------------------------------------------ |
| ✅ setState（Flutter 原生）         | [Flutter 官方文档 - Managing State](https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple) |
| ✅ InheritedWidget / InheritedModel | [InheritedWidget 官方文档](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html) |
| ✅ Provider                         | [Provider 官网（pub.dev）](https://pub.dev/packages/provider) \ [Flutter 官方推荐 Provider 教程](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple#using-provider) |
| ✅ Riverpod                         | [Riverpod 官网](https://riverpod.dev/) \ [Riverpod pub.dev 页面](https://pub.dev/packages/flutter_riverpod) |
| ✅ BLoC / Cubit                     | [Bloc 官方文档](https://bloclibrary.dev/) \ [bloc pub.dev 页面](https://pub.dev/packages/flutter_bloc) |
| ✅ GetX                             | [GetX GitHub](https://github.com/jonataslaw/getx)\  [官网 GetX pub.dev 页面](https://github.com/jonataslaw/getx) |
| ✅ MobX                             | [MobX Flutter 官网](https://mobx.netlify.app/) \  [mobx pub.dev 页面](https://pub.dev/packages/mobx) |
| ✅ Redux                            | [Redux pub.dev 页面](https://pub.dev/packages/flutter_redux) \ [Dart Redux GitHub](https://pub.dev/packages/flutter_redux) |



### 一、`setState`（Flutter 原生）

#### ✅ 优点

- 简单易用，适合小范围的状态更新
- 无需依赖第三方库
- 上手门槛低

#### ❌ 缺点

- 状态无法在多个组件间共享
- 不适合大型项目或复杂状态管理

#### 📌 使用场景

- 小型应用
- 单页面局部状态更新（如按钮点击计数）

#### 🔤 示例

```dart
class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('$count')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => count++),
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### 二、`InheritedWidget / InheritedModel`

#### ✅ 优点

- 无需第三方库
- 能实现父子组件间的状态共享

#### ❌ 缺点

- 写法繁琐
- 可读性差
- 不适合大量状态或深层组件传递

#### 📌 使用场景

- 只依赖原生 Flutter 的中小型项目
- 自定义组件通信



### 三、`Provider`（官方推荐）

#### ✅ 优点

- 简单、灵活
- 社区活跃，文档丰富
- 支持依赖注入、监听、响应式编程

#### ❌ 缺点

- 不适合复杂状态流转（比如状态分支、加载中/成功/失败）
- 一旦业务复杂，可能需要组合其他模式（如 BLoC）

#### 📌 使用场景

- 中等复杂度的应用
- 与 ChangeNotifier 搭配管理 UI 状态

#### 🔤 示例

```dart
class Counter with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Counter(),
      child: MyApp(),
    ),
  );
}

// 在 Widget 中使用
Consumer<Counter>(
  builder: (_, counter, __) => Text('${counter.count}'),
)
```

### 四、`Riverpod`（[Provider](https://so.csdn.net/so/search?q=Provider&spm=1001.2101.3001.7020) 的改进版）

#### ✅ 优点

- 更安全（无需上下文，避免 memory leak）
- 支持组合 Provider（组合逻辑强）
- 支持异步状态管理（StateNotifier、AsyncValue）

#### ❌ 缺点

- 学习曲线略高
- 初学者不如 Provider 直观

#### 📌 使用场景

- 中大型项目
- 多个模块状态共享
- 更清晰的业务分离



### 五、`BLoC / Cubit`（业务逻辑分离）

#### ✅ 优点

- 明确的状态流转（事件 -> 状态）
- 更适合功能复杂、业务重的项目
- 单元测试方便

#### ❌ 缺点

- 学习成本高
- 代码冗长

#### 📌 使用场景

- 企业级应用
- 明确的状态转换需求
- 项目需要良好测试覆盖率

#### 🔤 Cubit 示例（简化版 BLoC）

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
}
```

### 六、`GetX`（轻量、高性能）

#### ✅ 优点

- 语法简洁
- 控制器不依赖上下文，逻辑分离清晰
- 状态管理 + 路由管理 + DI 一体化

#### ❌ 缺点

- 过于灵活，容易滥用
- 隐式魔法多，可维护性差（对于大团队）

#### 📌 使用场景

- 中小型应用快速开发
- 需要快速迭代 MVP 项目

#### 🔤 示例

```dart
class CounterController extends GetxController {
  var count = 0.obs;
  void increment() => count++;
}

// Widget 中使用
Obx(() => Text('${controller.count}'))
```

### 七、`MobX`（响应式，类似 Vue/React）

#### ✅ 优点

- 观察者自动响应状态变化
- 响应式数据绑定

#### ❌ 缺点

- 需要代码生成器
- 使用较复杂，对响应式原理需要理解

### 八、`Redux`（函数式管理，历史悠久）

#### ✅ 优点

- 单一状态树，方便调试
- 时间旅行、日志记录强大

#### ❌ 缺点

- 写法繁琐
- 状态流转抽象化，维护成本高

#### 📌 使用场景

- 多模块状态统一管理
- 需要历史状态回溯或日志调试



### 🦜 总结对比表

| 状态管理方式 | 上手难度 | 状态共享 | 适合场景           | 优点                   | 缺点             |
| ------------ | -------- | -------- | ------------------ | ---------------------- | ---------------- |
| setState     | ⭐        | ❌        | 小组件             | 简单直接               | 不能跨组件       |
| Provider     | ⭐⭐       | ✅        | 中小型项目         | 社区活跃，灵活         | 管理复杂状态困难 |
| Riverpod     | ⭐⭐⭐      | ✅        | 中大型项目         | 安全、组合强           | 学习曲线略高     |
| BLoC / Cubit | ⭐⭐⭐⭐     | ✅        | 企业级、大型项目   | 状态清晰，便于测试     | 写法繁琐         |
| GetX         | ⭐⭐       | ✅        | 快速开发           | 快、全、轻             | 可维护性争议     |
| MobX         | ⭐⭐⭐      | ✅        | 响应式需求项目     | 自动追踪状态变化       | 依赖代码生成     |
| Redux        | ⭐⭐⭐⭐     | ✅        | 非常复杂的大型项目 | 调试强大，状态集中管理 | 写法冗长，门槛高 |

## 🐸 企业级方案如何选择

在 Flutter 商业开发中，状态管理方案的选择受项目规模、团队技术背景、开发效率需求以及国内外技术生态差异等因素影响。近两年来（2023-2025），国内外市场的流行趋势和选择逻辑呈现出一定差异，以下是具体分析：


### **一、国外市场：更倾向“专注、规范、可扩展”的方案**
国外开发者和企业更注重架构的规范性、可维护性和社区长期支持，主流选择集中在 **Riverpod** 和 **BLoC**，具体如下：

1. **Riverpod**  
   近年来国外最流行的状态管理方案，由 `Provider` 的作者 Remi Rousselet 开发，解决了 `Provider` 的诸多痛点（如依赖管理混乱、类型不安全等）。  
   - 优势：**自动依赖注入**、**编译时类型安全**、**原生支持异步状态**（如网络请求）、**测试友好**，且与 Flutter 官方工具链（如 `flutter_lints`）兼容性极佳。  
   - 适用场景：中小型到大型项目均适用，尤其适合需要清晰状态依赖关系的团队。  
   - 趋势：近两年快速替代 `Provider`，成为国外社区推荐的“首选轻量方案”，在 GitHub 星标数和 Stack Overflow 问题量上增长迅猛。

2. **BLoC (flutter_bloc)**  
   长期占据国外企业级开发的主流地位，由社区知名开发者 Felix Angelov 维护，基于“事件-状态”流（Stream）设计，严格分离 UI 与业务逻辑。  
   - 优势：**架构严谨**（符合 Clean Architecture 思想）、**可预测性强**（单向数据流）、**适合大型团队协作**（代码规范统一）。  
   - 适用场景：大型商业项目（如金融、医疗类 App），尤其是需要长期维护、多人协作的场景。  
   - 趋势：虽然学习曲线略陡，但凭借成熟的生态（配套工具、文档、企业案例），依然是国外大型项目的稳定选择。

3. 其他方案的现状：  
   - `Provider`：因 Riverpod 的崛起，新项目已较少采用，但存量项目仍在维护。  
   - `Redux`：因样板代码过多，仅在需要严格遵循“单向数据流”且团队有 React Redux 经验的场景中使用，整体趋势下滑。  
   - `MobX`：依赖代码生成，灵活性较低，近年被 Riverpod 挤压，使用量持续减少。  


### **二、国内市场：更追求“高效、全能、低学习成本”的方案**
国内商业开发更注重开发效率和“一站式解决方案”，主流选择集中在 **GetX** 和 **BLoC**，同时 **Riverpod** 近年也在快速渗透：

1. **GetX**  
   国内最流行的状态管理方案，不仅是状态管理工具，还集成了路由管理、依赖注入、国际化等功能，形成“全能型框架”。  
   - 优势：**API 简洁**（无需大量样板代码）、**学习成本低**（单文件即可完成状态+路由）、**开发效率极高**，适合快速迭代的商业项目。  
   - 适用场景：中小型项目、创业公司项目，或需要“一人多岗”快速交付的场景。  
   - 趋势：近两年来在国内保持绝对热度，GitHub 星标数（国内贡献占比高）和技术社区（如掘金、知乎）讨论量远超其他方案，是国内中小团队的首选。

2. **BLoC (flutter_bloc)**  
   在国内大型企业（如阿里、腾讯部分业务线）中仍被广泛使用，尤其适合对架构规范性要求高的项目。  
   - 优势：与国外相同，架构严谨，适合多人协作和长期维护，且国内有成熟的落地案例（如电商 App 复杂状态管理）。  
   - 趋势：虽然开发效率低于 GetX，但在对代码质量要求严格的大型项目中仍不可替代。

3. **Riverpod**  
   近年在国内快速崛起，主要被有国外技术背景或追求“现代 Flutter 最佳实践”的团队采用。  
   - 优势：结合了 `Provider` 的简单和 `BLoC` 的严谨，同时解决了 GetX 被部分开发者诟病的“过度封装、灵活性不足”问题。  
   - 趋势：随着国内开发者对“类型安全”“测试友好”的重视，Riverpod 正在成为中大型项目的新选择，社区教程和案例逐年增多。

4. 其他方案的现状：  
   - `GetX` 几乎垄断国内中小项目，`MobX` `Redux` 因效率或复杂度问题，仅在存量项目中可见。  
   - `InheritedWidget` 作为 Flutter 原生组件，更多是其他方案（如 Provider）的底层依赖，极少直接用于业务开发。  


### **三、新项目如何选择？核心考量因素**
1. **项目规模**  
   - 小型项目/快速验证：优先 **GetX**（国内）或 **Riverpod**（国外），兼顾效率与简洁。  
   - 中大型项目/长期维护：优先 **BLoC** 或 **Riverpod**，确保架构可扩展、团队协作顺畅。

2. **团队背景**  
   - 团队熟悉“全能框架”“快速开发”：选 **GetX**（国内）。  
   - 团队注重“类型安全”“测试驱动开发”：选 **Riverpod**。  
   - 团队习惯“严格分层架构”：选 **BLoC**。

3. **生态与社区支持**  
   - 国外：优先 **Riverpod**（社区活跃，官方互动多）、**BLoC**（生态成熟）。  
   - 国内：优先 **GetX**（资料丰富，问题易解决）、**BLoC**（大型项目案例多）。  


### **总结**
- **国外**：近两年 **Riverpod** 成为新宠，**BLoC** 稳定输出，二者共同主导商业开发。  
- **国内**：**GetX** 仍是中小项目首选，**BLoC** 稳居大型项目，**Riverpod** 快速增长。  

选择时无需盲目跟风，需结合团队实际需求——效率优先选 GetX/Riverpod，规范优先选 BLoC/Riverpod，确保“工具适配项目”而非“项目适配工具”。