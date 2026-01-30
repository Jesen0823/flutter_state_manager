import 'dart:ui';

class ViewModel {
  final bool loggedIn;
  final bool isLiking;
  final int likeCount;
  final VoidCallback onLogin;
  final VoidCallback onLike;
  final VoidCallback onLogout;

  ViewModel({
    required this.loggedIn,
    required this.isLiking,
    required this.likeCount,
    required this.onLogin,
    required this.onLike,
    required this.onLogout,
  });
}
