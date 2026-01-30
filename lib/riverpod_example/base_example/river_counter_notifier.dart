import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverCounterNotifier extends StateNotifier<int> {
  RiverCounterNotifier() : super(0);

  void increment() => state++;

  void reset() => state = 0;
}

final counterProvider = StateNotifierProvider<RiverCounterNotifier, int>(
  (ref) => RiverCounterNotifier(),
);


// 抽离逻辑方法（对外暴露 API）
int useCounter(WidgetRef ref) => ref.watch(counterProvider);

void incrementCounter(WidgetRef ref) => ref.read(counterProvider.notifier).increment();

void resetCounter(WidgetRef ref) => ref.read(counterProvider.notifier).reset();
