import 'package:flutter/material.dart';

import 'app_state_provider.dart';

class InheritedNotifierTest extends StatelessWidget {
  const InheritedNotifierTest({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = AppStateProvider.of(context).counter;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("InheritedNotifier Demo")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Counter: $counter"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => AppStateProvider.of(context).increment(),
                child: const Text("Increment"),
              ),
              ElevatedButton(
                onPressed: () => AppStateProvider.of(context).decrement(),
                child: const Text("Decrement"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
