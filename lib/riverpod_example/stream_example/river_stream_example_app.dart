import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_screen.dart';

class RiverStreamExampleApp extends StatelessWidget {
  const RiverStreamExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Chat Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ChatScreen(),
      ),
    );
  }
}
