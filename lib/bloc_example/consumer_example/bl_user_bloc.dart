import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_manager/bloc_example/consumer_example/bl_user_event.dart';
import 'package:state_manager/bloc_example/consumer_example/bl_user_state.dart';

class BlUserBloc extends Bloc<BlUserEvent, BlUserState> {
  BlUserBloc() : super(UserInitial()) {
    on<BlFetchUserEvent>((event, emit) async {
      emit(UserLoading());
      await Future.delayed(Duration(seconds: 3)); // 模拟网络

      try {
        // 模拟网络API返回
        final name = 'Jesen';
        final email = 'jesen@333.com';
        emit(UserLoaded(name: name, email: email));
      } catch (e) {
        emit(UserError('Failed to fetch data'));
      }
    });
  }
}
