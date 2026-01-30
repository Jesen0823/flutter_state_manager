import 'package:flutter/material.dart';

import 'form_screen.dart';

class RiverpodAutoDisposeExampleApp extends StatelessWidget {
  const RiverpodAutoDisposeExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: AutoDisposeExampleScreen(),);
  }
}
