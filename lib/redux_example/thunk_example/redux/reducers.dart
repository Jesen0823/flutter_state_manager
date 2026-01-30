import 'app_state.dart';
import 'actions.dart';

/// 认证状态 Reducer
AuthState authReducer(AuthState state, dynamic action) {
  if (action is LoginSuccessAction) {
    return AuthState(
      isLoggedIn: true,
      token: action.token,
      isLoading: false,
      error: null,
    );
  } else if (action is LoginFailureAction) {
    return AuthState(
      isLoggedIn: false,
      token: '',
      isLoading: false,
      error: action.error,
    );
  } else if (action is LogoutAction) {
    return AuthState.initial();
  } else if (action is SetAuthLoadingAction) {
    return AuthState(
      isLoggedIn: state.isLoggedIn,
      token: state.token,
      isLoading: action.isLoading,
      error: state.error,
    );
  }
  return state;
}

/// 用户状态 Reducer
UserState userReducer(UserState state, dynamic action) {
  if (action is FetchUserSuccessAction) {
    return UserState(
      name: action.name,
      email: action.email,
      isLoading: false,
      error: null,
    );
  } else if (action is FetchUserFailureAction) {
    return UserState(
      name: state.name,
      email: state.email,
      isLoading: false,
      error: action.error,
    );
  } else if (action is SetUserLoadingAction) {
    return UserState(
      name: state.name,
      email: state.email,
      isLoading: action.isLoading,
      error: state.error,
    );
  }
  return state;
}

/// 帖子状态 Reducer
PostsState postsReducer(PostsState state, dynamic action) {
  if (action is FetchPostsSuccessAction) {
    return PostsState(
      posts: action.posts,
      isLoading: false,
      error: null,
    );
  } else if (action is FetchPostsFailureAction) {
    return PostsState(
      posts: state.posts,
      isLoading: false,
      error: action.error,
    );
  } else if (action is SetPostsLoadingAction) {
    return PostsState(
      posts: state.posts,
      isLoading: action.isLoading,
      error: state.error,
    );
  }
  return state;
}

/// 计数器状态 Reducer
CounterState counterReducer(CounterState state, dynamic action) {
  if (action is IncrementAction) {
    return CounterState(
      count: state.count + 1,
      isLoading: false,
    );
  } else if (action is DecrementAction) {
    return CounterState(
      count: state.count - 1,
      isLoading: false,
    );
  } else if (action is ResetAction) {
    return CounterState(
      count: 0,
      isLoading: false,
    );
  } else if (action is SetCounterLoadingAction) {
    return CounterState(
      count: state.count,
      isLoading: action.isLoading,
    );
  }
  return state;
}

/// 组合所有 Reducers
AppState appReducer(AppState state, dynamic action) {
  return AppState(
    auth: authReducer(state.auth, action),
    user: userReducer(state.user, action),
    posts: postsReducer(state.posts, action),
    counter: counterReducer(state.counter, action),
  );
}
