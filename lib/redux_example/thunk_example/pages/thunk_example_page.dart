import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../redux/app_state.dart';
import '../redux/actions.dart';

class ThunkExamplePage extends StatelessWidget {
  const ThunkExamplePage({super.key});

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
                _buildThunkInfo(),
                const SizedBox(height: 32),
                _buildAuthSection(viewModel),
                const SizedBox(height: 32),
                _buildUserSection(viewModel),
                const SizedBox(height: 32),
                _buildPostsSection(viewModel),
                const SizedBox(height: 32),
                _buildCounterSection(viewModel),
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
      title: const Text('Thunk Example'),
      backgroundColor: Colors.blue,
    );
  }

  // Build Thunk Info
  Widget _buildThunkInfo() {
    return Card(
      elevation: 4,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Redux Thunk',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Thunk middleware allows you to dispatch async actions in Redux:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text('• Handle network requests and API calls', style: TextStyle(fontSize: 14)),
            const Text('• Manage loading states and error handling', style: TextStyle(fontSize: 14)),
            const Text('• Perform side effects like navigation', style: TextStyle(fontSize: 14)),
            const Text('• Chain multiple actions together', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
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
            Text(
              'Status: ${viewModel.isLoggedIn ? 'Logged In' : 'Logged Out'}',
              style: TextStyle(
                fontSize: 16,
                color: viewModel.isLoggedIn ? Colors.green : Colors.red,
              ),
            ),
            if (viewModel.authError != null)
              Text(
                'Error: ${viewModel.authError}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
            const SizedBox(height: 16),
            if (!viewModel.isLoggedIn)
              viewModel.isAuthLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
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
              'User Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: viewModel.onFetchUser,
              child: const Text('Fetch User Data'),
            ),
            const SizedBox(height: 16),
            if (viewModel.isUserLoading)
              const CircularProgressIndicator(),
            if (viewModel.userError != null)
              Text(
                'Error: ${viewModel.userError}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
            if (!viewModel.isUserLoading && viewModel.userName.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${viewModel.userName}', style: const TextStyle(fontSize: 16)),
                  Text('Email: ${viewModel.userEmail}', style: const TextStyle(fontSize: 16)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Build Posts Section
  Widget _buildPostsSection(_ViewModel viewModel) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Posts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: viewModel.onFetchPosts,
              child: const Text('Fetch Posts'),
            ),
            const SizedBox(height: 16),
            if (viewModel.isPostsLoading)
              const CircularProgressIndicator(),
            if (viewModel.postsError != null)
              Text(
                'Error: ${viewModel.postsError}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
            if (!viewModel.isPostsLoading && viewModel.posts.isNotEmpty)
              Column(
                children: [
                  Text('Posts fetched: ${viewModel.posts.length}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  ...viewModel.posts.take(3).map((post) {
                    return Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(post.body, style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  if (viewModel.posts.length > 3)
                    Text('... and ${viewModel.posts.length - 3} more posts', style: const TextStyle(fontSize: 14, color: Colors.grey)),
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
            const SizedBox(height: 16),
            Center(
              child: viewModel.isCounterLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: viewModel.onIncrementAsync,
                      child: const Text('Increment Async'),
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
            Text('Auth: ${viewModel.isLoggedIn ? 'Logged In' : 'Logged Out'}'),
            Text('User: ${viewModel.userName.isEmpty ? 'Not fetched' : viewModel.userName}'),
            Text('Posts: ${viewModel.posts.length}'),
            Text('Counter: ${viewModel.count}'),
          ],
        ),
      ),
    );
  }
}

/// ViewModel
class _ViewModel {
  final bool isLoggedIn;
  final bool isAuthLoading;
  final String? authError;
  final String userName;
  final String userEmail;
  final bool isUserLoading;
  final String? userError;
  final List<Post> posts;
  final bool isPostsLoading;
  final String? postsError;
  final int count;
  final bool isCounterLoading;
  final VoidCallback onLogin;
  final VoidCallback onLogout;
  final VoidCallback onFetchUser;
  final VoidCallback onFetchPosts;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onReset;
  final VoidCallback onIncrementAsync;

  _ViewModel({
    required this.isLoggedIn,
    required this.isAuthLoading,
    this.authError,
    required this.userName,
    required this.userEmail,
    required this.isUserLoading,
    this.userError,
    required this.posts,
    required this.isPostsLoading,
    this.postsError,
    required this.count,
    required this.isCounterLoading,
    required this.onLogin,
    required this.onLogout,
    required this.onFetchUser,
    required this.onFetchPosts,
    required this.onIncrement,
    required this.onDecrement,
    required this.onReset,
    required this.onIncrementAsync,
  });

  factory _ViewModel.fromStore(Store<AppState> store) {
    return _ViewModel(
      isLoggedIn: store.state.auth.isLoggedIn,
      isAuthLoading: store.state.auth.isLoading,
      authError: store.state.auth.error,
      userName: store.state.user.name,
      userEmail: store.state.user.email,
      isUserLoading: store.state.user.isLoading,
      userError: store.state.user.error,
      posts: store.state.posts.posts,
      isPostsLoading: store.state.posts.isLoading,
      postsError: store.state.posts.error,
      count: store.state.counter.count,
      isCounterLoading: store.state.counter.isLoading,
      onLogin: () => store.dispatch(loginThunk('demo@example.com', 'password123')),
      onLogout: () => store.dispatch(LogoutAction()),
      onFetchUser: () => store.dispatch(fetchUserThunk()),
      onFetchPosts: () => store.dispatch(fetchPostsThunk()),
      onIncrement: () => store.dispatch(IncrementAction()),
      onDecrement: () => store.dispatch(DecrementAction()),
      onReset: () => store.dispatch(ResetAction()),
      onIncrementAsync: () => store.dispatch(incrementAsyncThunk()),
    );
  }
}
