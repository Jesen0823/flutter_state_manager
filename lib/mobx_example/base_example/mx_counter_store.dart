import 'package:mobx/mobx.dart';

part 'mx_counter_store.g.dart';

class MxCounterStore = _MxCounterStore with _$MxCounterStore;

abstract class _MxCounterStore with Store{
  @observable
  int count = 0;

  @action
  void increment(){
    count++;
  }
}