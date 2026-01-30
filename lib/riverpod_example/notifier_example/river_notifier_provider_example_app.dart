import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_manager/riverpod_example/notifier_example/todo_screen.dart';

class RiverNotifierProviderExampleApp extends StatelessWidget {
  const RiverNotifierProviderExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Todo Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TodoScreen(),
      ),
    );
  }
}
