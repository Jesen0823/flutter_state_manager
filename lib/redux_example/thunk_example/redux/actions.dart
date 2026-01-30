/// Action 定义 - 异步操作支持
///
/// 此文件定义了应用中所有的动作类型，包括：
/// 1. 同步 Actions - 直接触发状态变更
/// 2. 异步 Actions (Thunk) - 处理异步操作，如网络请求
///
/// 核心概念：
/// - Action: 描述状态变更的事件对象
/// - Thunk Action: 返回函数的动作，用于处理异步操作
/// - 载荷 (Payload): 动作可以携带数据
/// - 状态管理: 通过不同的动作类型管理加载状态、成功状态、失败状态
///
/// Thunk 模式说明：
/// - Thunk Action 是一个函数，接收 store 作为参数
/// - 可以在函数内部执行异步操作
/// - 异步操作完成后，dispatch 对应的同步动作
/// - 支持加载状态管理和错误处理
///
/// 使用场景：
/// - 网络请求
/// - 本地存储操作
/// - 任何需要异步处理的场景
/// - 需要复杂逻辑判断的状态变更

import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'app_state.dart';

/// 认证相关 Actions
class LoginAction {
  final String email;
  final String password;

  LoginAction(this.email, this.password);
}

class LoginSuccessAction {
  final String token;

  LoginSuccessAction(this.token);
}

class LoginFailureAction {
  final String error;

  LoginFailureAction(this.error);
}

class LogoutAction {}

class SetAuthLoadingAction {
  final bool isLoading;

  SetAuthLoadingAction(this.isLoading);
}

/// 用户相关 Actions
class FetchUserAction {}

class FetchUserSuccessAction {
  final String name;
  final String email;

  FetchUserSuccessAction(this.name, this.email);
}

class FetchUserFailureAction {
  final String error;

  FetchUserFailureAction(this.error);
}

class SetUserLoadingAction {
  final bool isLoading;

  SetUserLoadingAction(this.isLoading);
}

/// 帖子相关 Actions
class FetchPostsAction {}

class FetchPostsSuccessAction {
  final List<Post> posts;

  FetchPostsSuccessAction(this.posts);
}

class FetchPostsFailureAction {
  final String error;

  FetchPostsFailureAction(this.error);
}

class SetPostsLoadingAction {
  final bool isLoading;

  SetPostsLoadingAction(this.isLoading);
}

/// 计数器相关 Actions
class IncrementAction {}

class DecrementAction {}

class ResetAction {}

class IncrementAsyncAction {}

class SetCounterLoadingAction {
  final bool isLoading;

  SetCounterLoadingAction(this.isLoading);
}

/// Thunk Actions

// 登录 Thunk
ThunkAction<AppState> loginThunk(String email, String password) {
  return (Store<AppState> store) async {
    store.dispatch(SetAuthLoadingAction(true));

    try {
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 2));

      // 模拟登录成功
      final token = 'demo-token-${DateTime.now().millisecondsSinceEpoch}';
      store.dispatch(LoginSuccessAction(token));
    } catch (error) {
      store.dispatch(LoginFailureAction('Login failed: $error'));
    } finally {
      store.dispatch(SetAuthLoadingAction(false));
    }
  };
}

// 获取用户信息 Thunk
ThunkAction<AppState> fetchUserThunk() {
  return (Store<AppState> store) async {
    store.dispatch(SetUserLoadingAction(true));

    try {
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 1));

      // 模拟用户数据
      store.dispatch(FetchUserSuccessAction('John Doe', 'john@example.com'));
    } catch (error) {
      store.dispatch(FetchUserFailureAction('Failed to fetch user: $error'));
    } finally {
      store.dispatch(SetUserLoadingAction(false));
    }
  };
}

// 获取帖子列表 Thunk
ThunkAction<AppState> fetchPostsThunk() {
  return (Store<AppState> store) async {
    store.dispatch(SetPostsLoadingAction(true));

    try {
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 2));

      // 模拟帖子数据
      final posts = [
        Post(id: 1, title: 'First Post', body: 'This is the first post'),
        Post(id: 2, title: 'Second Post', body: 'This is the second post'),
        Post(id: 3, title: 'Third Post', body: 'This is the third post'),
        Post(id: 4, title: 'Fourth Post', body: 'This is the fourth post'),
        Post(id: 5, title: 'Fifth Post', body: 'This is the fifth post'),
      ];
      store.dispatch(FetchPostsSuccessAction(posts));
    } catch (error) {
      store.dispatch(FetchPostsFailureAction('Failed to fetch posts: $error'));
    } finally {
      store.dispatch(SetPostsLoadingAction(false));
    }
  };
}

// 异步递增 Thunk
ThunkAction<AppState> incrementAsyncThunk() {
  return (Store<AppState> store) async {
    store.dispatch(SetCounterLoadingAction(true));

    try {
      // 模拟延迟
      await Future.delayed(const Duration(seconds: 1));
      store.dispatch(IncrementAction());
    } finally {
      store.dispatch(SetCounterLoadingAction(false));
    }
  };
}
