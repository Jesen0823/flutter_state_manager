import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<ChatMessage>? _messageSubscription;

  @override
  void initState() {
    super.initState();
    // 延迟初始化聊天，避免在 widget 生命周期中修改 provider
    Future(() {
      _initializeChat();
      // 监听聊天消息流，使 chatMessagesProvider 起作用
      _startListeningToStream();
    });
  }

  // 开始监听消息流
  void _startListeningToStream() {
    // 使用 ref.read 获取流并监听
    final stream = ref.read(chatMessagesProvider.stream);
    _messageSubscription = stream.listen(
      (message) {
        // 当收到新消息时，添加到聊天控制器
        final chatController = ref.read(chatControllerProvider.notifier);
        chatController.addMessage(message);
      },
      onError: (error) {
        print('聊天消息流错误: $error');
      },
      onDone: () {
        print('聊天消息流已结束');
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _messageSubscription?.cancel();
    super.dispose();
  }

  void _initializeChat() {
    final chatController = ref.read(chatControllerProvider.notifier);

    // 添加初始消息
    _addInitialMessages(chatController);
  }

  void _addInitialMessages(dynamic chatController) {
    final initialMessages = [
      ChatMessage(
        id: '1',
        text: '你好！欢迎使用 Riverpod 聊天示例',
        isUser: false,
        timestamp: DateTime.now(),
      ),
      ChatMessage(
        id: '2',
        text: '你可以在这里发送消息，我会回复你',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];

    for (final message in initialMessages) {
      chatController.addMessage(message);
    }
  }

  Future<void> _handleSendMessage(String text) async {
    final chatController = ref.read(chatControllerProvider.notifier);

    // 添加用户消息
    await chatController.sendMessage(text);

    // 模拟回复
    _simulateReply(chatController, text);
  }

  void _simulateReply(dynamic chatController, String userMessage) {
    // 模拟网络延迟
    Future.delayed(const Duration(seconds: 1), () {
      String reply;

      // 根据用户消息生成回复
      if (userMessage.contains('你好') ||
          userMessage.contains('hi') ||
          userMessage.contains('hello')) {
        reply = '你好！有什么可以帮助你的吗？';
      } else if (userMessage.contains('Riverpod') ||
          userMessage.contains('riverpod')) {
        reply = 'Riverpod 是一个强大的状态管理库，由 Provider 的作者开发，提供了编译时安全和灵活的依赖注入。';
      } else if (userMessage.contains('谢谢') || userMessage.contains('感谢')) {
        reply = '不客气！很高兴能帮助你。';
      } else {
        reply = '我理解你的意思。这是一个自动回复示例。';
      }

      // 添加回复消息
      chatController.addMessage(
        ChatMessage(
          id: DateTime.now().toString(),
          text: reply,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatController = ref.read(chatControllerProvider.notifier);
    final messages = ref.watch(chatControllerProvider);

    // 监听新消息并滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });

    return Scaffold(
      appBar: _buildAppBar(chatController),
      body: Column(
        children: [
          // 消息列表
          Expanded(child: _buildMessageList(messages)),

          // 消息输入框
          _buildMessageInput(chatController),

          // 状态提示
          _buildStatusIndicator(),
        ],
      ),
    );
  }

  // Build App Bar
  AppBar _buildAppBar(dynamic chatController) {
    return AppBar(
      title: const Text('实时聊天'),
      backgroundColor: Colors.blue,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: chatController.clearMessages,
          icon: const Icon(Icons.clear_all),
          tooltip: '清空消息',
        ),
      ],
    );
  }

  // Build Message List
  Widget _buildMessageList(List<ChatMessage> messages) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade50, Colors.white],
        ),
      ),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return _buildMessageItem(message);
        },
      ),
    );
  }

  // Build Message Input
  Widget _buildMessageInput(dynamic chatController) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: '输入消息...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _handleSendMessage(value.trim());
                  _textController.clear();
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: IconButton(
              onPressed: () {
                final value = _textController.text.trim();
                if (value.isNotEmpty) {
                  _handleSendMessage(value);
                  _textController.clear();
                }
              },
              icon: const Icon(Icons.send, color: Colors.white),
              tooltip: '发送',
            ),
          ),
        ],
      ),
    );
  }

  // Build Status Indicator
  Widget _buildStatusIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.blue.shade50,
      child: const Text(
        '聊天已连接',
        style: TextStyle(fontSize: 12, color: Colors.blue),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Build Message Item
  Widget _buildMessageItem(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue.shade600 : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: message.isUser
                ? const Radius.circular(16)
                : const Radius.circular(0),
            bottomRight: message.isUser
                ? const Radius.circular(0)
                : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: message.isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: message.isUser
                    ? Colors.white.withAlpha(204)
                    : Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
