import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// FutureProvider<T>：处理异步操作（Future），如初始化数据、请求接口
/// 适用于首次进入页面时加载远程数据

// 用户数据模型
class User {
  final int id;
  final String name;
  final String email;
  final String avatar;
  final String bio;
  final int followers;
  final int following;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.bio,
    required this.followers,
    required this.following,
  });
}

// 模拟API服务
class UserService {
  // 模拟获取用户数据
  static Future<User> fetchUserProfile({bool throwError = false}) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(seconds: 2));

    // 模拟错误情况
    if (throwError) {
      throw Exception('Failed to fetch user profile');
    }

    // 返回模拟用户数据
    return const User(
      id: 1,
      name: 'John Doe',
      email: 'john.doe@example.com',
      avatar: 'https://randomuser.me/api/portraits/men/32.jpg',
      bio: 'Software developer passionate about Flutter and Dart',
      followers: 120,
      following: 85,
    );
  }
}

// 用户信息卡片组件
class UserProfileCard extends StatelessWidget {
  const UserProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final error = Provider.of<Object?>(context);

    // 加载状态
    if (user == null && error == null) {
      return const _LoadingState();
    }

    // 错误状态
    if (error != null) {
      return _ErrorState(error: error);
    }

    // 成功状态
    return _UserProfileContent(user!);
  }
}

// 加载状态组件
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Loading user profile...'),
        ],
      ),
    );
  }
}

// 错误状态组件
class _ErrorState extends StatelessWidget {
  final Object error;

  const _ErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 20),
          Text(
            'Error: ${error.toString()}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // 重新构建FutureProvider以触发重新加载
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const ProviderFeatureExample()),
              );
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

// 用户信息内容组件
class _UserProfileContent extends StatelessWidget {
  final User user;

  const _UserProfileContent(this.user);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 用户头像
          CircleAvatar(radius: 64, backgroundImage: NetworkImage(user.avatar)),
          const SizedBox(height: 20),

          // 用户名和邮箱
          Text(
            user.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            user.email,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),

          // 个人简介
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              user.bio,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),

          // 关注信息
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatItem('Followers', user.followers),
              const SizedBox(width: 40),
              _buildStatItem('Following', user.following),
            ],
          ),
          const SizedBox(height: 30),

          // 操作按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Followed user')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: const Text('Follow'),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Message sent')));
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: const Text('Message'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

// 主应用组件
class ProviderFeatureExample extends StatelessWidget {
  const ProviderFeatureExample({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureProvider<User?>(
      create: (_) => UserService.fetchUserProfile(),
      initialData: null,
      catchError: (context, error) {
        print('Error: $error');
        return null;
      },
      child: MaterialApp(
        title: 'FutureProvider Example',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('User Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // 重新加载用户数据
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const ProviderFeatureExample(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: UserProfileCard(),
        ),
      ),
    );
  }
}

// 带错误测试的示例
class ProviderType2ErrorExample extends StatelessWidget {
  const ProviderType2ErrorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureProvider<User?>(
      create: (_) => UserService.fetchUserProfile(throwError: true),
      initialData: null,
      catchError: (context, error) {
        print('Error: $error');
        return null;
      },
      child: MaterialApp(
        title: 'FutureProvider Error Example',
        home: Scaffold(
          appBar: AppBar(title: const Text('User Profile (Error Test)')),
          body: UserProfileCard(),
        ),
      ),
    );
  }
}
