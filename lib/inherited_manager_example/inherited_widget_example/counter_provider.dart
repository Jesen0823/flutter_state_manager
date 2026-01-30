import 'package:flutter/material.dart';

// 定义InheritedWidget 提供跨组件访问数据的能力

/// InheritedWidget是Flutter框架中一种能让子树中的Widget访问它数据的机制，通常配合
// of(context)来获取数据，当数据发生变化时，可以通知依赖它的子组件重新构建。

class CounterProvider extends InheritedWidget {
  final int counter;
  final void Function() increment;

  const CounterProvider({
    super.key,
    required this.counter,
    required this.increment,
    required super.child,
  });

  /// 判断是否通知子组件刷新
  @override
  bool updateShouldNotify(covariant CounterProvider oldWidget) {
    // counter值发生变化时，通知子树更新
    return oldWidget.counter != counter;
  }

  static CounterProvider of(BuildContext context){
    // 建立数据依赖关系，数据变化时provider的child组件就可以自动刷新了
    final provider = context.dependOnInheritedWidgetOfExactType<CounterProvider>();
    assert(provider!=null,'No CounterProvider found.');
    return provider!;
  }
}
