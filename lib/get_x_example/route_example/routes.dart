import 'package:get/get.dart';
import 'package:state_manager/get_x_example/route_example/get_x_route_detail.dart';
import 'package:state_manager/get_x_example/route_example/get_x_route_example.dart';

import 'my_custom_transition.dart';

class GetXAppRoutes {
  static final routes = [
    GetPage(name: '/', page: () => GetXRouteExample()),
    GetPage(
      name: '/detail/:id',
      page: () => GetXRouteDetail(),
      // 如果需要动画
      transition: Transition.rightToLeftWithFade, // 动画类型
      transitionDuration: Duration(milliseconds: 400), // 动画时间
      
      // 自定义动画
      //customTransition: MyCustomTransition(),
      //transitionDuration: Duration(milliseconds: 500),
    ),
  ];
}
