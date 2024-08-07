// @ignore_hardcode
import 'dart:async';
import 'dart:ui';

import 'package:alloo_demo/alloo_demo.dart';
import 'package:banban_demo/banban_navi_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tory_app/layout/basic_layout_page.dart';
import 'package:tory_app/basic_demo/basic_widgets_page.dart';
import 'package:tory_app/basic_demo/image_icon_route.dart';
import 'package:tory_app/basic_demo/new_route_demo.dart';
import 'package:tory_app/third/third_packege_demo.dart';
import 'package:tory_base/tory_base.dart';

import 'animate/animate_main.dart';
import 'basic_demo/bubble_tip_demo.dart';
import 'basic_demo/function_widgets_demo.dart';
import 'basic_demo/sliver/sliver_navi_page.dart';
import 'dev/shared_preferences_list.dart';
import 'generated/l10n.dart';
import 'third/location_demo_page.dart';

void main() {
  var onError = FlutterError.onError; //先将 onerror 保存起来
  FlutterError.onError = ((details) {
    onError?.call(details); //调用默认的onError
    reportErrorAndLog(details);
  });

  runZoned(() {
    runApp(const MyApp());
  },
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateTitle: (context) => S.of(context).app_name,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        platform: TargetPlatform.iOS,
        useMaterial3: true,
      ),
      builder: (context, child) {
        debugPrint("");
        return Directionality(
            textDirection: TextDirection.ltr, child: child ?? Container(),
        );
      },
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        "/new_page": (context) => NewRoutePage(
              tipText: ModalRoute.of(context)?.settings.arguments as String?,
            )
      },
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Insert this line
      supportedLocales: S.delegate.supportedLocales,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with LifeStateOwnerMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListTileTheme.merge(
        child: _buildColumn(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildColumn(BuildContext context) {
    return ListView(
      children: <Widget>[
        RoutePageItem(
          title: "路由测试",
          icon: Icons.navigation,
          subTitle: '路由测试,路由测试,路由测试,路由测试,路由测试',
          onPress: () async {
            final result = await Navigator.of(context)
                .pushNamed("/new_page", arguments: "hi from Route Named");
            print("result: $result");
          },
        ),
        RoutePageItem(
          title: "图片测试",
          builder: (context) => const ImageAndIconRoute(),
        ),
        RoutePageItem(
          title: "气泡测试",
          builder: (context) => const BubbleTipDemo(),
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
          title: "动画组件测试",
          builder: (context) => const AnimateMainPage(),
        ),
        RoutePageItem(
          title: "滚动组件测试",
          builder: (context) => const SliverNaviPage(),
        ),
        RoutePageItem(
          title: "伴伴导航",
          builder: (context) => const BanBanNaviListPage(),
        ),
        RoutePageItem(
          title: "SharedPreferencesListPage",
          builder: (context) => const SharedPreferencesListPage(),
        ),
        RoutePageItem(
          title: "三方库测试",
          builder: (context) => const ThirdPackageDemoPage(),
        ),
        RoutePageItem(
          title: "Alloo相关测试",
          builder: (context) => const AllooMainPage(),
        ),
      ],
    );
  }
}
