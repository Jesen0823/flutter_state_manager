import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// StreamProvider<T>：处理实时数据流（Stream），如 WebSocket、倒计时
// 适用于需要持续响应数据变化的场景。


// Stream.periodic() 构造函数
// 这是创建周期性数据流的方法，它有两个主要参数：
// 第一个参数 Duration(seconds: 1)：指定了数据发射的时间间隔为 1 秒
// 第二个参数是一个回调函数 (x) => 10 - x：
// x 是一个计数器，从 0 开始，每次发射数据时自动加 1
// 函数返回值 10 - x 就是每次发射的具体数值
// .take(11) 方法
// 这是一个流转换操作符，用于限制流发射的数据数量：
// 这里指定为 11，表示这个流只会发射前 11 个数据
// 当发射完 11 个数据后，流会自动关闭
Stream<int> countdownStream() {
  return Stream.periodic(Duration(seconds: 1), (x) => 10 - x).take(11);
}

class ProviderStreamExample extends StatelessWidget {
  const ProviderStreamExample({super.key});

  @override
  Widget build(BuildContext context) {
    final count = Provider.of<int>(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('StreamProvider 案例'),),
        body: Center(
          child: Text('倒计时：$count',style: TextStyle(fontSize: 30),),
        ),
      ),
    );
  }
}
