/// 共享的状态数据
///
class AppState{
  int counter;

  AppState({this.counter =0});

  AppState copyWith({int? counter}){
    return AppState(counter: counter??this.counter);
  }
}