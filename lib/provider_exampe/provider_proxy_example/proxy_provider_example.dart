
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ProxyProvider<T, R>：创建依赖于其他Provider的Provider
/// 适用于需要根据其他状态计算出的派生状态
/// 当依赖的Provider发生变化时，会自动重新计算派生状态

// 基础计数器Provider
class CounterModel extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

// 派生状态：计数器的平方值
class SquareModel {
  final int value;

  SquareModel(this.value);
}

class ProxyProviderExample extends StatelessWidget {
  const ProxyProviderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 提供基础计数器
        ChangeNotifierProvider<CounterModel>(
          create: (_) => CounterModel(),
        ),
        // 提供派生状态：计数器的平方值
        ProxyProvider<CounterModel, SquareModel>(
          update: (_, counter, __) => SquareModel(counter.count * counter.count),
        ),
      ],
      child: MaterialApp(
        title: 'ProxyProvider Example',
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
        title: const Text('Counter with ProxyProvider'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 计数器显示
            CounterDisplay(),
            const SizedBox(height: 20),
            // 平方值显示
            SquareDisplay(),
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
    final counter = context.watch<CounterModel>();

    return Column(
      children: [
        const Text(
          'Current Count:',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        Text(
          '${counter.count}',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class SquareDisplay extends StatelessWidget {
  const SquareDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final square = context.watch<SquareModel>();

    return Column(
      children: [
        const Text(
          'Square Value:',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        Text(
          '${square.value}',
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
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
    final counter = context.read<CounterModel>();

    return ElevatedButton(
      onPressed: () => counter.increment(),
      child: const Text('Increment Counter'),
    );
  }
}

// 更复杂的ProxyProvider示例：根据多个Provider计算派生状态
class ComplexProxyExample extends StatelessWidget {
  const ComplexProxyExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CounterModel>(
          create: (_) => CounterModel(),
        ),
        // 另一个计数器
        ChangeNotifierProvider<CounterModel>(
          create: (_) => CounterModel(),
        ),
        // 计算两个计数器的和
        ProxyProvider2<CounterModel, CounterModel, int>(
          update: (_, counter1, counter2, __) => counter1.count + counter2.count,
        ),
      ],
      child: MaterialApp(
        title: 'Complex ProxyProvider Example',
        home: ComplexCounterScreen(),
      ),
    );
  }
}

class ComplexCounterScreen extends StatelessWidget {
  const ComplexCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final counters = context.read<List<CounterModel>>();
    final sum = context.watch<int>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complex ProxyProvider Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sum: $sum',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => context.read<CounterModel>().increment(),
                  child: const Text('Increment Counter 1'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => context.read<List<CounterModel>>()[1].increment(),
                  child: const Text('Increment Counter 2'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
