import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetXRouteDetail extends StatelessWidget {
  const GetXRouteDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.parameters['id'];
    final title = Get.parameters['title'];

    return Scaffold(
      appBar: AppBar(title: const Text('详情页')),
      body: Center(child: Text('ID：$id, 标题：$title')),
    );
  }
}
