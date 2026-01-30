
import 'package:flutter/material.dart';

import 'app_state_widget.dart';
/// AppState 作为统一状态容器，使用 copyWith 简化变更。
// ✅ AppStateWidget.of(context) 提供全局访问能力。
// ✅ 使用 InheritedWidget 实现数据响应更新，只有依赖该数据的 Widget 会刷新。
// ⚠️ 不适用于状态频繁变化的复杂场景
class AppStateTest extends StatelessWidget {
  const AppStateTest({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = AppStateWidget.of(context).state.counter;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("InheritedWidget Wrap Demo")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Counter: $counter"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => AppStateWidget.of(context).increment(),
                child: const Text("Increment"),
              ),
              ElevatedButton(
                onPressed: () => AppStateWidget.of(context).decrement(),
                child: const Text("Decrement"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
