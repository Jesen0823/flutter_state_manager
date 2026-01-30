import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_manager/bloc_example/multi_repository_example/blocs/settings/settings_bloc.dart';
import 'package:state_manager/bloc_example/multi_repository_example/blocs/settings/settings_state.dart';
import 'package:state_manager/bloc_example/multi_repository_example/blocs/user/user_bloc.dart';
import 'package:state_manager/bloc_example/multi_repository_example/pages/settings_page.dart';
import 'package:state_manager/bloc_example/multi_repository_example/pages/user_page.dart';
import 'package:state_manager/bloc_example/multi_repository_example/repositories/settings_repository.dart';
import 'package:state_manager/bloc_example/multi_repository_example/repositories/user_repository.dart';

class RepositoryExampleApp extends StatelessWidget {
  const RepositoryExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => UserRepository()),
        RepositoryProvider(create: (_) => SettingsRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserBloc(context.read<UserRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                SettingsBloc(context.read<SettingsRepository>()),
          ),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            bool isDarkMode = false;
            if (state is SettingsTheme) {
              isDarkMode = state.isDarkMode;
            }

            return MaterialApp(
              title: 'MultiRepositoryProvider Example',
              theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
              home: ExamplePage(),
            );
          },
        ),
      ),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [const UserPage(), const SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MultiRepositoryProvider Example')),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings',),
        ],
        showSelectedLabels: true,
      ),
    );
  }
}
