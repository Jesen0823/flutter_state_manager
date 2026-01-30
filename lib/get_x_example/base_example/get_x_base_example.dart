import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_manager/get_x_example/base_example/counter_controller.dart';

class GetXBaseExample extends StatelessWidget {
  GetXBaseExample({super.key});

  final CounterController controller = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GetX Base Example')),
      body: Center(child: Obx(() => Text('Count: ${controller.count}'))),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: Icon(Icons.add),
      ),
    );
  }
}
