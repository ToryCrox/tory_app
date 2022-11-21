import 'dart:convert';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AsyncDemoPage extends StatefulWidget {
  const AsyncDemoPage({Key? key}) : super(key: key);

  @override
  State<AsyncDemoPage> createState() => _AsyncDemoPageState();
}

class _AsyncDemoPageState extends State<AsyncDemoPage> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("异步测试"),
      ),
      body: SingleChildScrollView(
        child: Column(),
      ),
    );
  }


  loadData() async {
    // 通过spawn新建一个isolate，并绑定静态方法
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(dataLoader, receivePort.sendPort);

    // 获取新isolate的监听port
    SendPort sendPort = await receivePort.first;
    // 调用sendReceive自定义方法
    List dataList = await sendReceive(sendPort, 'https://jsonplaceholder.typicode.com/posts');
    print('dataList $dataList');

  }

// isolate的绑定方法
  static dataLoader(SendPort sendPort) async{
    // 创建监听port，并将sendPort传给外界用来调用
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    // 监听外界调用
    await for (var msg in receivePort) {
      String requestURL =msg[0];
      SendPort callbackPort =msg[1];

      final dio = Dio();
      final response = await dio.get(requestURL, options: Options(responseType: ResponseType.plain));
      List dataList = json.decode(response.data);
      // 回调返回值给调用者
      callbackPort.send(dataList);
    }
  }

// 创建自己的监听port，并且向新isolate发送消息
  Future sendReceive(SendPort sendPort, String url) {
    ReceivePort receivePort = ReceivePort();
    sendPort.send([url, receivePort.sendPort]);
    // 接收到返回值，返回给调用者
    return receivePort.first;
  }
}
