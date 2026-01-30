import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetUiExample extends StatelessWidget {
  const GetUiExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GetX Snackbar/Dialog/BottomSheet 案例'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Get.snackbar(
                  '提示',
                  '这是一条消息提示',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: Duration(seconds: 4),
                  backgroundColor: Colors.blueGrey.shade700,
                  colorText: Colors.white,
                  icon: Icon(Icons.info, color: Colors.white),
                  mainButton: TextButton(
                    onPressed: () => Get.back(),
                    child: Text('关闭', style: TextStyle(color: Colors.white)),
                  ),
                );
              },
              child: Text('显示 Snackbar'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.defaultDialog(
                  title: '确认操作',
                  middleText: '确定要删除这条记录吗？',
                  textConfirm: '确认',
                  textCancel: '取消',
                  barrierDismissible: false,
                  onConfirm: () {
                    Get.back();
                    Get.snackbar('删除', '记录已删除', snackPosition: SnackPosition.BOTTOM);
                  },
                  onCancel: () => Get.back(),
                );
              },
              child: Text('显示 Dialog'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.bottomSheet(
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: Icon(Icons.photo),
                          title: Text('相册'),
                          onTap: () {
                            Get.back();
                            Get.snackbar('选择', '点击了相册', snackPosition: SnackPosition.BOTTOM);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.camera_alt),
                          title: Text('拍照'),
                          onTap: () {
                            Get.back();
                            Get.snackbar('选择', '点击了拍照', snackPosition: SnackPosition.BOTTOM);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.cancel),
                          title: Text('取消'),
                          onTap: () => Get.back(),
                        ),
                      ],
                    ),
                  ),
                  isDismissible: true,
                  enableDrag: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                );
              },
              child: Text('显示 BottomSheet'),
            ),
          ],
        ),
      ),
    );
  }
}
