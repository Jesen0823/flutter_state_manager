
import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  final String id;
  final String name;
  final String email;
  
  User({
    required this.id,
    required this.name,
    required this.email,
  });
}

class UserService {
  static Future<User> fetchUser(String userId) async {
    // 模拟网络请求延迟
    await Future.delayed(Duration(seconds: 3));
    
    // 模拟根据ID返回不同用户
    switch (userId) {
      case '1':
        return User(
          id: '1',
          name: 'John Doe',
          email: 'john@example.com',
        );
      case '-1':
        throw UnsupportedError("userID $userId is not support.");
      case '2':
        return User(
          id: '2',
          name: 'Jane Smith',
          email: 'jane@example.com',
        );
      case '3':
        return User(
          id: '3',
          name: 'Bob Johnson',
          email: 'bob@example.com',
        );
      default:
        return User(
          id: userId,
          name: 'Unknown User',
          email: 'unknown@example.com',
        );
    }
  }
}

// 使用Family定义参数化的FutureProvider
final userProvider = FutureProvider.family<User, String>((ref, userId) async {
  return UserService.fetchUser(userId);
});
