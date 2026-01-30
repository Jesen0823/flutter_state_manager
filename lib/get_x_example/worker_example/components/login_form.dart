
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_manager/get_x_example/worker_example/auth_controller.dart';

class LoginForm extends StatelessWidget {
  final AuthController authController;

  const LoginForm({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 用户名输入
        _buildUsernameField(),
        SizedBox(height: 24),
        
        // 密码输入
        _buildPasswordField(),
        SizedBox(height: 32),
        
        // 登录按钮
        _buildLoginButton(),
        SizedBox(height: 20),
        
        // 登录尝试次数
        _buildLoginAttempts(),
      ],
    );
  }

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "用户名",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: "请输入用户名（至少3个字符）",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (value) => authController.username.value = value,
        ),
        SizedBox(height: 8),
        Obx(() {
          if (authController.isSearching.value) {
            return Row(
              children: [
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.blue,
                ),
                SizedBox(width: 8),
                Text(
                  '检查用户名可用性...',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
              ],
            );
          } else if (authController.searchResult.value.isNotEmpty) {
            return Text(
              authController.searchResult.value,
              style: TextStyle(
                fontSize: 12,
                color: Colors.green,
              ),
            );
          } else {
            return Container();
          }
        }),
        Obx(() {
          if (authController.username.value.isNotEmpty && 
              !authController.isUsernameValid.value) {
            return Text(
              '用户名至少需要3个字符',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
            );
          } else {
            return Container();
          }
        }),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "密码",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: "请输入密码（至少6个字符）",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          obscureText: true,
          onChanged: (value) => authController.password.value = value,
        ),
        SizedBox(height: 8),
        Obx(() {
          if (authController.password.value.isNotEmpty && 
              !authController.isPasswordValid.value) {
            return Text(
              '密码至少需要6个字符',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
            );
          } else {
            return Container();
          }
        }),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Obx(() {
      return ElevatedButton(
        onPressed: authController.canLogin.value ? authController.login : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: authController.canLogin.value 
              ? Colors.blue 
              : Colors.grey.shade300,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
        child: Text(
          '登录',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    });
  }

  Widget _buildLoginAttempts() {
    return Obx(() {
      if (authController.loginAttempts.value > 0) {
        return Center(
          child: Text(
            '登录尝试次数：${authController.loginAttempts.value}',
            style: TextStyle(
              fontSize: 14,
              color: authController.loginAttempts.value > 3 
                  ? Colors.red 
                  : Colors.grey.shade600,
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
