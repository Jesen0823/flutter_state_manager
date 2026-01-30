import 'package:flutter/material.dart';
import 'package:state_manager/provider_exampe/change_notifier_exampe/change_notifier_example.dart';
// App
class ChangeNotifierApp extends StatelessWidget {
  const ChangeNotifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierExample(),
    );
  }
}
