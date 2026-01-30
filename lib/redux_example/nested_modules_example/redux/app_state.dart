
/// 应用状态（根状态）
class AppState {
  final AuthState auth;
  final UserState user;
  final ProductState product;

  AppState({
    required this.auth,
    required this.user,
    required this.product,
  });

  factory AppState.initial() {
    return AppState(
      auth: AuthState.initial(),
      user: UserState.initial(),
      product: ProductState.initial(),
    );
  }

  @override
  String toString() {
    return 'AppState(auth: $auth, user: $user, product: $product)';
  }
}

/// 认证状态
class AuthState {
  final bool loggedIn;

  AuthState(this.loggedIn);

  factory AuthState.initial() {
    return AuthState(false);
  }

  @override
  String toString() {
    return 'AuthState(loggedIn: $loggedIn)';
  }
}

/// 用户状态（包含嵌套状态）
class UserState {
  final ProfileState profile;
  final SettingsState settings;

  UserState({
    required this.profile,
    required this.settings,
  });

  factory UserState.initial() {
    return UserState(
      profile: ProfileState.initial(),
      settings: SettingsState.initial(),
    );
  }

  @override
  String toString() {
    return 'UserState(profile: $profile, settings: $settings)';
  }
}

/// 个人资料状态
class ProfileState {
  final String name;
  final String email;

  ProfileState({
    required this.name,
    required this.email,
  });

  factory ProfileState.initial() {
    return ProfileState(
      name: '',
      email: '',
    );
  }

  @override
  String toString() {
    return 'ProfileState(name: $name, email: $email)';
  }
}

/// 设置状态
class SettingsState {
  final bool notificationsEnabled;
  final bool darkModeEnabled;

  SettingsState({
    required this.notificationsEnabled,
    required this.darkModeEnabled,
  });

  factory SettingsState.initial() {
    return SettingsState(
      notificationsEnabled: true,
      darkModeEnabled: false,
    );
  }

  @override
  String toString() {
    return 'SettingsState(notifications: $notificationsEnabled, darkMode: $darkModeEnabled)';
  }
}

/// 产品状态（包含嵌套状态）
class ProductState {
  final CatalogState catalog;
  final CartState cart;

  ProductState({
    required this.catalog,
    required this.cart,
  });

  factory ProductState.initial() {
    return ProductState(
      catalog: CatalogState.initial(),
      cart: CartState.initial(),
    );
  }

  @override
  String toString() {
    return 'ProductState(catalog: $catalog, cart: $cart)';
  }
}

/// 目录状态
class CatalogState {
  final List<String> products;

  CatalogState(this.products);

  factory CatalogState.initial() {
    return CatalogState([
      'Product 1',
      'Product 2',
      'Product 3',
      'Product 4',
      'Product 5',
    ]);
  }

  @override
  String toString() {
    return 'CatalogState(products: $products)';
  }
}

/// 购物车状态
class CartState {
  final List<String> items;

  CartState(this.items);

  factory CartState.initial() {
    return CartState([]);
  }

  @override
  String toString() {
    return 'CartState(items: $items)';
  }
}
