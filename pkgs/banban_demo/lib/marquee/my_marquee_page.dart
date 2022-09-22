
import 'package:flutter/material.dart';

import 'swiper_marquee.dart';

class MyMarqueeTest extends StatefulWidget {
  const MyMarqueeTest({Key? key}) : super(key: key);

  @override
  State<MyMarqueeTest> createState() => _MyMarqueeTestState();
}

class _MyMarqueeTestState extends State<MyMarqueeTest> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("测试"),
      ),
      body: Center(
        child: Container(
          color: Colors.black38,
          width: 200,
          alignment: Alignment.center,
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              _buildScrollerText(),
              SizedBox(height: 100,),
              Container(
                width: 200,
                height: 20,
                color: Colors.green,
                child: VerticalSwiper(
                  swiperDuration: const Duration(milliseconds: 500),
                  onItemTap: (index){
                    debugPrint("tap index: $index");
                  },
                  marqueeSpeed: 50,
                  children: [
                    Text("1111111111111"),
                    Text("222222222222222222222222222222222222"),
                    // Text("33333333333333333333333333333333333333333333"),
                    Text("444444444444444444"),
                    // Text("55555555555"),
                    // Text("666666666666666"),
                    // Text("777777777777777777"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      print("onListener: ${_controller.position}");
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildScrollerText() {
    return Container(
      width: 150,
      height: 20,
      decoration: BoxDecoration(
          color: const Color(0x52000000),
          borderRadius: BorderRadius.circular(11)
      ),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [Colors.white, Colors.transparent, Colors.transparent, Colors.white],
            stops: [0.0, 0.1, 0.9, 1.0],
          ).createShader(bounds, textDirection: TextDirection.ltr);
        },
        blendMode: BlendMode.dstOut,
        child: SwiperMarquee(
          marqueeGap: 50,
          marqueeSpeed: 30,
          children: [
            _buildItem("", "1111333311111222222222222222222222222222"),
            //_buildItem("", "222222222222222"),
            //_buildItem("", "3333333333333333333333333333333333333"),
            //_buildItem("", "44444444444444444"),
            //_buildItem("", "5555555"),
          ],
          onItemTap: (index){
            print("onItemTap:$index");
          },
        ),
      ),
    );
  }


  Widget _buildItem(String icon, String text) {
    return Container(
      //constraints: BoxConstraints(minWidth: 80.dp, minHeight: 19.dp),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon.isNotEmpty) ...[
            const SizedBox(width: 3),
          ],
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

