import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

/// 应用状态
class ReduxAppState {
  final int counter;

  ReduxAppState({required this.counter});
}

// Action
enum CounterAction { increment, decrement, reset }

// Reducer
ReduxAppState reduxCounterReducer(ReduxAppState state, dynamic action) {
  if (action == CounterAction.increment) {
    return ReduxAppState(counter: state.counter + 1);
  } else if (action == CounterAction.decrement) {
    return ReduxAppState(counter: state.counter - 1);
  } else if (action == CounterAction.reset) {
    return ReduxAppState(counter: 0);
  }
  return state;
}

// 根组件
class ReduxExampleApp extends StatelessWidget {
  const ReduxExampleApp({super.key, required this.store});

  final Store<ReduxAppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<ReduxAppState>(
      store: store,
      child: MaterialApp(
        title: 'Redux Counter Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ReduxBaseExample(),
      ),
    );
  }
}

/// 页面组件
class ReduxBaseExample extends StatelessWidget {
  const ReduxBaseExample({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<ReduxAppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store),
      builder: (context, viewModel) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(viewModel),
          floatingActionButton: _buildFloatingActionButton(viewModel),
        );
      },
    );
  }

  // Build App Bar
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Base Redux Counter Example'),
      backgroundColor: Colors.blue,
    );
  }

  // Build Body
  Widget _buildBody(_ViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Counter: ${viewModel.counter}',
            style: const TextStyle(fontSize: 32, color: Colors.cyan),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: viewModel.onDecrement,
                child: const Text('-'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: viewModel.onReset,
                child: const Text('Reset'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: viewModel.onIncrement,
                child: const Text('+'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build Floating Action Button
  Widget _buildFloatingActionButton(_ViewModel viewModel) {
    return FloatingActionButton(
      onPressed: viewModel.onIncrement,
      child: const Icon(Icons.add),
      backgroundColor: Colors.blue,
    );
  }
}

/// ViewModel
class _ViewModel {
  final int counter;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onReset;

  _ViewModel({
    required this.counter,
    required this.onIncrement,
    required this.onDecrement,
    required this.onReset,
  });

  factory _ViewModel.fromStore(Store<ReduxAppState> store) {
    return _ViewModel(
      counter: store.state.counter,
      onIncrement: () => store.dispatch(CounterAction.increment),
      onDecrement: () => store.dispatch(CounterAction.decrement),
      onReset: () => store.dispatch(CounterAction.reset),
    );
  }
}
