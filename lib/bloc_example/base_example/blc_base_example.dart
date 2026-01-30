import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_manager/bloc_example/base_example/blc_counter_bloc.dart';
import 'package:state_manager/bloc_example/base_example/blc_counter_event.dart';
import 'package:state_manager/bloc_example/base_example/blc_counter_state.dart';

class BlcBaseExampleApp extends StatelessWidget {
  const BlcBaseExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlcCounterBloc(),
      child: MaterialApp(home: BlcBaseExample()),
    );
  }
}

class BlcBaseExample extends StatelessWidget {
  const BlcBaseExample({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BlcCounterBloc>();

    return Scaffold(
      appBar: AppBar(title: const Text('Base Bloc Counter Example')),
      body: Center(
        child: BlocBuilder<BlcCounterBloc, BlcCounterState>(
          builder: (context, state) => Text(
            'counter: ${state.count}',
            style: TextStyle(fontSize: 30, color: Colors.deepPurpleAccent),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => bloc.add(Increment()),
            child: Icon(Icons.add),
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            onPressed: () => bloc.add(Decrement()),
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
