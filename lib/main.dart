import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    hide ChangeNotifierProvider;
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:state_manager/bloc_example/base_example/blc_base_example.dart';
import 'package:state_manager/bloc_example/consumer_example/consumer_example.dart';
import 'package:state_manager/get_x_example/base_example/get_x_base_example.dart';
import 'package:state_manager/get_x_example/controer_id_exampe/get_x_controller_id_example.dart';
import 'package:state_manager/get_x_example/get_ui_example/get_ui_example.dart';
import 'package:state_manager/get_x_example/permanent_controller_example/permanent_edit_name_page.dart';
import 'package:state_manager/get_x_example/permanent_controller_example/permanent_profile_page.dart';
import 'package:state_manager/get_x_example/permanent_controller_example/share_user_controller.dart';
import 'package:state_manager/get_x_example/route_example/routes.dart';
import 'package:state_manager/get_x_example/worker_example/get_x_worker_example.dart';
import 'package:state_manager/inherited_manager_example/inherited_model_example/counter_father.dart';
import 'package:state_manager/inherited_manager_example/inherited_notifier_example/app_state_provider.dart';
import 'package:state_manager/inherited_manager_example/inherited_notifier_example/inherited_notifier_test.dart';
import 'package:state_manager/inherited_manager_example/inherited_notifier_example/new_app_state.dart';
import 'package:state_manager/inherited_manager_example/inherited_widget_example/counter_root.dart';
import 'package:state_manager/provider_exampe/change_notifier_exampe/change_notifier_app.dart';
import 'package:state_manager/provider_exampe/change_notifier_exampe/provider_counter_model.dart';
import 'package:state_manager/provider_exampe/provider_listenable_example/listenable_provider_example.dart';
import 'package:state_manager/provider_exampe/provider_proxy_example/proxy_provider_example.dart';
import 'package:state_manager/provider_exampe/provider_proxy_variants_example/change_notifier_proxy_provider_example.dart';
import 'package:state_manager/provider_exampe/provider_type1_example/provider_readonly_example.dart';
import 'package:state_manager/provider_exampe/provider_type2_example/provider_feature_example.dart';
import 'package:state_manager/provider_exampe/provider_type3_example/provider_stream_example.dart';
import 'package:state_manager/provider_exampe/provider_type4_example/provider_multi_example.dart';
import 'package:state_manager/provider_exampe/provider_value_example/provider_value_example.dart';
import 'package:state_manager/provider_exampe/provider_valuelistenable_example/value_listenable_provider_example.dart';
import 'package:state_manager/provider_exampe/widget_local_provider/local_provider_widget.dart';
import 'package:state_manager/redux_example/base_example/redux_base_example.dart';
import 'package:state_manager/redux_example/midware_redux_example/midware_example_app.dart';
import 'package:state_manager/riverpod_example/auto_dispose_example/riverpod_auto_dispose_example_app.dart';
import 'package:state_manager/riverpod_example/auto_dispose_example/form_screen.dart';
import 'package:state_manager/riverpod_example/base_example/river_counter_example.dart';
import 'package:state_manager/riverpod_example/family_example/riverpod_family_example_app.dart';
import 'package:state_manager/riverpod_example/future_example/river_future_example_app.dart';
import 'package:state_manager/riverpod_example/notifier_example/river_notifier_provider_example_app.dart';
import 'package:state_manager/riverpod_example/stream_example/river_stream_example_app.dart';

import 'bloc_example/multi_repository_example/repository_example_app.dart';
import 'inherited_manager_example/Inherited_widget_wrap_example/app_state_test.dart';
import 'inherited_manager_example/Inherited_widget_wrap_example/app_state_widget.dart';
import 'mobx_example/base_example/mx_counter_example.dart';

