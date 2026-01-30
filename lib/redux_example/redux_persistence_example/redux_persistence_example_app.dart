/// 状态持久化示例 - Store 创建与持久化配置
///
/// 此文件负责创建 Redux Store 并配置状态持久化：
/// 1. createStore - 创建并初始化 Redux Store
/// 2. _loadState - 从持久化存储加载状态
/// 3. _saveState - 保存状态到持久化存储
/// 4. _createPersistenceMiddleware - 创建持久化中间件
///
/// 核心概念：
/// - Store: Redux 的核心，存储应用状态
/// - 状态持久化: 将状态保存到本地存储
/// - 中间件: 拦截动作，执行副作用操作
/// - 初始化流程: 应用启动时加载持久化状态
///
/// 持久化实现：
/// - 使用 shared_preferences 作为存储介质
/// - 将状态序列化为 JSON 字符串存储
/// - 应用启动时从存储中加载状态
/// - 状态变更时自动保存到存储
///
/// 使用场景：
/// - 需要保存用户登录状态
/// - 需要保存应用设置
/// - 需要保存用户操作历史
/// - 任何需要持久化的状态数据

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'redux/app_state.dart';
import 'redux/reducers.dart';
import 'pages/redux_persistence_page.dart';

/// 创建 Redux Store
///
/// 功能：创建并初始化 Redux Store，加载持久化状态
/// 流程：1. 加载持久化状态 2. 创建 Store 3. 配置持久化中间件
Future<Store<AppState>> createStore() async {
  // 加载持久化状态
  final initialState = await _loadState();

  // 创建 Store
  final store = Store<AppState>(
    appReducer,
    initialState: initialState ?? AppState.initial(),
    middleware: [_createPersistenceMiddleware()],
  );

  return store;
}

/// 加载持久化状态
///
/// 功能：从 shared_preferences 加载持久化的状态
/// 流程：1. 获取 SharedPreferences 实例 2. 读取状态 JSON 3. 反序列化为 AppState
/// 错误处理：如果加载失败，返回 null，使用初始状态
Future<AppState?> _loadState() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final stateJson = prefs.getString('redux_state');
    if (stateJson != null) {
      return AppState.fromJson(stateJson);
    }
  } catch (e) {
    print('Error loading state: $e');
  }
  return null;
}

/// 保存状态到持久化存储
///
/// 功能：将当前状态保存到 shared_preferences
/// 流程：1. 获取 SharedPreferences 实例 2. 序列化为 JSON 3. 保存为字符串
/// 错误处理：如果保存失败，打印错误信息但不影响应用运行
Future<void> _saveState(AppState state) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final stateJson = state.toJson();
    await prefs.setString('redux_state', stateJson);
  } catch (e) {
    print('Error saving state: $e');
  }
}

/// 创建持久化中间件
///
/// 功能：拦截动作，在状态变更后自动保存
/// 流程：1. 传递动作到下一个中间件或 reducer 2. 保存新状态到持久化存储
/// 说明：此中间件确保每次状态变更都会被持久化
Middleware<AppState> _createPersistenceMiddleware() {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action); // 先传递动作，更新状态
    _saveState(store.state); // 保存新状态
  };
}

/// 主应用
class ReduxPersistenceExampleApp extends StatelessWidget {
  final Store<AppState> store;

  const ReduxPersistenceExampleApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Redux Persistence Example',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const ReduxPersistencePage(),
      ),
    );
  }
}
