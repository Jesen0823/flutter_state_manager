
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormData {
  final String name;
  final String email;
  final String message;
  
  FormData({
    this.name = '',
    this.email = '',
    this.message = '',
  });
  
  FormData copyWith({
    String? name,
    String? email,
    String? message,
  }) {
    return FormData(
      name: name ?? this.name,
      email: email ?? this.email,
      message: message ?? this.message,
    );
  }
}

class FormNotifier extends AutoDisposeNotifier<FormData> {
  @override
  FormData build() {
    print('FormNotifier initialized');
    
    // 注册销毁回调
    ref.onDispose(() {
      print('FormNotifier disposed - resources cleaned up');
    });
    
    return FormData();
  }
  
  void updateName(String name) {
    state = state.copyWith(name: name);
  }
  
  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }
  
  void updateMessage(String message) {
    state = state.copyWith(message: message);
  }
  
  void reset() {
    state = FormData();
  }
  
  bool validate() {
    return state.name.isNotEmpty && 
           state.email.isNotEmpty && 
           state.email.contains('@') &&
           state.message.isNotEmpty;
  }
  
  Future<bool> submit() async {
    if (!validate()) {
      return false;
    }
    
    // 模拟提交延迟
    await Future.delayed(Duration(seconds: 3));
    print('Form submitted: ${state.name}, ${state.email}, ${state.message}');
    return true;
  }
}

// 使用autoDispose创建临时表单状态管理
final formProvider = NotifierProvider.autoDispose<FormNotifier, FormData>(FormNotifier.new);

// 简单的临时计数器示例
final tempCounterProvider = StateProvider.autoDispose<int>((ref) {
  print('TempCounter initialized');
  ref.onDispose(() {
    print('TempCounter disposed');
  });
  return 0;
});
