
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'redux/app_state.dart';
import 'redux/reducers.dart';
import 'pages/combine_reducers_page.dart';

/// 创建 Redux Store
final store = Store<AppState>(
  appReducer,
  initialState: AppState.initial(),
);

/// 主应用
class CombineReducersExampleApp extends StatelessWidget {
  const CombineReducersExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Combine Reducers Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const CombineReducersPage(),
      ),
    );
  }
}
