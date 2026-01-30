import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_manager/get_x_example/permanent_controller_example/share_user_controller.dart';

/// 姓名编辑页面
class PermanentEditNamePage extends StatelessWidget {
  PermanentEditNamePage({super.key});

  final userController = Get.find<ShareUserController>();
  final TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    editingController.text = userController.username.value;

    return Scaffold(
      appBar: AppBar(title: const Text('编辑用户名')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: editingController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                userController.username.value = editingController.text;
                Get.back();
              },
              child: const Text('确定'),
            ),
          ],
        ),
      ),
    );
  }
}
