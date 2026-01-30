import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_manager/bloc_example/multi_repository_example/blocs/user/user_bloc.dart';
import 'package:state_manager/bloc_example/multi_repository_example/blocs/user/user_event.dart';
import 'package:state_manager/bloc_example/multi_repository_example/blocs/user/user_state.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      builder: (context, state) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'User Information',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                _buildUserContent(context, state),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is UserError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
    );
  }

  Widget _buildUserContent(BuildContext context, UserState state) {
    if (state is UserInitial) {
      return ElevatedButton(
        onPressed: () => context.read<UserBloc>().add(FetchUserEvent()),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          textStyle: const TextStyle(fontSize: 18),
        ),
        child: const Text('Load User'),
      );
    } else if (state is UserLoaded) {
      return Column(
        children: [
          const Icon(Icons.person, size: 80),
          const SizedBox(height: 20),
          Text(
            'Hello, ${state.name}!',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      );
    } else {
      return const CircularProgressIndicator(strokeWidth: 4);
    }
  }
}
