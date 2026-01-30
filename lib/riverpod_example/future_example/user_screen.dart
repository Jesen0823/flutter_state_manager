
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_provider.dart';

class UserScreen extends ConsumerWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('用户信息'),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(userProvider),
            icon: const Icon(Icons.refresh),
            tooltip: '刷新',
          ),
        ],
      ),
      body: userAsyncValue.when(
        loading: () => _buildLoadingState(),
        error: (error, stackTrace) => _buildErrorState(context, ref, error),
        data: (user) => _buildUserData(user),
      ),
    );
  }

  // 加载状态
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.blue.shade600,
          ),
          const SizedBox(height: 20),
          const Text(
            '加载用户信息...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // 错误状态
  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.shade50,
            ),
            child: Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '加载失败',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => ref.invalidate(userProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  // 成功状态 - 用户数据
  Widget _buildUserData(User user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 用户头像
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue.shade200,
                width: 3,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                user.avatar,
                fit: BoxFit.cover,
                width: 120,
                height: 120,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 用户信息
          _buildInfoRow('ID', user.id.toString()),
          const SizedBox(height: 16),
          _buildInfoRow('姓名', user.name),
          const SizedBox(height: 16),
          _buildInfoRow('邮箱', user.email),
          const SizedBox(height: 48),

          // 说明信息
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blue.shade100,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FutureProvider 说明',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '1. 用于处理异步操作，如网络请求',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '2. 自动处理加载、错误和成功状态',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '3. 使用 ref.invalidate() 可以刷新数据',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 信息行
  Widget _buildInfoRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 错误示例屏幕
class ErrorUserScreen extends ConsumerWidget {
  const ErrorUserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(errorUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('错误示例'),
        backgroundColor: Colors.red.shade600,
        elevation: 0,
      ),
      body: userAsyncValue.when(
        loading: () => _buildLoadingState(),
        error: (error, stackTrace) => _buildErrorState(context, ref, error),
        data: (user) => _buildUserData(user),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            '加载失败: $error',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => ref.invalidate(errorUserProvider),
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserData(User user) {
    return Center(
      child: Text('用户: ${user.name}'),
    );
  }
}
