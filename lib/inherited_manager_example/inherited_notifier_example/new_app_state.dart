import 'package:flutter/foundation.dart';
/// ChangeNotifier 是一个可监听的类，状态变更 + 通知监听者
///
class NewAppState extends ChangeNotifier{
  int _counter =0;
  int get counter => _counter;

  void increment(){
    _counter++;
    notifyListeners();
  }

  void decrement(){
    _counter--;
    notifyListeners();
  }

  void setCounter(int value){
    _counter = value;
    notifyListeners();
  }
}