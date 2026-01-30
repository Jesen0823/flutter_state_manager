
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'redux/app_state.dart';
import 'redux/reducers.dart';
import 'pages/nested_modules_page.dart';

/// 创建 Redux Store
final store = Store<AppState>(
  appReducer,
  initialState: AppState.initial(),
);

/// 主应用
class NestedModulesExampleApp extends StatelessWidget {
  const NestedModulesExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Nested Modules Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const NestedModulesPage(),
      ),
    );
  }
}
