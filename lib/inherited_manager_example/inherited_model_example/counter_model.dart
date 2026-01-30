import 'package:flutter/material.dart';

/// 当你希望部分子组件只在特定“维度”发生变化时才更新，使用 InheritedModel 更加合适，它比
// InheritedWidget更细粒度地控制刷新逻辑。
class CounterModel extends InheritedModel<String> {
  final int sumA;
  final int sumB;

  const CounterModel({
    super.key,
    required this.sumA,
    required this.sumB,
    required super.child,
  });

  static CounterModel? of(BuildContext context, String aspect) {
    return InheritedModel.inheritFrom<CounterModel>(context, aspect: aspect);
  }

  @override
  bool updateShouldNotify(covariant CounterModel oldWidget) {
    return sumA != oldWidget.sumA || sumB != oldWidget.sumB;
  }

  // 判断哪些维度aspect变更
  @override
  bool updateShouldNotifyDependent(
    covariant CounterModel oldWidget,
    Set<String> dependencies,
  ) {
    if (dependencies.contains('A') && sumA != oldWidget.sumA) return true;
    if (dependencies.contains('B') && sumB != oldWidget.sumB) return true;
    return false;
  }
}
