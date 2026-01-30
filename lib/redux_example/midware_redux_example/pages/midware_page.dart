import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:state_manager/redux_example/midware_redux_example/redux/models/view_model.dart';
import 'package:state_manager/redux_example/midware_redux_example/redux/mw_actions.dart';
import 'package:state_manager/redux_example/midware_redux_example/redux/mw_app_state.dart';

class MidwarePage extends StatelessWidget {
  const MidwarePage({super.key});

  @override
  Widget build(BuildContext context) {
    /// 基于 [Store] 的状态构建一个 widget。
    /// 在 [builder] 运行之前，[converter] 会将 store 转换为更具体的 `ViewModel`，该 `ViewModel` 专为正在构建的 Widget 定制。
    /// 每次 store 发生变化时，Widget 都会重新构建。作为性能优化，仅当 [ViewModel] 发生变化时，才可以重新构建 Widget。
    /// 为了使此功能正常工作，你必须为 [ViewModel] 实现 [==] 和 [hashCode]，并在创建 StoreConnector 时将 [distinct] 选项设置为 true。
    return StoreConnector<MWAppState, ViewModel>(
      builder: (context, vm) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(vm),
        );
      },
      converter: (store) => ViewModel(
        loggedIn: store.state.loggedIn,
        isLiking: store.state.isLiking,
        likeCount: store.state.likeCount,
        onLogin: () => store.dispatch(ActionLogin()),
        onLike: () => store.dispatch(ActionLikeRequest()),
        onLogout: () => store.dispatch(ActionLogout()),
      ),
    );
  }

  // Build App Bar
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Redux Middleware Example'),
      backgroundColor: Colors.blue,
    );
  }

  // Build Body
  Widget _buildBody(ViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLoginStatus(viewModel),
            const SizedBox(height: 32),
            _buildLikeSection(viewModel),
            const SizedBox(height: 32),
            _buildAuthButtons(viewModel),
          ],
        ),
      ),
    );
  }

  // Build Login Status
  Widget _buildLoginStatus(ViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: viewModel.loggedIn ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: viewModel.loggedIn ? Colors.green : Colors.red,
        ),
      ),
      child: Text(
        viewModel.loggedIn ? '已登录' : '未登录',
        style: TextStyle(
          fontSize: 18,
          color: viewModel.loggedIn ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Build Like Section
  Widget _buildLikeSection(ViewModel viewModel) {
    return Column(
      children: [
        Text(
          '点赞数：${viewModel.likeCount}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        viewModel.isLiking
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: viewModel.onLike,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  '点赞',
                  style: TextStyle(fontSize: 16),
                ),
              ),
      ],
    );
  }

  // Build Auth Buttons
  Widget _buildAuthButtons(ViewModel viewModel) {
    return viewModel.loggedIn
        ? ElevatedButton(
            onPressed: viewModel.onLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 12,
              ),
            ),
            child: const Text(
              '退出登录',
              style: TextStyle(fontSize: 16),
            ),
          )
        : ElevatedButton(
            onPressed: viewModel.onLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 12,
              ),
            ),
            child: const Text(
              '登录',
              style: TextStyle(fontSize: 16),
            ),
          );
  }
}
