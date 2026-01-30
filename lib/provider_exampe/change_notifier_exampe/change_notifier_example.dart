import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_manager/provider_exampe/change_notifier_exampe/provider_counter_model.dart';

class ChangeNotifierExample extends StatelessWidget {
  const ChangeNotifierExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Provider案例-ChangeNotifier')),
      body: Center(
        // Consumer监听变化
        child: Consumer<ProviderCounterModel>(
          builder: (_, model, _) => Text('Count: ${model.count}'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.read<ProviderCounterModel>().increment(),
      ),
    );
  }
}
