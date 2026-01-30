
/// Action 定义 - 模块化动作结构
/// 
/// 此文件定义了应用中所有的动作类型，按功能模块分类：
/// 1. 认证相关 Actions - 处理登录、登出
/// 2. 计数器相关 Actions - 处理计数操作
/// 3. 用户相关 Actions - 处理用户信息更新
/// 
/// 核心概念：
/// - Action: 描述状态变更的事件对象
/// - 动作类型: 不同类型的动作对应不同的状态变更
/// - 载荷 (Payload): 动作可以携带数据，如 UpdateUserNameAction 中的 name
/// 
/// 使用场景：
/// - 当需要触发状态变更时，dispatch 对应的动作
/// - 动作是连接用户交互和状态更新的桥梁
/// - 模块化的动作定义便于管理和维护

/// 认证相关 Actions
class LoginAction {}

class LogoutAction {}

/// 计数器相关 Actions
class IncrementAction {}

class DecrementAction {}

class ResetAction {}

/// 用户相关 Actions
class UpdateUserNameAction {
  final String name;

  UpdateUserNameAction(this.name);
}
