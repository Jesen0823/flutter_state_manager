import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:state_manager/redux_example/midware_redux_example/pages/midware_page.dart';
import 'package:state_manager/redux_example/midware_redux_example/redux/middleware.dart';
import 'package:state_manager/redux_example/midware_redux_example/redux/mw_app_state.dart';
import 'package:state_manager/redux_example/midware_redux_example/redux/mw_reduces.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// 创建 Redux Store 的实例。
/// [reducer] 参数指定状态应如何响应已分发的动作而发生改变。
/// 可选的 [initialState] 参数定义了 Store 首次创建时的状态。
/// 可选的 [middleware] 参数接收一个 [Middleware] 函数或 [MiddlewareClass] 的列表。
final midwareStore = Store<MWAppState>(
  appReducer,
  initialState: MWAppState.initial(),
  middleware: [
    createLogger("Mid_Example"),
    authMiddleware,
    likeAsyncMiddleware,
    snackMiddlleware,
  ],
);

class MidwareExampleApp extends StatelessWidget {
  const MidwareExampleApp(Store<MWAppState> midwareStore, {super.key});

  @override
  Widget build(BuildContext context) {
    /// 为该 Widget 的所有子 Widget 提供 Redux [Store]。
    /// 该 Widget 通常应作为应用中的根 Widget。
    /// 可使用 [StoreConnector] 或 [StoreBuilder] 连接到此 Widget 提供的 Store。
    return StoreProvider<MWAppState>(
      store: midwareStore,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Redux Middleware Example',
        home: MidwarePage(),
      ),
    );
  }
}
