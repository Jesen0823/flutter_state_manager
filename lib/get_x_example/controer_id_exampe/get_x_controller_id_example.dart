import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyController extends GetxController {
  int countA = 0;
  int countB = 0;

  void incrementA() {
    countA++;
    update(['a']); // 指定 id = 'a' 的 GetBuilder 会刷新
  }

  void incrementB() {
    countB++;
    update(['b']); // 指定 id = 'b' 的 GetBuilder 会刷新
  }
}

class GetXControllerIdExample extends StatelessWidget {
   GetXControllerIdExample({super.key});

  final controller = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GetxController 指定id分别更新'),),
      body: Column(
        children: [
          GetBuilder<MyController>(
            id: 'a',
            builder: (c) => Text('A: ${c.countA}'),
          ),
          GetBuilder<MyController>(
            id: 'b',
            builder: (c) => Text('B: ${c.countB}'),
          ),
          SizedBox(height: 30),
          ElevatedButton(onPressed: controller.incrementA, child: Text("A +1")),
          ElevatedButton(onPressed: controller.incrementB, child: Text("B +1")),
        ],
      ),
    );
  }
}
