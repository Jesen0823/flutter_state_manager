import 'package:flutter/material.dart';

class ProviderCounterModel extends ChangeNotifier{
  int _count = 0;

  int get count => _count;

  void increment(){
    _count++;
    notifyListeners(); // 通知UI更新
  }
}