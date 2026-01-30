import 'package:flutter/material.dart';
import 'package:get/get.dart';
/// 创建自定义动画类
///
class MyCustomTransition extends CustomTransition {
  @override
  Widget buildTransition(BuildContext context, Curve? curve, Alignment? alignment, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 1),  // 从底部进来
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}
