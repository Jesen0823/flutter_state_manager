import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_manager/bloc_example/consumer_example/bl_user_bloc.dart';
import 'package:state_manager/bloc_example/consumer_example/bl_user_event.dart';
import 'package:state_manager/bloc_example/consumer_example/bl_user_state.dart';

class BlConsumerExample extends StatelessWidget {
  const BlConsumerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => BlUserBloc(), child: ExampleView());
  }
}

class ExampleView extends StatelessWidget {
  const ExampleView({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取bloc实例
    final bloc = context.read<BlUserBloc>();

    return Scaffold(
      appBar: AppBar(title: const Text('BlocConsumer example')),
      body: BlocConsumer<BlUserBloc, BlUserState>(
        builder: (context, state) {
          if (state is UserInitial) {
            return Center(
              child: ElevatedButton(
                onPressed: () => bloc.add(BlFetchUserEvent()),
                child: const Text('Load User'),
              ),
            );
          } else if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: ${state.name}'),
                  SizedBox(height: 30),
                  Text('Email: ${state.email}'),
                ],
              ),
            );
          } else {
            return Center(child: const Text('Unknown state'));
          }
        },
        listener: (context, state) {
          if (state is UserError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
      ),
    );
  }
}
