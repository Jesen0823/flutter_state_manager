import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_manager/riverpod_example/base_example/river_counter_notifier.dart';

class RiverCounterApp extends StatelessWidget {
  const RiverCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: RiverCounterExample(),);
  }
}

class RiverCounterExample extends ConsumerWidget {
  const RiverCounterExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = useCounter(ref);

    return Scaffold(
      appBar: AppBar(title: const Text('抽离逻辑示例')),
      body: Center(
        child: Text('Count: $count', style: TextStyle(fontSize: 24)),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'add',
            onPressed: () => incrementCounter(ref), // 👈 抽离的操作方法
            child: Icon(Icons.add),
          ),
          const SizedBox(width: 10),
          FloatingActionButton.small(
            heroTag: 'reset',
            onPressed: () => resetCounter(ref), // 👈 抽离 reset 方法
            child: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
