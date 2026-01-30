class MWAppState {
  final bool loggedIn;
  final bool isLiking;
  final int likeCount;

  MWAppState({
    required this.loggedIn,
    required this.isLiking,
    required this.likeCount,
  });

  MWAppState copyWith({bool? loggedIn, bool? isLiking, int? likeCount}) {
    return MWAppState(
      loggedIn: loggedIn ?? this.loggedIn,
      isLiking: isLiking ?? this.isLiking,
      likeCount: likeCount ?? this.likeCount,
    );
  }

  static MWAppState initial() =>
      MWAppState(loggedIn: false, isLiking: false, likeCount: 0);
}
