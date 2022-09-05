import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tory_app/basic_demo/basic_layout_page.dart';
import 'package:tory_app/basic_demo/basic_widgets_page.dart';
import 'package:tory_app/basic_demo/image_icon_route.dart';
import 'package:tory_app/basic_demo/new_route_demo.dart';
import 'package:tory_app/basic_demo/state_demo.dart';

import 'banban/banban_main.dart';
import 'basic_demo/fuction_widgets_demo.dart';

void main() {
  var onError = FlutterError.onError; //先将 onerror 保存起来
  FlutterError.onError = ((details) {
    onError?.call(details); //调用默认的onError
    reportErrorAndLog(details);
  });
  runZoned(() => runApp(const MyApp()),
      zoneSpecification: ZoneSpecification(print: (self, parent, zone, line) {
        collectLog(line);
        parent.print(zone, "Interceptor: $line");
      }, handleUncaughtError: (Zone self, ZoneDelegate parent, Zone zone,
          Object error, StackTrace stackTrace) {
        //reportErrorAndLog(details);
        parent.print(zone, '${error.toString()} $stackTrace');
      }));
}

void collectLog(String line) {
  //收集日志
}

void reportErrorAndLog(FlutterErrorDetails details) {
  //上报错误和日志逻辑
  debugPrintStack(stackTrace: details.stack);
}

// FlutterErrorDetails makeDetails(Object obj, StackTrace stack){
//   // 构建错误信息
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        "/new_page": (context) => NewRoutePage(
              tipText: ModalRoute.of(context)?.settings.arguments as String?,
            )
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            RoutePageItem(
              title: "路由测试",
              onPress: () async {
                final result = await Navigator.of(context)
                    .pushNamed("/new_page", arguments: "hi from Route Named");
                // final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return const NewRoutePage(tipText: "from home");
                // }));
                print("result: $result");
              },
            ),
            RoutePageItem(
              title: "图片测试",
              builder: (context) => const ImageAndIconRoute(),
            ),
            RoutePageItem(
              title: "基础组件测试",
              builder: (context) => const BasicWidgetsPage(),
            ),
            RoutePageItem(
              title: "布局类测试",
              builder: (context) => const BasicLayoutPage(),
            ),
            RoutePageItem(
              title: "功能组件测试",
              builder: (context) => const FunctionWidgetsDemo(),
            ),
            RoutePageItem(
              title: "伴伴Home",
              builder: (context) => const BanBanMainPage(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Echo extends StatelessWidget {
  const Echo({
    Key? key,
    required this.text,
    this.backgroundColor = Colors.grey, //默认为灰色
  }) : super(key: key);

  final String text;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(2)),
            color: backgroundColor),
        //color: backgroundColor,
        child: Text(text),
      ),
    );
  }
}

class RoutePageItem extends StatelessWidget {
  final String title;
  final WidgetBuilder? builder;
  final VoidCallback? onPress;

  const RoutePageItem(
      {Key? key, required this.title, this.builder, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        if (onPress != null) {
          onPress?.call();
        } else if (builder != null) {
          Navigator.of(context).push(MaterialPageRoute(builder: builder!));
        }
      },
    );
  }
}
