
/// 认证相关 Actions
class LoginAction {}

class LogoutAction {}

/// 计数器相关 Actions
class IncrementAction {}

class DecrementAction {}

class ResetAction {}

/// 用户相关 Actions
class UpdateUserNameAction {
  final String name;

  UpdateUserNameAction(this.name);
}

/// 持久化相关 Actions
class ClearStorageAction {}
