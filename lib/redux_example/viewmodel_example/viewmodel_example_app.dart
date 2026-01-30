
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'redux/app_state.dart';
import 'redux/reducers.dart';
import 'pages/viewmodel_example_page.dart';

/// 创建 Redux Store
final store = Store<AppState>(
  appReducer,
  initialState: AppState.initial(),
);

/// 主应用
class ViewModelExampleApp extends StatelessWidget {
  const ViewModelExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'ViewModel Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ViewModelExamplePage(),
      ),
    );
  }
}
