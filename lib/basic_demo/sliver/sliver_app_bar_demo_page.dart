import 'package:flutter/material.dart';

class SliverAppBarDemoPage extends StatefulWidget {
  const SliverAppBarDemoPage({Key? key}) : super(key: key);

  @override
  State<SliverAppBarDemoPage> createState() => _SliverAppBarDemoPageState();
}

class _SliverAppBarDemoPageState extends State<SliverAppBarDemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 200,
              toolbarTextStyle: TextStyle(color: Colors.black),
              elevation: 0,
              centerTitle: true,
              pinned: true,
              title: Text('Holy minio'),
              flexibleSpace: Opacity(
                opacity: 0.6,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue, Colors.purple],
                    ),
                  ),
                ),
              ),
              toolbarHeight: 48,
            ),
          ];
        },
        body: Builder(builder: (BuildContext context) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(
                    title: Text('item1111 ${index}'),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget build2(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 200,
              toolbarTextStyle: TextStyle(color: Colors.black),
              elevation: 0,
              centerTitle: true,
              pinned: true,
              title: Text('Holy minio'),
              flexibleSpace: Opacity(
                opacity: 0.6,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue, Colors.purple],
                    ),
                  ),
                ),
              ),
              toolbarHeight: 48,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text('item1111 ${index}'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
