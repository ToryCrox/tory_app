import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'home.dart';
import 'msg.dart';
// @ignore_hardcode

class BanBanMainPage extends StatefulWidget {
  const BanBanMainPage({Key? key}) : super(key: key);

  @override
  State<BanBanMainPage> createState() => _BanBanMainPageState();
}

class _BanBanMainPageState extends State<BanBanMainPage> {
  var _currentPageIndex = 0;

  final List<PageItem> _pageItemList = [
    PageItem(
      title: "首页",
      unselectedImgPath: "assets/images/tab_home.svg",
      animPath: "assets/images/tab_home.webp",
      builder: (context) => const BanBanHomePage(),
    ),
    PageItem(
      title: "动态",
      unselectedImgPath: "assets/images/tab_msg.svg",
      animPath: "assets/images/tab_msg.webp",
      builder: (context) => const BanBanMsgPage(),
    ),
  ];

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    var items = _pageItemList
        .map(
          (e) => BottomNavigationBarItem(
              icon: SvgPicture.asset(
                e.unselectedImgPath,
                width: 36,
                height: 36,
              ),
              activeIcon: Image.asset(
                e.animPath,
                width: 36,
                height: 36,
              ),
              label: e.title),
        )
        .toList();
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: _currentPageIndex,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
            _pageController.jumpToPage(index);
          });
        },
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return PageView.builder(
      controller: _pageController,
      itemBuilder: (context, index) => _pageItemList[index].getPage(context),
      itemCount: _pageItemList.length,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}

class PageItem {
  final String title;
  final String unselectedImgPath;
  final String animPath;
  final WidgetBuilder builder;

  PageItem({
    required this.title,
    required this.unselectedImgPath,
    required this.animPath,
    required this.builder,
  });

  Widget? _page;

  Widget getPage(BuildContext context) {
    _page ??= builder.call(context);
    return _page!;
  }
}
