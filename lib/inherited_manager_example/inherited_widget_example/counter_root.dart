import 'package:flutter/material.dart';
import 'package:state_manager/inherited_manager_example/inherited_widget_example/counter_provider.dart';

import 'counter_screen.dart';

class CounterRoot extends StatefulWidget {
  const CounterRoot({super.key});

  @override
  State<CounterRoot> createState() => _CounterRootState();
}

class _CounterRootState extends State<CounterRoot> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return CounterProvider(
      counter: _counter,
      increment: _incrementCounter,
      child: CounterScreen(),
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
}
