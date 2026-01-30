import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_manager/get_x_example/permanent_controller_example/share_user_controller.dart';

/// 个人信息页面
class PermanentProfilePage extends StatelessWidget {
  PermanentProfilePage({super.key});

  final userController = Get.find<ShareUserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('用户信息页面')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => Text(
                '用户名：${userController.username.value}',
                style: TextStyle(fontSize: 30, color: Colors.green),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/edit');
              },
              child: const Text('编辑用户名 >'),
            ),
          ],
        ),
      ),
    );
  }
}
