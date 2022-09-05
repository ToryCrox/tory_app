import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';


// 路由测试
class NewRoutePage extends StatefulWidget {
  final String? tipText;

  const NewRoutePage({Key? key, this.tipText}) : super(key: key);

  @override
  State<NewRoutePage> createState() => _NewRoutePageState();
}

class _NewRoutePageState extends State<NewRoutePage> {
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments;

    final wordPair = WordPair.random();
    return Scaffold(
      appBar: AppBar(
        title: const Text("路由测试"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("tipText: ${widget.tipText ?? args}"),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 200,
                child: Text("随机字符串: ${wordPair.toString()}", textAlign: TextAlign.center,)),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, "这是返回值");
                },
                child: Text("退出"))
          ],
        ),
      ),
    );
  }
}
