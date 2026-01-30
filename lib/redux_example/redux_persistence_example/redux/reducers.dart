
import 'app_state.dart';
import 'actions.dart';

/// 认证状态 Reducer
AuthState authReducer(AuthState state, dynamic action) {
  if (action is LoginAction) {
    return AuthState(true);
  } else if (action is LogoutAction) {
    return AuthState(false);
  } else if (action is ClearStorageAction) {
    return AuthState.initial();
  }
  return state;
}

/// 计数器状态 Reducer
CounterState counterReducer(CounterState state, dynamic action) {
  if (action is IncrementAction) {
    return CounterState(state.count + 1);
  } else if (action is DecrementAction) {
    return CounterState(state.count - 1);
  } else if (action is ResetAction) {
    return CounterState(0);
  } else if (action is ClearStorageAction) {
    return CounterState.initial();
  }
  return state;
}

/// 用户状态 Reducer
UserState userReducer(UserState state, dynamic action) {
  if (action is UpdateUserNameAction) {
    return UserState(action.name);
  } else if (action is ClearStorageAction) {
    return UserState.initial();
  }
  return state;
}

/// 组合所有 Reducers
AppState appReducer(AppState state, dynamic action) {
  return AppState(
    auth: authReducer(state.auth, action),
    counter: counterReducer(state.counter, action),
    user: userReducer(state.user, action),
  );
}
