
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

class LogoutAction {}

/// 计数器相关 Actions
class IncrementAction {}

class DecrementAction {}

class ResetAction {}

class SetLoadingAction {
  final bool isLoading;

  SetLoadingAction(this.isLoading);
}

/// 用户相关 Actions
class UpdateUserAction {
  final String name;
  final String email;

  UpdateUserAction(this.name, this.email);
}

/// 主题相关 Actions
class ToggleThemeAction {}

class SetThemeAction {
  final String themeName;

  SetThemeAction(this.themeName);
}
