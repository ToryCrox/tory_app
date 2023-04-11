import 'package:flutter/material.dart';
import 'package:tory_base/tory_base.dart';

import '../animate/widget/alloo_tabs.dart';
import '../animate/widget/mtabs.dart';

class TabBarPage extends StatefulWidget {
  const TabBarPage({Key? key}) : super(key: key);

  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage>
    with TickerProviderStateMixin, SafeStateMixin {
  final List<_TabPageItem> _pageItems = [];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    initTabController();
    Future.delayed(const Duration(seconds: 2), () {
      _pageItems.addAll([
        _TabPageItem(title: 'Recommend', color: Colors.deepPurpleAccent),
        _TabPageItem(title: 'Nearby', color: Colors.tealAccent),
        _TabPageItem(title: 'Dating', color: Colors.amberAccent),
        _TabPageItem(title: 'Dating', color: Colors.amberAccent),
        _TabPageItem(title: 'Dating', color: Colors.amberAccent),
      ]);
      initTabController();
    });

  }

  void initTabController() {
    _tabController?.dispose();
    _tabController = TabController(length: _pageItems.length, vsync: this);
    _tabController?.addListener(() {
      logger.d("Tab Page Changed: ${_tabController?.index}");
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('TabBar测试'),
        ),
        body: Column(
          children: [
            _buildTabBar(),
            Expanded(child: _buildTabView()),
          ],
        ));
  }

  Widget _buildTabBar() {
    return AllooPrimaryTabBar(
      fadeEnd: true,
      tabs: _pageItems
          .map((e) => MTabMeta(
                title: e.title,
                hasDot: true,
                boxBuilder: (context, child, selected, animateFraction) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      child,
                      Opacity(opacity: animateFraction, child: _buildRedDot()),
                    ],
                  );
                },
              ))
          .toList(),
      controller: _tabController!,
      onSpaceDoubleTap: (){
        print('onSpaceDoubleTap....');
      },
    );
    return Container(
      height: 48,
      alignment: AlignmentDirectional.centerStart,
      child: MTabBar(
        tabHeight: 48,
        controller: _tabController,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        indicatorSize: TabBarIndicatorSize.label,
        labelPadding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 11),
        labelAlignment: AlignmentDirectional.bottomCenter,
        labelStyle: const TextStyle(
            fontSize: 22,
            color: Color(0xFF313131),
            fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            color: Color(0xFF949494),
            fontWeight: FontWeight.w500),
        isScrollable: true,
        // indicator: const MUnderlineTabIndicator(
        //   borderSide: BorderSide(width: 2.0, color: Colors.redAccent),
        //   wantWidth: 20
        // ),
        customTabIndicator: AllooIndicatorDecoration(),
        tabsMeta: _pageItems
            .map((e) => MTabMeta(
                  title: e.title,
                  hasDot: false,
                  boxBuilder: (context, child, selected, animateFraction) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [child, _buildRedDot()],
                    );
                  },
                ))
            .toList(),
      ),
    );
  }

  Widget _buildTabView() {
    return TabBarView(
      controller: _tabController,
      children: _pageItems
          .map(
            (e) => Container(
              color: e.color,
            ),
          )
          .toList(),
    );
  }

  Widget _buildRedDot() {
    return Container(
      width: 6,
      height: 6,
      decoration: const ShapeDecoration(
        shape: CircleBorder(),
        color: Color(0xFFFF4267),
      ),
    );
  }
}

class _TabPageItem {
  String title;
  Color? color;

  _TabPageItem({
    required this.title,
    required this.color,
  });
}
