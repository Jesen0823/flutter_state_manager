
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../redux/app_state.dart';
import '../redux/actions.dart';

class ViewModelExamplePage extends StatelessWidget {
  const ViewModelExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _MainViewModel>(
      converter: (store) => _MainViewModel.fromStore(store),
      builder: (context, viewModel) {
        return Theme(
          data: viewModel.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          child: Scaffold(
            appBar: _buildAppBar(viewModel),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildViewModelInfo(),
                  const SizedBox(height: 32),
                  _buildAuthSection(),
                  const SizedBox(height: 32),
                  _buildCounterSection(),
                  const SizedBox(height: 32),
                  _buildUserSection(),
                  const SizedBox(height: 32),
                  _buildThemeSection(viewModel),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Build App Bar
  AppBar _buildAppBar(_MainViewModel viewModel) {
    return AppBar(
      title: const Text('ViewModel Example'),
      backgroundColor: Colors.blue,
      actions: [
        IconButton(
          onPressed: viewModel.onToggleTheme,
          icon: Icon(viewModel.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          tooltip: 'Toggle Theme',
        ),
      ],
    );
  }

  // Build ViewModel Info
  Widget _buildViewModelInfo() {
    return Card(
      elevation: 4,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ViewModel Pattern',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'The ViewModel pattern separates UI concerns from state management by:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text('• Encapsulating state and actions in a ViewModel', style: TextStyle(fontSize: 14)),
            const Text('• Using StoreConnector to map state to ViewModel', style: TextStyle(fontSize: 14)),
            const Text('• Providing a clean API for the UI to interact with Redux', style: TextStyle(fontSize: 14)),
            const Text('• Improving testability and maintainability', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  // Build Auth Section
  Widget _buildAuthSection() {
    return StoreConnector<AppState, _AuthViewModel>(
      converter: (store) => _AuthViewModel.fromStore(store),
      builder: (context, viewModel) {
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Authentication',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Status: ${viewModel.isLoggedIn ? 'Logged In' : 'Logged Out'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: viewModel.isLoggedIn ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                if (!viewModel.isLoggedIn)
                  ElevatedButton(
                    onPressed: viewModel.onLogin,
                    child: const Text('Login with Demo Account'),
                  ),
                if (viewModel.isLoggedIn)
                  ElevatedButton(
                    onPressed: viewModel.onLogout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Logout'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build Counter Section
  Widget _buildCounterSection() {
    return StoreConnector<AppState, _CounterViewModel>(
      converter: (store) => _CounterViewModel.fromStore(store),
      builder: (context, viewModel) {
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Counter',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: viewModel.isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          'Count: ${viewModel.count}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: viewModel.onSimulateLoading,
                  child: const Text('Simulate Loading'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build User Section
  Widget _buildUserSection() {
    return StoreConnector<AppState, _UserViewModel>(
      converter: (store) => _UserViewModel.fromStore(store),
      builder: (context, viewModel) {
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'User Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  onSubmitted: (value) => viewModel.onUpdateUser(value, viewModel.email),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your name',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  onSubmitted: (value) => viewModel.onUpdateUser(viewModel.name, value),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                if (viewModel.isProfileComplete)
                  Text(
                    'Profile Complete!',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                if (!viewModel.isProfileComplete)
                  Text(
                    'Please complete your profile',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build Theme Section
  Widget _buildThemeSection(_MainViewModel viewModel) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Current theme: ${viewModel.themeName}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: viewModel.onToggleTheme,
              child: Text('Switch to ${viewModel.isDarkMode ? 'Light' : 'Dark'} Theme'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => viewModel.onSetTheme('Light'),
                  child: const Text('Light'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => viewModel.onSetTheme('Dark'),
                  child: const Text('Dark'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Main ViewModel
class _MainViewModel {
  final bool isDarkMode;
  final String themeName;
  final VoidCallback onToggleTheme;
  final Function(String) onSetTheme;

  _MainViewModel({
    required this.isDarkMode,
    required this.themeName,
    required this.onToggleTheme,
    required this.onSetTheme,
  });

  factory _MainViewModel.fromStore(Store<AppState> store) {
    return _MainViewModel(
      isDarkMode: store.state.theme.isDarkMode,
      themeName: store.state.theme.themeName,
      onToggleTheme: () => store.dispatch(ToggleThemeAction()),
      onSetTheme: (themeName) => store.dispatch(SetThemeAction(themeName)),
    );
  }
}

/// Auth ViewModel
class _AuthViewModel {
  final bool isLoggedIn;
  final VoidCallback onLogin;
  final VoidCallback onLogout;

  _AuthViewModel({
    required this.isLoggedIn,
    required this.onLogin,
    required this.onLogout,
  });

  factory _AuthViewModel.fromStore(Store<AppState> store) {
    return _AuthViewModel(
      isLoggedIn: store.state.auth.loggedIn,
      onLogin: () {
        store.dispatch(LoginAction('demo@example.com', 'password123'));
        // Simulate login success
        Future.delayed(const Duration(seconds: 1), () {
          store.dispatch(LoginSuccessAction('demo-token-${DateTime.now().millisecondsSinceEpoch}'));
        });
      },
      onLogout: () => store.dispatch(LogoutAction()),
    );
  }
}

/// Counter ViewModel
class _CounterViewModel {
  final int count;
  final bool isLoading;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onReset;
  final VoidCallback onSimulateLoading;

  _CounterViewModel({
    required this.count,
    required this.isLoading,
    required this.onIncrement,
    required this.onDecrement,
    required this.onReset,
    required this.onSimulateLoading,
  });

  factory _CounterViewModel.fromStore(Store<AppState> store) {
    return _CounterViewModel(
      count: store.state.counter.count,
      isLoading: store.state.counter.isLoading,
      onIncrement: () => store.dispatch(IncrementAction()),
      onDecrement: () => store.dispatch(DecrementAction()),
      onReset: () => store.dispatch(ResetAction()),
      onSimulateLoading: () {
        store.dispatch(SetLoadingAction(true));
        Future.delayed(const Duration(seconds: 2), () {
          store.dispatch(SetLoadingAction(false));
        });
      },
    );
  }
}

/// User ViewModel
class _UserViewModel {
  final String name;
  final String email;
  final bool isProfileComplete;
  final Function(String, String) onUpdateUser;

  _UserViewModel({
    required this.name,
    required this.email,
    required this.isProfileComplete,
    required this.onUpdateUser,
  });

  factory _UserViewModel.fromStore(Store<AppState> store) {
    return _UserViewModel(
      name: store.state.user.name,
      email: store.state.user.email,
      isProfileComplete: store.state.user.isProfileComplete,
      onUpdateUser: (name, email) => store.dispatch(UpdateUserAction(name, email)),
    );
  }
}
