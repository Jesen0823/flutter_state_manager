import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetXRouteExample extends StatelessWidget {
  const GetXRouteExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GetX路由案例'),),
      body: Center(
        child: ElevatedButton(
          onPressed: ()=>Get.toNamed('/detail/123?title=我是参数'),
          child: const Text('跳转详情带参数'),
        ),
      ),
    );
  }
}
