import 'package:flutter/material.dart';
import 'package:state_manager/provider_exampe/widget_local_provider/toggle_switch_widget.dart';
/// 局部 Provider 的基本用法
class LocalProviderWidget extends StatelessWidget {
  const LocalProviderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("局部组件 Provider")),
      body: Center(child: ToggleSwitchWidget()),
    );
  }
}
