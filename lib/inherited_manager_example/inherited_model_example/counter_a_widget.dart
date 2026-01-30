import 'package:flutter/material.dart';
import 'package:state_manager/inherited_manager_example/inherited_model_example/counter_model.dart';

/// 俩个子组件分别监听model不同的维度
/// A监听A的
class CounterAWidget extends StatelessWidget {
  const CounterAWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = CounterModel.of(context, 'A');
    return Text(
      '计数器A: ${model?.sumA}',
      style: const TextStyle(fontSize: 24,color: Colors.blueAccent),
    );
  }
}
