// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mx_counter_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MxCounterStore on _MxCounterStore, Store {
  late final _$countAtom = Atom(
    name: '_MxCounterStore.count',
    context: context,
  );

  @override
  int get count {
    _$countAtom.reportRead();
    return super.count;
  }

  @override
  set count(int value) {
    _$countAtom.reportWrite(value, super.count, () {
      super.count = value;
    });
  }

  late final _$_MxCounterStoreActionController = ActionController(
    name: '_MxCounterStore',
    context: context,
  );

  @override
  void increment() {
    final _$actionInfo = _$_MxCounterStoreActionController.startAction(
      name: '_MxCounterStore.increment',
    );
    try {
      return super.increment();
    } finally {
      _$_MxCounterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
count: ${count}
    ''';
  }
}
