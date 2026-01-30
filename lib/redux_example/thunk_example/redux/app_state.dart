/// 应用状态管理 - 异步操作支持
///
/// 此文件定义了应用的整体状态结构，包含四个独立的状态模块：
/// 1. UserState - 用户信息状态（支持加载状态、错误处理）
/// 2. PostsState - 帖子列表状态（支持加载状态、错误处理）
/// 3. CounterState - 计数器状态（支持加载状态）
/// 4. AuthState - 认证状态（支持加载状态、错误处理）
///
/// 核心概念：
/// - State: 应用状态的不可变数据结构
/// - 异步状态管理: 每个状态模块都包含 isLoading 和 error 字段
/// - 初始状态: 通过 factory 构造函数提供默认初始值
/// - 不可变性: 状态变更时必须返回新的状态实例
///
/// 异步状态结构：
/// - isLoading: 标记是否正在加载
/// - error: 存储错误信息
/// - 数据字段: 存储实际数据
///
/// 使用场景：
/// - 当应用需要处理异步操作时，如网络请求
/// - 适合需要展示加载状态和错误信息的场景
/// - 便于统一管理异步操作的状态

/// 应用状态
class AppState {
  final UserState user;
  final PostsState posts;
  final CounterState counter;
  final AuthState auth;

  AppState({
    required this.user,
    required this.posts,
    required this.counter,
    required this.auth,
  });

  factory AppState.initial() {
    return AppState(
      user: UserState.initial(),
      posts: PostsState.initial(),
      counter: CounterState.initial(),
      auth: AuthState.initial(),
    );
  }

  @override
  String toString() {
    return 'AppState(user: $user, posts: $posts, counter: $counter, auth: $auth)';
  }
}

/// 用户状态
class UserState {
  final String name;
  final String email;
  final bool isLoading;
  final String? error;

  UserState({
    required this.name,
    required this.email,
    required this.isLoading,
    this.error,
  });

  factory UserState.initial() {
    return UserState(name: '', email: '', isLoading: false, error: null);
  }

  @override
  String toString() {
    return 'UserState(name: $name, isLoading: $isLoading, error: $error)';
  }
}

/// 帖子状态
class PostsState {
  final List<Post> posts;
  final bool isLoading;
  final String? error;

  PostsState({required this.posts, required this.isLoading, this.error});

  factory PostsState.initial() {
    return PostsState(posts: [], isLoading: false, error: null);
  }

  @override
  String toString() {
    return 'PostsState(posts: ${posts.length}, isLoading: $isLoading, error: $error)';
  }
}

/// 帖子模型
class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});

  @override
  String toString() {
    return 'Post(id: $id, title: $title)';
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

/// 认证状态
class AuthState {
  final bool isLoggedIn;
  final String token;
  final bool isLoading;
  final String? error;

  AuthState({
    required this.isLoggedIn,
    required this.token,
    required this.isLoading,
    this.error,
  });

  factory AuthState.initial() {
    return AuthState(
      isLoggedIn: false,
      token: '',
      isLoading: false,
      error: null,
    );
  }

  @override
  String toString() {
    return 'AuthState(isLoggedIn: $isLoggedIn, isLoading: $isLoading, error: $error)';
  }
}
