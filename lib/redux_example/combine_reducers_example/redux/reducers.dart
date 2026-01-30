/// Reducer 定义 - 组合 reducer 模式
///
/// 此文件定义了应用中所有的 reducer 函数，按功能模块分类：
/// 1. authReducer - 处理认证状态变更
/// 2. counterReducer - 处理计数器状态变更
/// 3. userReducer - 处理用户信息状态变更
/// 4. appReducer - 组合所有子 reducer
///
/// 核心概念：
/// - Reducer: 纯函数，接收旧状态和动作，返回新状态
/// - 组合 reducer: 将多个子 reducer 组合成一个根 reducer
/// - 不可变性: Reducer 不能修改旧状态，必须返回新状态
///
/// 组合模式说明：
/// - 每个子 reducer 只负责自己的状态模块
/// - appReducer 将所有子 reducer 的结果组合成新的全局状态
/// - 这种模式便于管理复杂的状态树，提高代码可维护性
///
/// 使用场景：
/// - 当应用状态较为复杂，需要按功能模块划分时
/// - 适合中大型应用的状态管理
/// - 便于团队协作和代码维护

import 'app_state.dart';
import 'actions.dart';

/// 认证状态 Reducer
///
/// 处理认证相关的状态变更，如登录、登出
AuthState authReducer(AuthState state, dynamic action) {
  if (action is LoginAction) {
    return AuthState(true);
  } else if (action is LogoutAction) {
    return AuthState(false);
  }
  return state;
}

/// 计数器状态 Reducer
///
/// 处理计数器相关的状态变更，如增加、减少、重置
CounterState counterReducer(CounterState state, dynamic action) {
  if (action is IncrementAction) {
    return CounterState(state.count + 1);
  } else if (action is DecrementAction) {
    return CounterState(state.count - 1);
  } else if (action is ResetAction) {
    return CounterState(0);
  }
  return state;
}

/// 用户状态 Reducer
///
/// 处理用户信息相关的状态变更，如更新用户名
UserState userReducer(UserState state, dynamic action) {
  if (action is UpdateUserNameAction) {
    return UserState(action.name);
  }
  return state;
}

/// 组合所有 Reducers
///
/// 核心 reducer 函数，组合所有子 reducer 的结果
/// 每个子 reducer 只处理自己的状态模块
/// 这种组合模式是 Redux 中管理复杂状态的最佳实践
AppState appReducer(AppState state, dynamic action) {
  return AppState(
    auth: authReducer(state.auth, action),
    counter: counterReducer(state.counter, action),
    user: userReducer(state.user, action),
  );
}
