
import 'app_state.dart';
import 'actions.dart';

/// 认证状态 Reducer
AuthState authReducer(AuthState state, dynamic action) {
  if (action is LoginSuccessAction) {
    return AuthState(
      loggedIn: true,
      token: action.token,
    );
  } else if (action is LogoutAction) {
    return AuthState.initial();
  }
  return state;
}

/// 计数器状态 Reducer
CounterState counterReducer(CounterState state, dynamic action) {
  if (action is IncrementAction) {
    return CounterState(
      count: state.count + 1,
      isLoading: state.isLoading,
    );
  } else if (action is DecrementAction) {
    return CounterState(
      count: state.count - 1,
      isLoading: state.isLoading,
    );
  } else if (action is ResetAction) {
    return CounterState(
      count: 0,
      isLoading: state.isLoading,
    );
  } else if (action is SetLoadingAction) {
    return CounterState(
      count: state.count,
      isLoading: action.isLoading,
    );
  }
  return state;
}

/// 用户状态 Reducer
UserState userReducer(UserState state, dynamic action) {
  if (action is UpdateUserAction) {
    return UserState(
      name: action.name,
      email: action.email,
      isProfileComplete: action.name.isNotEmpty && action.email.isNotEmpty,
    );
  }
  return state;
}

/// 主题状态 Reducer
ThemeState themeReducer(ThemeState state, dynamic action) {
  if (action is ToggleThemeAction) {
    return ThemeState(
      isDarkMode: !state.isDarkMode,
      themeName: !state.isDarkMode ? 'Dark' : 'Light',
    );
  } else if (action is SetThemeAction) {
    return ThemeState(
      isDarkMode: action.themeName.toLowerCase() == 'dark',
      themeName: action.themeName,
    );
  }
  return state;
}

/// 组合所有 Reducers
AppState appReducer(AppState state, dynamic action) {
  return AppState(
    auth: authReducer(state.auth, action),
    counter: counterReducer(state.counter, action),
    user: userReducer(state.user, action),
    theme: themeReducer(state.theme, action),
  );
}
