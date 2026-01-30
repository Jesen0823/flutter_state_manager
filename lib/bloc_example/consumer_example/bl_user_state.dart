abstract class BlUserState {}

class UserInitial extends BlUserState {}

class UserLoading extends BlUserState {}

class UserLoaded extends BlUserState {
  final String name;
  final String email;

  UserLoaded({required this.name, required this.email});
}

class UserError extends BlUserState {
  final String message;

  UserError(this.message);
}
