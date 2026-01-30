import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
/// 局部 Provider 的基本用法
/// 意组件中使用局部 Provider，例如一个局部开关组件
///
class ToggleModel extends ChangeNotifier {
  bool _on = false;

  bool get isOn => _on;

  void toggle() {
    _on = !_on;
    notifyListeners();
  }
}

class ToggleSwitchWidget extends StatelessWidget {
  const ToggleSwitchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ToggleModel(),
      child: Consumer<ToggleModel>(
        builder: (BuildContext context, ToggleModel model, Widget? child) =>
            Switch(value: model.isOn, onChanged: (_) => model.toggle()),
      ),
    );
  }
}
