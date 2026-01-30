import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'redux/app_state.dart';
import 'redux/reducers.dart';
import 'pages/thunk_example_page.dart';

/// 创建 Redux Store
final store = Store<AppState>(
  appReducer,
  initialState: AppState.initial(),
  middleware: [thunkMiddleware],
);

/// 主应用
class ThunkExampleApp extends StatelessWidget {
  const ThunkExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Thunk Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ThunkExamplePage(),
      ),
    );
  }
}
