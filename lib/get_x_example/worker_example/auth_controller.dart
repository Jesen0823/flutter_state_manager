import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'get_x_welcome_page.dart';

class AuthController extends GetxController {
  // 状态变量
  var username = ''.obs;
  var password = ''.obs;
  var isLoggedIn = false.obs;
  var loginAttempts = 0.obs;
  
  var isUsernameValid = false.obs;
  var isPasswordValid = false.obs;
  var canLogin = false.obs;
  
  var isSearching = false.obs;
  var searchResult = ''.obs;
  
  var lastLoginAttempt = ''.obs;
  var countdown = 3.obs;
  var isCountingDown = false.obs;

  @override
  void onInit() {
    super.onInit();

    // 1. debounce - 防抖搜索，用户停止输入800ms后触发搜索逻辑
    debounce(username, (value) async {
      if (value.toString().isEmpty) return;
      isSearching.value = true;
      searchResult.value = '';
      print("开始搜索用户名：$value");

      // 模拟调用搜索API
      await Future.delayed(Duration(seconds: 1));
      searchResult.value = "用户名 '$value' 可用";
      isSearching.value = false;
    }, time: Duration(milliseconds: 800));

    // 2. ever - 监听登录状态变化，每次变化都触发
    ever(isLoggedIn, (status) {
      if (status == true) {
        Get.snackbar(
          "登录成功", 
          "欢迎你 ${username.value}",
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
        
        // 跳转到欢迎页面
        Get.to(GetXWelcomePage());
      } else {
        Get.snackbar(
          "退出登录", 
          "已成功退出",
          backgroundColor: Colors.blue.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.info, color: Colors.white),
        );
      }
    });

    // 3. everAll - 监听多个值的变化，任何一个变化都触发
    everAll([username, password], (_) {
      validateInputs();
    });

    // 4. 手动实现节流效果 - 限制登录尝试频率
    var lastLoginAttemptTime = 0;
    ever(loginAttempts, (value) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      if (value > 3 && currentTime - lastLoginAttemptTime > 10000) {
        lastLoginAttemptTime = currentTime;
        Get.snackbar(
          "登录失败", 
          "登录尝试次数过多，请稍后再试",
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
        );
      }
    });

    // 5. once - 只触发一次的Worker
    once(loginAttempts, (value) {
      if (value > 0) {
        Get.snackbar(
          "提示", 
          "请输入正确的用户名和密码",
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.warning, color: Colors.white),
        );
      }
    });

    // 6. interval - 每隔一段时间触发一次
    interval(lastLoginAttempt, (value) {
      if (value.isNotEmpty) {
        print("定期检查登录状态...");
        // 这里可以添加定期检查登录状态的逻辑
      }
    }, time: Duration(seconds: 30));
  }

  void validateInputs() {
    isUsernameValid.value = username.value.length >= 3;
    isPasswordValid.value = password.value.length >= 6;
    canLogin.value = isUsernameValid.value && isPasswordValid.value;
  }

  void login() {
    if (canLogin.value) {
      isLoggedIn.value = true;
      lastLoginAttempt.value = DateTime.now().toString();
    } else {
      loginAttempts.value++;
      Get.snackbar(
        "登录失败", 
        "用户名或密码无效",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    }
  }

  void logout() {
    isLoggedIn.value = false;
    username.value = '';
    password.value = '';
    loginAttempts.value = 0;
  }
}
