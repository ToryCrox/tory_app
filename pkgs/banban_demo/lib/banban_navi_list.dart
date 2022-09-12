// @ignore_hardcode

import 'package:flutter/material.dart';
import 'package:tory_base/widgets/route_page_item.dart';

import 'home/banban_main.dart';
import 'profile_v1/improve_profile.dart';
import 'profile_v2/gender_piker.dart';

class BanBanNaviListPage extends StatelessWidget {
  const BanBanNaviListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
    );
  }
}
