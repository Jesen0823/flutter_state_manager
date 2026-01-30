import 'package:flutter/material.dart';
import 'package:state_manager/inherited_manager_example/inherited_model_example/counter_model.dart';

/// 俩个子组件分别监听model不同的维度
/// B监听B的
class CounterBWidget extends StatelessWidget {
  const CounterBWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = CounterModel.of(context, 'B');
    return Text(
      '计数器B: ${model?.sumB}',
      style: const TextStyle(fontSize: 24, color: Colors.deepOrange),
    );
  }
}
