// @ignore_hardcode

import 'package:flutter/material.dart';
import 'package:tory_base/widgets/route_page_item.dart';

import 'home/banban_main.dart';
import 'marquee/my_marquee_page.dart';
import 'profile_v1/improve_profile.dart';
import 'profile_v2/gender_piker.dart';
import 'utils/utils.dart';
import 'welcome/welcome_test_page.dart';

class BanBanNaviListPage extends StatelessWidget {
  const BanBanNaviListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Util.width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("伴伴demo导航"),
      ),
      body: ListView(
        children: [
          RoutePageItem(
            title: "伴伴Home",
            builder: (context) => const BanBanMainPage(),
          )
          ,RoutePageItem(
            title: "伴伴完善资料v1",
            builder: (context) => const ImproveProfilePage(),
          ),RoutePageItem(
            title: "伴伴完善资料v2",
            builder: (context) => const GenderPickerPage(),
          ),
          RoutePageItem(
            title: "动效测试",
            builder: (context) => const MyMarqueeTest(),
          ),
          RoutePageItem(
            title: "入场测试",
            builder: (context) => const WelcomeTestPage(),
          ),
        ],
      ),
    );
  }
}
