import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_manager/get_x_example/worker_example/auth_controller.dart';

class GetXWelcomePage extends StatefulWidget {
  const GetXWelcomePage({super.key});

  @override
  _GetXWelcomePageState createState() => _GetXWelcomePageState();
}

class _GetXWelcomePageState extends State<GetXWelcomePage> {
  int _countdown = 10;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          timer.cancel();
          // 倒计时结束，返回登录页面并退出登录
          Get.find<AuthController>().logout();
          Get.back();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final username = Get.find<AuthController>().username.value;
    return Scaffold(
      appBar: AppBar(
        title: Text('欢迎页面'),
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            _timer.cancel();
            Get.find<AuthController>().logout();
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 欢迎图标
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade100,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.blue.shade600,
                ),
              ),
              SizedBox(height: 32),
              
              // 欢迎文本
              Text(
                '欢迎回来',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 12),
              Text(
                username,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 40),
              
              // 倒计时
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.blue.shade100,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer,
                      size: 20,
                      color: Colors.blue.shade600,
                    ),
                    SizedBox(width: 12),
                    Text(
                      '$_countdown 秒后返回登录页面',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60),
              
              // 提示信息
              Text(
                '点击返回按钮可立即返回',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
