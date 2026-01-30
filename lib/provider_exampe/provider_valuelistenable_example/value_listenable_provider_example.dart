import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ValueListenableProvider<T>：管理实现了ValueListenable接口的数据
/// 适用于单一值的状态管理，如计数器、开关状态等
/// 当值发生变化时会自动通知依赖它的Widget重新构建

class ValueListenableProviderExample extends StatelessWidget {
  const ValueListenableProviderExample({super.key});

  @override
  Widget build(BuildContext context) {
    final counterNotifier = ValueNotifier<int>(0);
    return ValueListenableProvider<int>.value(
      value: counterNotifier,
      child: MaterialApp(
        title: 'ValueListenableProvider Example',
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
        title: const Text('Counter with ValueListenableProvider'),
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
    // 直接获取int值
    final counter = context.watch<int>();

    return Column(
      children: [
        const Text(
          'Current Count:',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        Text(
          '$counter',
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
    // 获取ValueNotifier但不监听其变化（仅用于修改值）
    final counterNotifier = context.read<ValueNotifier<int>>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => counterNotifier.value--, // 直接修改值，会自动触发通知
          child: const Icon(Icons.remove),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () => counterNotifier.value++, // 直接修改值，会自动触发通知
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}

// 主题切换示例
class ThemeToggleExample extends StatelessWidget {
  const ThemeToggleExample({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = ValueNotifier<bool>(false); // false = 浅色主题
    return ValueListenableProvider<bool>.value(
      value: themeNotifier,
      child: Builder(
        builder: (context) {
          final isDarkMode = context.watch<bool>();
          return MaterialApp(
            title: 'Theme Toggle Example',
            theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: ThemeScreen(),
          );
        },
      ),
    );
  }
}

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<bool>();
    final themeNotifier = context.read<ValueNotifier<bool>>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Toggle'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isDarkMode ? 'Dark Mode' : 'Light Mode',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Switch(
              value: isDarkMode,
              onChanged: (value) => themeNotifier.value = value,
            ),
            const SizedBox(height: 20),
            const Text('Toggle to change theme'),
          ],
        ),
      ),
    );
  }
}
