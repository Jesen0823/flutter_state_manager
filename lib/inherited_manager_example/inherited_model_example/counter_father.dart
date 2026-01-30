import 'package:flutter/material.dart';
import 'package:state_manager/inherited_manager_example/inherited_model_example/counter_a_widget.dart';
import 'package:state_manager/inherited_manager_example/inherited_model_example/counter_b_widget.dart';
import 'package:state_manager/inherited_manager_example/inherited_model_example/counter_model.dart';

class CounterFather extends StatefulWidget {
  const CounterFather({super.key});

  @override
  State<CounterFather> createState() => _CounterFatherState();
}

class _CounterFatherState extends State<CounterFather> {
  int _sumA = 0;
  int _sumB = 0;

  void _incrementA() {
    setState(() {
      _sumA++;
    });
  }

  void _incrementB() {
    setState(() {
      _sumB++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CounterModel(
      sumA: _sumA,
      sumB: _sumB,
      child: Scaffold(
        appBar: AppBar(title: const Text('InheritedModel 案例')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CounterAWidget(),
              const CounterBWidget(),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _incrementA, child: const Text("增加 A")),
              ElevatedButton(onPressed: _incrementB, child: const Text("增加 B")),
            ],
          ),
        ),
      ),
    );
  }
}
