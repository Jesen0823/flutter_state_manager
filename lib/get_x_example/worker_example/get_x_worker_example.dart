import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_manager/get_x_example/worker_example/auth_controller.dart';
import 'package:state_manager/get_x_example/worker_example/components/login_form.dart';
import 'package:state_manager/get_x_example/worker_example/components/worker_explanation.dart';

class GetXWorkerExample extends StatelessWidget {
  GetXWorkerExample({super.key});

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GetX Worker 案例"),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 标题和说明
              Center(
                child: Column(
                  children: [
                    Text(
                      "用户登录",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "展示 GetX Worker 的各种能力",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              // 登录表单
              LoginForm(authController: authController),

              SizedBox(height: 40),

              // Worker 类型说明
              WorkerExplanation(),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
