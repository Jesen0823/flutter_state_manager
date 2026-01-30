
import 'dart:convert';

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

  AppState copyWith({
    AuthState? auth,
    CounterState? counter,
    UserState? user,
  }) {
    return AppState(
      auth: auth ?? this.auth,
      counter: counter ?? this.counter,
      user: user ?? this.user,
    );
  }

  // 序列化
  String toJson() {
    final map = {
      'auth': auth.toJson(),
      'counter': counter.toJson(),
      'user': user.toJson(),
    };
    return jsonEncode(map);
  }

  // 反序列化
  factory AppState.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    return AppState(
      auth: AuthState.fromJson(json['auth']),
      counter: CounterState.fromJson(json['counter']),
      user: UserState.fromJson(json['user']),
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

  // 序列化
  Map<String, dynamic> toJson() {
    return {'loggedIn': loggedIn};
  }

  // 反序列化
  factory AuthState.fromJson(dynamic json) {
    return AuthState(json['loggedIn'] ?? false);
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

  // 序列化
  Map<String, dynamic> toJson() {
    return {'count': count};
  }

  // 反序列化
  factory CounterState.fromJson(dynamic json) {
    return CounterState(json['count'] ?? 0);
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

  // 序列化
  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  // 反序列化
  factory UserState.fromJson(dynamic json) {
    return UserState(json['name'] ?? '');
  }

  @override
  String toString() {
    return 'UserState(name: $name)';
  }
}
