
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../redux/app_state.dart';
import '../redux/actions.dart';

class NestedModulesPage extends StatelessWidget {
  const NestedModulesPage({super.key});

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
                _buildNestedInfo(),
                const SizedBox(height: 32),
                _buildAuthSection(viewModel),
                const SizedBox(height: 32),
                _buildUserSection(viewModel),
                const SizedBox(height: 32),
                _buildProductSection(viewModel),
                const SizedBox(height: 32),
                _buildStateTree(viewModel),
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
      title: const Text('Nested Modules Example'),
      backgroundColor: Colors.blue,
    );
  }

  // Build Nested Info
  Widget _buildNestedInfo() {
    return Card(
      elevation: 4,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nested State Structure',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This example demonstrates nested state management with Redux, where:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              '• AppState contains AuthState, UserState, and ProductState',
              style: TextStyle(fontSize: 14),
            ),
            const Text(
              '• UserState contains ProfileState and SettingsState',
              style: TextStyle(fontSize: 14),
            ),
            const Text(
              '• ProductState contains CatalogState and CartState',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'Each nested state has its own reducer, creating a clean, modular structure.',
              style: TextStyle(fontSize: 14),
            ),
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
              'User Module',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            
            // Profile Section
            _buildProfileSection(viewModel),
            const SizedBox(height: 24),
            
            // Settings Section
            _buildSettingsSection(viewModel),
          ],
        ),
      ),
    );
  }

  // Build Profile Section
  Widget _buildProfileSection(_ViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          onSubmitted: viewModel.onUpdateUserName,
          decoration: InputDecoration(
            labelText: 'Name',
            hintText: 'Enter your name',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          onSubmitted: viewModel.onUpdateUserEmail,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        if (viewModel.userName.isNotEmpty || viewModel.userEmail.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (viewModel.userName.isNotEmpty)
                Text(
                  'Current name: ${viewModel.userName}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              if (viewModel.userEmail.isNotEmpty)
                Text(
                  'Current email: ${viewModel.userEmail}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
            ],
          ),
      ],
    );
  }

  // Build Settings Section
  Widget _buildSettingsSection(_ViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Enable Notifications'),
            Switch(
              value: viewModel.notificationsEnabled,
              onChanged: (_) => viewModel.onToggleNotifications(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Dark Mode'),
            Switch(
              value: viewModel.darkModeEnabled,
              onChanged: (_) => viewModel.onToggleDarkMode(),
            ),
          ],
        ),
      ],
    );
  }

  // Build Product Section
  Widget _buildProductSection(_ViewModel viewModel) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product Module',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            
            // Catalog Section
            _buildCatalogSection(viewModel),
            const SizedBox(height: 24),
            
            // Cart Section
            _buildCartSection(viewModel),
          ],
        ),
      ),
    );
  }

  // Build Catalog Section
  Widget _buildCatalogSection(_ViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catalog',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: viewModel.products.map((product) {
            return ListTile(
              title: Text(product),
              trailing: ElevatedButton(
                onPressed: () => viewModel.onAddToCart(product),
                child: const Text('Add to Cart'),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Build Cart Section
  Widget _buildCartSection(_ViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cart',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        if (viewModel.cartItems.isEmpty)
          const Text('Cart is empty'),
        if (viewModel.cartItems.isNotEmpty)
          Column(
            children: [
              ...viewModel.cartItems.map((item) {
                return ListTile(
                  title: Text(item),
                  trailing: IconButton(
                    onPressed: () => viewModel.onRemoveFromCart(item),
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: viewModel.onClearCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Clear Cart'),
              ),
            ],
          ),
      ],
    );
  }

  // Build State Tree
  Widget _buildStateTree(_ViewModel viewModel) {
    return Card(
      elevation: 4,
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current State Tree',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            
            // Auth State
            const Text('• Auth', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('  - Logged In: ${viewModel.isLoggedIn}'),
            
            const SizedBox(height: 16),
            
            // User State
            const Text('• User', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('  - Profile'),
            Text('    * Name: ${viewModel.userName.isEmpty ? 'Not set' : viewModel.userName}'),
            Text('    * Email: ${viewModel.userEmail.isEmpty ? 'Not set' : viewModel.userEmail}'),
            const Text('  - Settings'),
            Text('    * Notifications: ${viewModel.notificationsEnabled}'),
            Text('    * Dark Mode: ${viewModel.darkModeEnabled}'),
            
            const SizedBox(height: 16),
            
            // Product State
            const Text('• Product', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('  - Catalog'),
            Text('    * Products: ${viewModel.products.length} items'),
            const Text('  - Cart'),
            Text('    * Items: ${viewModel.cartItems.length} items'),
            if (viewModel.cartItems.isNotEmpty)
              Column(
                children: viewModel.cartItems.map((item) {
                  return Text('    * $item');
                }).toList(),
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
  final String userName;
  final String userEmail;
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final List<String> products;
  final List<String> cartItems;
  final VoidCallback onLogin;
  final VoidCallback onLogout;
  final Function(String) onUpdateUserName;
  final Function(String) onUpdateUserEmail;
  final VoidCallback onToggleNotifications;
  final VoidCallback onToggleDarkMode;
  final Function(String) onAddToCart;
  final Function(String) onRemoveFromCart;
  final VoidCallback onClearCart;

  _ViewModel({
    required this.isLoggedIn,
    required this.userName,
    required this.userEmail,
    required this.notificationsEnabled,
    required this.darkModeEnabled,
    required this.products,
    required this.cartItems,
    required this.onLogin,
    required this.onLogout,
    required this.onUpdateUserName,
    required this.onUpdateUserEmail,
    required this.onToggleNotifications,
    required this.onToggleDarkMode,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.onClearCart,
  });

  factory _ViewModel.fromStore(Store<AppState> store) {
    return _ViewModel(
      isLoggedIn: store.state.auth.loggedIn,
      userName: store.state.user.profile.name,
      userEmail: store.state.user.profile.email,
      notificationsEnabled: store.state.user.settings.notificationsEnabled,
      darkModeEnabled: store.state.user.settings.darkModeEnabled,
      products: store.state.product.catalog.products,
      cartItems: store.state.product.cart.items,
      onLogin: () => store.dispatch(LoginAction()),
      onLogout: () => store.dispatch(LogoutAction()),
      onUpdateUserName: (name) => store.dispatch(UpdateUserNameAction(name)),
      onUpdateUserEmail: (email) => store.dispatch(UpdateUserEmailAction(email)),
      onToggleNotifications: () => store.dispatch(ToggleNotificationsAction()),
      onToggleDarkMode: () => store.dispatch(ToggleDarkModeAction()),
      onAddToCart: (product) => store.dispatch(AddToCartAction(product)),
      onRemoveFromCart: (product) => store.dispatch(RemoveFromCartAction(product)),
      onClearCart: () => store.dispatch(ClearCartAction()),
    );
  }
}
