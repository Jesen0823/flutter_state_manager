
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ListenableProvider<T>：管理实现了Listenable接口的数据
/// 适用于自定义的Listenable实现，是ValueListenableProvider的父类
/// 当Listenable通知变化时会自动触发Widget重新构建

// 自定义的Listenable实现
class CustomListenable extends ChangeNotifier {
  int _value = 0;

  int get value => _value;

  void increment() {
    _value++;
    notifyListeners(); // 通知监听器
  }

  void decrement() {
    _value--;
    notifyListeners(); // 通知监听器
  }

  void reset() {
    _value = 0;
    notifyListeners(); // 通知监听器
  }
}

class ListenableProviderExample extends StatelessWidget {
  const ListenableProviderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableProvider<CustomListenable>(
      create: (_) => CustomListenable(),
      child: MaterialApp(
        title: 'ListenableProvider Example',
        home: CounterScreen(),
      ),
    );
  }
}

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter with ListenableProvider'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 计数器显示
            CounterDisplay(),
            const SizedBox(height: 20),
            // 控制按钮
            CounterControls(),
          ],
        ),
      ),
    );
  }
}

class CounterDisplay extends StatelessWidget {
  const CounterDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取CustomListenable并监听其变化
    final counter = context.watch<CustomListenable>();

    return Column(
      children: [
        const Text(
          'Current Count:',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        Text(
          '${counter.value}',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class CounterControls extends StatelessWidget {
  const CounterControls({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取CustomListenable但不监听其变化（仅用于修改值）
    final counter = context.read<CustomListenable>();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => counter.decrement(),
              child: const Icon(Icons.remove),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => counter.increment(),
              child: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => counter.reset(),
          child: const Text('Reset'),
        ),
      ],
    );
  }
}
