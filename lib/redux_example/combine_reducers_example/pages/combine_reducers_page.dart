
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../redux/app_state.dart';
import '../redux/actions.dart';

class CombineReducersPage extends StatelessWidget {
  const CombineReducersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store),
      builder: (context, viewModel) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAuthSection(viewModel),
                const SizedBox(height: 32),
                _buildCounterSection(viewModel),
                const SizedBox(height: 32),
                _buildUserSection(viewModel),
                const SizedBox(height: 32),
                _buildStateInfo(viewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build App Bar
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Combine Reducers Example'),
      backgroundColor: Colors.blue,
    );
  }

  // Build Auth Section
  Widget _buildAuthSection(_ViewModel viewModel) {
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Status: ${viewModel.isLoggedIn ? 'Logged In' : 'Logged Out'}',
                    style: TextStyle(
                      fontSize: 16,
                      color: viewModel.isLoggedIn ? Colors.green : Colors.red,
                    ),
                  ),
                ),
                if (!viewModel.isLoggedIn)
                  ElevatedButton(
                    onPressed: viewModel.onLogin,
                    child: const Text('Login'),
                  ),
                if (viewModel.isLoggedIn)
                  ElevatedButton(
                    onPressed: viewModel.onLogout,
                    child: const Text('Logout'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build Counter Section
  Widget _buildCounterSection(_ViewModel viewModel) {
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
              child: Text(
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
          ],
        ),
      ),
    );
  }

  // Build User Section
  Widget _buildUserSection(_ViewModel viewModel) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Info',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onSubmitted: viewModel.onUpdateUserName,
              decoration: InputDecoration(
                labelText: 'Enter your name',
                hintText: 'John Doe',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (viewModel.userName.isNotEmpty)
              Text(
                'Current user: ${viewModel.userName}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Build State Info
  Widget _buildStateInfo(_ViewModel viewModel) {
    return Card(
      elevation: 4,
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current State',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Auth: ${viewModel.isLoggedIn ? 'Logged In' : 'Logged Out'}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Counter: ${viewModel.count}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'User: ${viewModel.userName.isEmpty ? 'Not set' : viewModel.userName}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

/// ViewModel
class _ViewModel {
  final bool isLoggedIn;
  final int count;
  final String userName;
  final VoidCallback onLogin;
  final VoidCallback onLogout;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onReset;
  final Function(String) onUpdateUserName;

  _ViewModel({
    required this.isLoggedIn,
    required this.count,
    required this.userName,
    required this.onLogin,
    required this.onLogout,
    required this.onIncrement,
    required this.onDecrement,
    required this.onReset,
    required this.onUpdateUserName,
  });

  factory _ViewModel.fromStore(Store<AppState> store) {
    return _ViewModel(
      isLoggedIn: store.state.auth.loggedIn,
      count: store.state.counter.count,
      userName: store.state.user.name,
      onLogin: () => store.dispatch(LoginAction()),
      onLogout: () => store.dispatch(LogoutAction()),
      onIncrement: () => store.dispatch(IncrementAction()),
      onDecrement: () => store.dispatch(DecrementAction()),
      onReset: () => store.dispatch(ResetAction()),
      onUpdateUserName: (name) => store.dispatch(UpdateUserNameAction(name)),
    );
  }
}