void main() {
  // 01. inherited_manager_example/
  //runApp(const MaterialApp(home: CounterRoot()));
  //runApp(const MaterialApp(home: CounterFather()));
  //runApp(AppStateWidget(child: AppStateTest()));

  //final appState = NewAppState();
  //runApp(AppStateProvider(notifier: appState, child: const InheritedNotifierTest()));

  // 02. provider_exampe:

  //// 02.1 provider_exampe/change_notifier_exampe/
  /*runApp(
    ChangeNotifierProvider(
      create: (_) => ProviderCounterModel(),
      child: ChangeNotifierApp(),
    ),
  );*/
  //// 02.2 provider_exampe/provider_type1_example/
  //runApp(const MaterialApp(home: ProviderReadOnlyExample(),));
  //// 02.3 provider_exampe/provider_type2_example/
  /*runApp(
    const MaterialApp(home: ProviderFeatureExample()),
  );*/
  //// 02.4 provider_exampe/provider_type3_example/
  /*runApp(
    StreamProvider<int>(
      create: (_) => countdownStream(),
      initialData: 10,
      child: ProviderStreamExample(),
    ),
  );*/
  //// 02.5 provider_exampe/provider_type4_example/
  /*runApp(
    const MaterialApp(home: ProviderType4App()),
  );*/
  //// 02.6 provider_exampe/provider_value_example/
  //runApp(const MaterialApp(home: LocalProviderWidget()));
  //// 02.7 provider_exampe/widget_local_provider/
  //runApp(ProviderValueApp());
  //// 02.8 lib/provider_exampe/provider_valuelistenable_example
  //runApp(MaterialApp(home: ValueListenableProviderExample(),));
  //// 02.9 lib/provider_exampe/provider_listenable_example
  //runApp(MaterialApp(home: ListenableProviderExample(),));
  //// 02.10 lib/provider_exampe/provider_proxy_example
  //runApp(MaterialApp(home: ProxyProviderExample(),));
  //// 02.11 lib/provider_exampe/provider_proxy_variants_example
  //runApp(MaterialApp(home: ChangeNotifierProxyProviderExample(),));

  // 03. get_x_example:

  /// 03.1 get_x_example/base_example
  ///runApp(GetMaterialApp(home: GetXBaseExample()));

  /// 03.2 get_x_example/controer_id_exampe
  /*runApp(GetMaterialApp(
    home: GetXControllerIdExample(),
  ));*/

  /// 03.3 get_x_example/worker_example
  //runApp(GetMaterialApp(home: GetXWorkerExample()));

  /// 03.4 get_x_example/route_example
  /*runApp(GetMaterialApp(
    initialRoute: '/',
    getPages: GetXAppRoutes.routes,
  ));*/

  /// 03.5 get_x_example/get_ui_example
  /*runApp(GetMaterialApp(
    home: GetUiExample(),
  ));*/

  /// 03.6 get_x_example/permanent_controller_example
  /*runApp(
    GetMaterialApp(
      initialRoute: '/profile',
      getPages: [
        GetPage(name: '/profile', page: () => PermanentProfilePage()),
        GetPage(
          name: '/edit',
          page: () => PermanentEditNamePage(),
          transition: Transition.downToUp,
          transitionDuration: Duration(milliseconds: 500),
        ),
      ],
      initialBinding: BindingsBuilder(() {
        Get.put(ShareUserController(), permanent: true); // 全局共享
      }),
    ),
  );*/

  // 04. bloc_example:

  // 04.1 bloc_example/base_example
  //runApp(BlcBaseExampleApp());
  // 04.2 bloc_example/consumer_example
  //runApp(const MaterialApp(home: BlConsumerExample()));
  // 04.3 bloc_example/multi_repository_example
  //runApp(const MaterialApp(home: RepositoryExampleApp(),));

  // 05. mobx_example:
  // 05.1 mobx_example/base_example
  //runApp(MaterialApp(home: MxCounterExample(),));

  // 06. riverpod_example:
  // 06.1 riverpod_example/base_example
  //runApp(const ProviderScope(child: RiverCounterApp(),));
  // 06.2 lib/riverpod_example/auto_dispose_example
  //runApp(const ProviderScope(child:RiverpodAutoDisposeExampleApp()));
  // 06.3 lib/riverpod_example/family_example
  //runApp(const ProviderScope(child: RiverpodFamilyExampleApp()));
  // 06.4 lib/riverpod_example/future_example
  //runApp(const RiverFutureExampleApp());
  // 06.5 lib/riverpod_example/notifier_example
  //runApp(const RiverNotifierProviderExampleApp());
  // 06.6 lib/riverpod_example/stream_example
  runApp(const RiverStreamExampleApp());

  /// 07. redux_example:
  // 07.1 redux_example/base_example
   /*final store = Store<ReduxAppState>(
    reduxCounterReducer,
    initialState: ReduxAppState(counter: 0),
  );
  runApp(ReduxExampleApp(store: store));*/

  // 07.2 redux_example/midware_redux_example
 // runApp(MidwareExampleApp(midwareStore));
}
