
/// 认证相关 Actions
class LoginAction {}

class LogoutAction {}

/// 用户资料相关 Actions
class UpdateUserNameAction {
  final String name;

  UpdateUserNameAction(this.name);
}

class UpdateUserEmailAction {
  final String email;

  UpdateUserEmailAction(this.email);
}

/// 用户设置相关 Actions
class ToggleNotificationsAction {}

class ToggleDarkModeAction {}

/// 购物车相关 Actions
class AddToCartAction {
  final String product;

  AddToCartAction(this.product);
}

class RemoveFromCartAction {
  final String product;

  RemoveFromCartAction(this.product);
}

class ClearCartAction {}
