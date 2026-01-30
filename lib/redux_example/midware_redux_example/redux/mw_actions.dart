// 登录 Action
class ActionLogin {}

class ActionLogout {}

// 点赞相关
class ActionLikeRequest {}

class ActionLikeSuccess {}

class ActionLikeFailed {}

// UI通知
class ActionShowToast {
  final String message;

  ActionShowToast(this.message);
}
