import 'package:flutter/material.dart';
import 'package:state_manager/riverpod_example/future_example/user_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverFutureExampleApp extends StatelessWidget {
  const RiverFutureExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'User Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const UserScreen(),
      ),
    );
  }
}

