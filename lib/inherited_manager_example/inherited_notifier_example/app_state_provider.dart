import 'package:flutter/material.dart';

import 'new_app_state.dart';
// InheritedNotifier自动监听ChangeNotifier
/// InheritedNotifier 是 InheritedWidget 的一个子类，封装了一个 Listenable（通常是 ChangeNotifier）
/// 自动订阅 + 自动 rebuild
class AppStateProvider extends InheritedNotifier<NewAppState> {
  const AppStateProvider({
    super.key,
    required NewAppState super.notifier,
    required super.child,
  });

  static NewAppState of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(provider != null, 'AppStateProvider not found in context');
    return provider!.notifier!;
  }
}
