import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_manager/bloc_example/multi_repository_example/blocs/user/user_event.dart';
import 'package:state_manager/bloc_example/multi_repository_example/blocs/user/user_state.dart';
import 'package:state_manager/bloc_example/multi_repository_example/repositories/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<FetchUserEvent>((event, emit) async {
      emit(UserLoading());
      try{
        final name = await userRepository.fetchUserName();
        emit(UserLoaded(name: name));
      }catch(e){
        emit(UserError(e.toString()));
      }
    });
  }
}
