import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Provider<T>：提供只读、不可变对象（不监听变化）
/// 适用于传递全局配置等静态数据

// 应用配置类，包含各种静态配置
class AppConfig {
  final String appName;
  final String appVersion;
  final String apiBaseUrl;
  final bool isProduction;
  final List<String> supportedLanguages;

  const AppConfig({
    required this.appName,
    required this.appVersion,
    required this.apiBaseUrl,
    required this.isProduction,
    required this.supportedLanguages,
  });

  // 开发环境配置
  static const AppConfig development = AppConfig(
    appName: 'Flutter Provider Demo',
    appVersion: '1.0.0-dev',
    apiBaseUrl: 'https://api.dev.example.com',
    isProduction: false,
    supportedLanguages: ['English', '中文'],
  );

  // 生产环境配置
  static const AppConfig production = AppConfig(
    appName: 'Flutter Provider Demo',
    appVersion: '1.0.0',
    apiBaseUrl: 'https://api.example.com',
    isProduction: true,
    supportedLanguages: ['English', '中文'],
  );
}

// 配置展示组件
class ConfigDisplayWidget extends StatelessWidget {
  const ConfigDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 从Provider中获取配置
    final config = Provider.of<AppConfig>(context);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'App Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildConfigRow('App Name', config.appName),
            _buildConfigRow('Version', config.appVersion),
            _buildConfigRow('API Base URL', config.apiBaseUrl),
            _buildConfigRow(
              'Environment',
              config.isProduction ? 'Production' : 'Development',
            ),
            _buildConfigRow('Languages', config.supportedLanguages.join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

// 环境信息组件
class EnvironmentInfoWidget extends StatelessWidget {
  const EnvironmentInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 从Provider中获取配置
    final config = Provider.of<AppConfig>(context);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      color: config.isProduction ? Colors.green[50] : Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              config.isProduction ? Icons.check_circle : Icons.developer_mode,
              size: 48,
              color: config.isProduction ? Colors.green : Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              config.isProduction
                  ? 'Production Environment'
                  : 'Development Environment',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              config.isProduction
                  ? 'Connected to production API'
                  : 'Connected to development API',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: config.isProduction ? Colors.green : Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 配置管理屏幕
class ConfigManagementScreen extends StatelessWidget {
  const ConfigManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<AppConfig>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(config.appName),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(config.appVersion),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 配置说明
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Provider<T> provides read-only, immutable objects.\n '
                'It is suitable for static data like configuration items, constants, etc.\n'
                'The data provided by Provider<T> cannot be changed after creation.',
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),
            // 环境信息
            EnvironmentInfoWidget(),
            // 配置详情
            ConfigDisplayWidget(),
          ],
        ),
      ),
    );
  }
}

// 主应用组件
class ProviderReadOnlyExample extends StatelessWidget {
  const ProviderReadOnlyExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<AppConfig>(
      create: (_) => AppConfig.development, // 可以切换为AppConfig.production查看不同效果
      child: MaterialApp(
        title: 'Provider<T> Example',
        home: ConfigManagementScreen(),
      ),
    );
  }
}
