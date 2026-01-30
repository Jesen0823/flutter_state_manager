/// 中间件定义 - 动作拦截与副作用处理
///
/// 此文件定义了应用中所有的中间件函数：
/// 1. createLogger - 通用日志中间件
/// 2. authMiddleware - 认证中间件（未登录不能点赞）
/// 3. likeAsyncMiddleware - 异步处理中间件（处理点赞操作）
/// 4. snackMiddlleware - 通知中间件（展示 SnackBar）
///
/// 核心概念：
/// - Middleware: 连接 dispatch 和 reducer 的中间层
/// - 拦截动作: 可以在动作到达 reducer 之前进行拦截
/// - 副作用处理: 可以执行副作用操作，如网络请求、日志记录
/// - 动作修改: 可以修改动作或阻止动作传递
/// - 链式调用: 多个中间件按顺序执行
///
/// 中间件函数签名：
/// ```dart
/// Middleware<State> = dynamic Function(
///   Store<State> store,      // Redux Store 实例
///   dynamic action,          // 被 dispatch 的动作
///   NextDispatcher next,     // 下一个中间件或 reducer
/// );
/// ```
///
/// 使用场景：
/// - 日志记录
/// - 权限校验
/// - 异步操作处理
/// - 通知和副作用处理
/// - 动作拦截和修改

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:state_manager/redux_example/midware_redux_example/midware_example_app.dart';
import 'package:state_manager/redux_example/midware_redux_example/redux/mw_actions.dart';
import 'package:state_manager/redux_example/midware_redux_example/redux/mw_app_state.dart';

/// 通用日志中间件
///
/// 功能：记录所有动作的分发和状态变更
/// 使用场景：调试和开发过程中跟踪状态变更
/// 参数：tag - 日志标签，用于区分不同模块的日志
Middleware<MWAppState> createLogger(String tag) {
  return (store, action, next) {
    print('[$tag], Dispatch: $action');
    next(action);
    print('[$tag], New state: ${store.state}');
  };
}

/// 认证中间件
///
/// 功能：未登录用户不能执行点赞操作
/// 使用场景：需要权限校验的操作
/// 逻辑：拦截未登录用户的点赞请求，展示提示信息
void authMiddleware(
  Store<MWAppState> store,
  dynamic action,
  NextDispatcher next,
) {
  if (action is ActionLikeRequest && !store.state.loggedIn) {
    // 拦截未登录用户的点赞请求
    store.dispatch(ActionShowToast('请先登录'));
    return; // 阻止动作传递到 reducer
  }
  next(action); // 允许动作继续传递
}

/// 异步处理中间件
///
/// 功能：处理异步的点赞操作
/// 使用场景：需要异步处理的操作，如网络请求
/// 逻辑：先传递动作，然后执行异步操作，最后分发成功动作
Future<void> likeAsyncMiddleware(
  Store<MWAppState> store,
  dynamic action,
  NextDispatcher next,
) async {
  if (action is ActionLikeRequest) {
    next(action); // 先传递动作，更新加载状态
    await Future.delayed(Duration(seconds: 2)); // 模拟网络请求
    store.dispatch(ActionLikeSuccess()); // 分发成功动作
    store.dispatch(ActionShowToast('点赞成功')); // 展示成功提示
  } else {
    next(action); // 其他动作直接传递
  }
}

/// 通知中间件
///
/// 功能：展示 SnackBar 通知
/// 使用场景：需要用户通知的操作
/// 逻辑：动作处理完成后，展示对应的通知
void snackMiddlleware(
  Store<MWAppState> store,
  dynamic action,
  NextDispatcher next,
) {
  next(action); // 先让动作执行完成
  if (action is ActionShowToast) {
    // 拿到 context 展示 SnackBar
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(action.message)));
    }
  }
}
