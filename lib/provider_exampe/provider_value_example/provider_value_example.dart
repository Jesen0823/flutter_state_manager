import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///  ChangeNotifierProvider.value的用法，区别于 ChangeNotifierProvider.create

class ItemModel extends ChangeNotifier {
  final String title;

  ItemModel(this.title);
}

class ItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ItemModel>(context);
    return ListTile(title: Text(model.title));
  }
}

class ProviderValueApp extends StatelessWidget {
  const ProviderValueApp({super.key});

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      home: ProviderValueExample(),
    );;
  }
}


class ProviderValueExample extends StatelessWidget {
  ProviderValueExample({super.key});

  final items = List.generate(100, (index) => ItemModel('Item $index'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('provider.value案例'),),
      body: Center(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, index) {
            return ChangeNotifierProvider.value(
              value: items[index], // 已有模型，复用
              child: ItemWidget(),
            );
          },
        ),
      ),
    );
  }
}
