
/// 应用状态管理 - 模块化状态结构
/// 
/// 此文件定义了应用的整体状态结构，包含三个独立的状态模块：
/// 1. AuthState - 认证状态
/// 2. CounterState - 计数器状态
/// 3. UserState - 用户信息状态
/// 
/// 核心概念：
/// - State: 应用状态的不可变数据结构
/// - 模块化: 将复杂状态拆分为多个独立模块
/// - 初始状态: 通过 factory 构造函数提供默认初始值
/// 
/// 使用场景：
/// - 当应用状态较为复杂，需要按功能模块划分时
/// - 适合中大型应用的状态管理
/// - 便于团队协作和代码维护

/// 应用状态
class AppState {
  final AuthState auth;
  final CounterState counter;
  final UserState user;

  AppState({
    required this.auth,
    required this.counter,
    required this.user,
  });

  factory AppState.initial() {
    return AppState(
      auth: AuthState.initial(),
      counter: CounterState.initial(),
      user: UserState.initial(),
    );
  }

  @override
  String toString() {
    return 'AppState(auth: $auth, counter: $counter, user: $user)';
  }
}

/// 认证状态
class AuthState {
  final bool loggedIn;

  AuthState(this.loggedIn);

  factory AuthState.initial() {
    return AuthState(false);
  }

  @override
  String toString() {
    return 'AuthState(loggedIn: $loggedIn)';
  }
}

/// 计数器状态
class CounterState {
  final int count;

  CounterState(this.count);

  factory CounterState.initial() {
    return CounterState(0);
  }

  @override
  String toString() {
    return 'CounterState(count: $count)';
  }
}

/// 用户状态
class UserState {
  final String name;

  UserState(this.name);

  factory UserState.initial() {
    return UserState('');
  }

  @override
  String toString() {
    return 'UserState(name: $name)';
  }
}
