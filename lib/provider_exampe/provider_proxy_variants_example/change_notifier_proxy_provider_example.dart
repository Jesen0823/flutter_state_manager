import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ChangeNotifierProxyProvider 示例
/// 用于依赖其他 ChangeNotifier 的状态管理

// 用户模型
class UserModel {
  final String name;
  final int age;
  final String email;

  UserModel({required this.name, required this.age, required this.email});
}

// 认证状态模型
class AuthModel extends ChangeNotifier {
  UserModel? _user;
  bool _isAuthenticated = false;

  UserModel? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  // 登录
  void login() {
    _user = UserModel(name: 'John Doe', age: 30, email: 'john.doe@example.com');
    _isAuthenticated = true;
    notifyListeners();
  }

  // 登出
  void logout() {
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}

// 用户配置模型（依赖于 AuthModel）
class UserConfigModel extends ChangeNotifier {
  final AuthModel authModel;
  String _theme = 'light';
  bool _notificationsEnabled = true;

  UserConfigModel(this.authModel) {
    // 监听 AuthModel 的变化
    authModel.addListener(notifyListeners);
  }

  @override
  void dispose() {
    authModel.removeListener(notifyListeners);
    super.dispose();
  }

  String get theme => _theme;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get isAuthenticated => authModel.isAuthenticated;
  UserModel? get user => authModel.user;

  // 切换主题
  void toggleTheme() {
    _theme = _theme == 'light' ? 'dark' : 'light';
    notifyListeners();
  }

  // 切换通知
  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }
}

// 主应用组件
class ChangeNotifierProxyProviderExample extends StatelessWidget {
  const ChangeNotifierProxyProviderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthModel>(create: (_) => AuthModel()),
        ChangeNotifierProxyProvider<AuthModel, UserConfigModel>(
          create: (context) =>
              UserConfigModel(Provider.of<AuthModel>(context, listen: false)),
          update: (context, authModel, previous) {
            if (previous == null) return UserConfigModel(authModel);
            return previous;
          },
        ),
      ],
      child: const MaterialApp(
        title: 'ChangeNotifierProxyProvider Example',
        home: HomePage(),
      ),
    );
  }
}

// 主页面
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<AuthModel>(context);
    final userConfigModel = Provider.of<UserConfigModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ChangeNotifierProxyProvider Example'),
        actions: [
          if (authModel.isAuthenticated) ...[
            IconButton(
              icon: Icon(
                userConfigModel.theme == 'light'
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              onPressed: userConfigModel.toggleTheme,
              tooltip: 'Toggle Theme',
            ),
            IconButton(
              icon: Icon(
                userConfigModel.notificationsEnabled
                    ? Icons.notifications
                    : Icons.notifications_off,
              ),
              onPressed: userConfigModel.toggleNotifications,
              tooltip: 'Toggle Notifications',
            ),
          ],
        ],
      ),
      body: Center(
        child: authModel.isAuthenticated
            ? UserProfile(configModel: userConfigModel)
            : const LoginPrompt(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (authModel.isAuthenticated) {
            authModel.logout();
          } else {
            authModel.login();
          }
        },
        tooltip: authModel.isAuthenticated ? 'Logout' : 'Login',
        child: Icon(authModel.isAuthenticated ? Icons.logout : Icons.login),
      ),
    );
  }
}

// 登录提示组件
class LoginPrompt extends StatelessWidget {
  const LoginPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
        const SizedBox(height: 20),
        const Text(
          'Not Authenticated',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'Tap the login button to authenticate',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

// 用户信息组件
class UserProfile extends StatelessWidget {
  final UserConfigModel configModel;

  const UserProfile({super.key, required this.configModel});

  @override
  Widget build(BuildContext context) {
    final user = configModel.user!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 用户头像
          CircleAvatar(
            radius: 64,
            backgroundColor: Colors.blue,
            child: Text(
              user.name[0].toUpperCase(),
              style: const TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),

          // 用户信息
          Text(
            user.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${user.age} years old',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(user.email, style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 30),

          // 用户配置
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'User Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Theme:'),
                    Text(
                      configModel.theme == 'light' ? 'Light' : 'Dark',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Notifications:'),
                    Text(
                      configModel.notificationsEnabled ? 'Enabled' : 'Disabled',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // 配置说明
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: const Text(
              'This example demonstrates ChangeNotifierProxyProvider, which allows UserConfigModel to depend on AuthModel. When AuthModel changes (login/logout), UserConfigModel automatically updates.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
