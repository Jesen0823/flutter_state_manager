import 'package:flutter/material.dart';
import 'package:state_manager/riverpod_example/family_example/user_screen.dart';

class RiverpodFamilyExampleApp extends StatelessWidget {
  const RiverpodFamilyExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: FamilyExampleScreen(),);
  }
}
