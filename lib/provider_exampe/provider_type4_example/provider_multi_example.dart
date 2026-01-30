import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// MultiProvider：合并多个 Provider，结构更清晰 适用于需要管理多个状态模型的项目。

class CounterModel extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

class ThemeModel extends ChangeNotifier {
  bool _dark = false;

  bool get isDark => _dark;

  void toggleTheme() {
    _dark = !_dark;
    notifyListeners();
  }
}

class ProviderType4App extends StatelessWidget {
  const ProviderType4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CounterModel>(create: (_) => CounterModel()),
        ChangeNotifierProvider<ThemeModel>(create: (_) => ThemeModel()),
      ],
      child: Builder(
        builder: (context) {
          final isDark = context.watch<ThemeModel>().isDark;
          return MaterialApp(
            theme: isDark ? ThemeData.dark() : ThemeData.light(),
            home: ProviderMultiExample(),
          );
        },
      ),
    );
  }
}

class ProviderMultiExample extends StatelessWidget {
  const ProviderMultiExample({super.key});

  @override
  Widget build(BuildContext context) {
    final counterModel = context.watch<CounterModel>();
    final themeModel = context.watch<ThemeModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('MultiProvider 案例'),
        actions: [
          IconButton(
            onPressed: () => themeModel.toggleTheme(),
            icon: Icon(themeModel.isDark ? Icons.dark_mode : Icons.light_mode),
          ),
        ],
      ),
      body: Center(
        child: Text(
          '计数器：${counterModel.count}',
          style: TextStyle(fontSize: 30),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => counterModel.increment(),
      ),
    );
  }
}
