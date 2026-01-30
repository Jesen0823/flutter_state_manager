
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// 用户模型
class User {
  final int id;
  final String name;
  final String email;
  final String avatar;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });
}

// 模拟 API 服务
class UserService {
  // 模拟获取用户信息
  static Future<User> fetchUser({bool throwError = false}) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(seconds: 3));

    // 模拟错误情况
    if (throwError) {
      throw Exception('Failed to fetch user data');
    }

    // 返回模拟用户数据
    return User(
      id: 1,
      name: 'John Doe',
      email: 'john.doe@example.com',
      avatar: 'https://randomuser.me/api/portraits/men/32.jpg',
    );
  }
}

// 用户 Provider
final userProvider = FutureProvider<User>((ref) async {
  return UserService.fetchUser();
});

// 带错误的用户 Provider
final errorUserProvider = FutureProvider<User>((ref) async {
  return UserService.fetchUser(throwError: true);
});
