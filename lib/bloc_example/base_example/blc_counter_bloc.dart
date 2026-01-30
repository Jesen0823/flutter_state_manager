import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_manager/bloc_example/base_example/blc_counter_event.dart';
import 'package:state_manager/bloc_example/base_example/blc_counter_state.dart';

class BlcCounterBloc extends Bloc<BlcCounterEvent,BlcCounterState>{
  BlcCounterBloc():super(BlcCounterState(0)){
    on<Increment>((event,emit)=>emit(BlcCounterState(state.count+1)));
    on<Decrement>((event,emit)=>emit(BlcCounterState(state.count-1)));
  }

}