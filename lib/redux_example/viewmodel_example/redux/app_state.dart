/// 应用状态管理 - ViewModel 模式支持
///
/// 此文件定义了应用的整体状态结构，包含四个独立的状态模块：
/// 1. AuthState - 认证状态（支持登录状态、令牌）
/// 2. CounterState - 计数器状态（支持计数、加载状态）
/// 3. UserState - 用户信息状态（支持名称、邮箱、资料完成状态）
/// 4. ThemeState - 主题状态（支持暗黑模式、主题名称）
///
/// 核心概念：
/// - State: 应用状态的不可变数据结构
/// - 模块化: 将复杂状态拆分为多个独立模块
/// - 初始状态: 通过 factory 构造函数提供默认初始值
/// - 不可变性: 状态变更时必须返回新的状态实例
///
/// ViewModel 模式说明：
/// - 状态结构设计考虑了 ViewModel 的映射需求
/// - 每个状态模块都包含 UI 所需的所有数据
/// - 支持加载状态、错误处理等 UI 相关的状态
/// - 便于在 StoreConnector 中映射为 ViewModel
///
/// 使用场景：
/// - 当应用需要使用 ViewModel 模式时
/// - 适合需要清晰的 UI 与状态逻辑分离的场景
/// - 便于测试和维护

/// 应用状态
class AppState {
  final AuthState auth;
  final CounterState counter;
  final UserState user;
  final ThemeState theme;

  AppState({
    required this.auth,
    required this.counter,
    required this.user,
    required this.theme,
  });

  factory AppState.initial() {
    return AppState(
      auth: AuthState.initial(),
      counter: CounterState.initial(),
      user: UserState.initial(),
      theme: ThemeState.initial(),
    );
  }

  @override
  String toString() {
    return 'AppState(auth: $auth, counter: $counter, user: $user, theme: $theme)';
  }
}

/// 认证状态
class AuthState {
  final bool loggedIn;
  final String token;

  AuthState({required this.loggedIn, required this.token});

  factory AuthState.initial() {
    return AuthState(loggedIn: false, token: '');
  }

  @override
  String toString() {
    return 'AuthState(loggedIn: $loggedIn, token: $token)';
  }
}

/// 计数器状态
class CounterState {
  final int count;
  final bool isLoading;

  CounterState({required this.count, required this.isLoading});

  factory CounterState.initial() {
    return CounterState(count: 0, isLoading: false);
  }

  @override
  String toString() {
    return 'CounterState(count: $count, isLoading: $isLoading)';
  }
}

/// 用户状态
class UserState {
  final String name;
  final String email;
  final bool isProfileComplete;

  UserState({
    required this.name,
    required this.email,
    required this.isProfileComplete,
  });

  factory UserState.initial() {
    return UserState(name: '', email: '', isProfileComplete: false);
  }

  @override
  String toString() {
    return 'UserState(name: $name, email: $email, isProfileComplete: $isProfileComplete)';
  }
}

/// 主题状态
class ThemeState {
  final bool isDarkMode;
  final String themeName;

  ThemeState({required this.isDarkMode, required this.themeName});

  factory ThemeState.initial() {
    return ThemeState(isDarkMode: false, themeName: 'Light');
  }

  @override
  String toString() {
    return 'ThemeState(isDarkMode: $isDarkMode, themeName: $themeName)';
  }
}
