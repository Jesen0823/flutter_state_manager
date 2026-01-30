
import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// 消息模型
class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

// 模拟聊天服务
class ChatService {
  // 模拟获取聊天消息流
  static Stream<ChatMessage> getMessageStream() {
    return Stream.periodic(const Duration(seconds: 2), (count) {
      final isUser = count % 2 == 0;
      final messages = [
        '你好！',
        '你好，有什么可以帮助你的吗？',
        '我想了解一下Riverpod',
        'Riverpod是一个很好的状态管理库，由Provider的作者开发。',
        '它有哪些特点？',
        '它提供了编译时安全、测试友好、灵活的依赖注入等特性。',
        '听起来不错，我会试试的。',
        '祝你使用愉快！',
      ];

      final messageIndex = count % messages.length;
      return ChatMessage(
        id: DateTime.now().toString(),
        text: messages[messageIndex],
        isUser: isUser,
        timestamp: DateTime.now(),
      );
    });
  }

  // 模拟发送消息
  static Future<ChatMessage> sendMessage(String text) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 500));

    return ChatMessage(
      id: DateTime.now().toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
  }
}

// 聊天消息 Provider
final chatMessagesProvider = StreamProvider<ChatMessage>((ref) {
  return ChatService.getMessageStream();
});

// 聊天控制器 Provider
final chatControllerProvider = NotifierProvider<ChatController, List<ChatMessage>>(
  ChatController.new,
);

class ChatController extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() {
    return [];
  }

  // 添加消息
  void addMessage(ChatMessage message) {
    state = [...state, message];
  }

  // 发送消息
  Future<void> sendMessage(String text) async {
    final message = await ChatService.sendMessage(text);
    addMessage(message);
  }

  // 清空消息
  void clearMessages() {
    state = [];
  }
}
