import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:state_manager/mobx_example/base_example/mx_counter_store.dart';

class MxCounterExample extends StatelessWidget {
  MxCounterExample({super.key});

  final MxCounterStore store = MxCounterStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobx Counter')),
      body: Center(
        child: Observer(
          builder: (_) => Text(
            '${store.count}',
            style: const TextStyle(fontSize: 40, color: Colors.deepOrange),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: store.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
