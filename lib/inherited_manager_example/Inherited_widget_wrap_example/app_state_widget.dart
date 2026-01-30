import 'package:flutter/material.dart';

import 'app_state.dart';

/// 通用 InheritedWidget 模板，适合在项目中用于状态共享，支持 update、of() 快速访问、
/// 内部状态变更触发 rebuild，适用于小型状态管理需求
///
class AppStateWidget extends StatefulWidget {
  final Widget child;

  const AppStateWidget({super.key, required this.child});

  @override
  _AppStateWidgetState createState() => _AppStateWidgetState();

  static _AppStateWidgetState of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<_AppInherited>();
    assert(inherited != null, 'AppStateWidget not found in context');
    return inherited!.data;
  }

}

class _AppStateWidgetState extends State<AppStateWidget> {
  AppState state = AppState();

  void updateCounter(int newValue) {
    setState(() {
      state = state.copyWith(counter: newValue);
    });
  }

  void increment() {
    setState(() {
      state.counter++;
    });
  }

  void decrement() {
    setState(() {
      state.counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _AppInherited(data: this, state: state, child: widget.child);
  }
}

class _AppInherited extends InheritedWidget {
  final _AppStateWidgetState data;
  final AppState state;

  const _AppInherited(
      {super.key, required super.child, required this.data, required this.state});

  @override
  bool updateShouldNotify(covariant _AppInherited oldWidget) {
    return oldWidget.state != state;
  }
}