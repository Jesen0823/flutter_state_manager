import 'package:flutter/material.dart';
import 'package:state_manager/inherited_manager_example/inherited_widget_example/counter_provider.dart';

// 子组件访问数据并自动刷新
class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = CounterProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('InheritedWidget案例')),
      body: Center(
        child: Text(
          '计数器：${provider.counter}',
          style: const TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: provider.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
