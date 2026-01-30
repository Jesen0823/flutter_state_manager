
import 'app_state.dart';
import 'actions.dart';

/// 认证状态 Reducer
AuthState authReducer(AuthState state, dynamic action) {
  if (action is LoginAction) {
    return AuthState(true);
  } else if (action is LogoutAction) {
    return AuthState(false);
  }
  return state;
}

/// 个人资料状态 Reducer
ProfileState profileReducer(ProfileState state, dynamic action) {
  if (action is UpdateUserNameAction) {
    return ProfileState(name: action.name, email: state.email);
  } else if (action is UpdateUserEmailAction) {
    return ProfileState(name: state.name, email: action.email);
  }
  return state;
}

/// 设置状态 Reducer
SettingsState settingsReducer(SettingsState state, dynamic action) {
  if (action is ToggleNotificationsAction) {
    return SettingsState(notificationsEnabled: !state.notificationsEnabled, darkModeEnabled: state.darkModeEnabled);
  } else if (action is ToggleDarkModeAction) {
    return SettingsState(notificationsEnabled: state.notificationsEnabled, darkModeEnabled: !state.darkModeEnabled);
  }
  return state;
}

/// 用户状态 Reducer（包含嵌套 reducers）
UserState userReducer(UserState state, dynamic action) {
  return UserState(
    profile: profileReducer(state.profile, action),
    settings: settingsReducer(state.settings, action),
  );
}

/// 目录状态 Reducer
CatalogState catalogReducer(CatalogState state, dynamic action) {
  // Catalog state is immutable in this example
  return state;
}

/// 购物车状态 Reducer
CartState cartReducer(CartState state, dynamic action) {
  if (action is AddToCartAction) {
    if (!state.items.contains(action.product)) {
      return CartState([...state.items, action.product]);
    }
  } else if (action is RemoveFromCartAction) {
    return CartState([...state.items]..remove(action.product));
  } else if (action is ClearCartAction) {
    return CartState([]);
  }
  return state;
}

/// 产品状态 Reducer（包含嵌套 reducers）
ProductState productReducer(ProductState state, dynamic action) {
  return ProductState(
    catalog: catalogReducer(state.catalog, action),
    cart: cartReducer(state.cart, action),
  );
}

/// 根 AppState Reducer（组合所有 reducers）
AppState appReducer(AppState state, dynamic action) {
  return AppState(
    auth: authReducer(state.auth, action),
    user: userReducer(state.user, action),
    product: productReducer(state.product, action),
  );
}
