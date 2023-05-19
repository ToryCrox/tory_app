import 'package:flutter/material.dart';
// @ignore_hardcode
class ImageAndIconRoute extends StatelessWidget {
  const ImageAndIconRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("图片测试"),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
              SizedBox(height: 20),
              _ninePathTestImage(context),
              ..._buildImageTypeList(),
            ]
        ),
      ),
    );
  }


  Widget _ninePathTestImage(BuildContext context) {
    String imagePath = 'assets/images/img_nine_patch_test.webp';
    final imageProvider = AssetImage(imagePath);
    final decorationImage = DecorationImage(
      image: imageProvider,
      centerSlice: const Rect.fromLTWH(20, 10, 1, 1),
      scale: 3,
    );
    return Container(
      //height: 22.0,
      constraints: const BoxConstraints(minHeight: 22.0, minWidth: 41),
      decoration: BoxDecoration(image: decorationImage),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Text("Hello World"),
    );
  }

  List<Widget> _buildImageTypeList() {
    var img = const AssetImage("assets/images/test_avatar.png");
    return <Image>[
      Image(
        image: img,
        height: 50.0,
        width: 100.0,
        fit: BoxFit.fill,
      ),
      Image(
        image: img,
        height: 50,
        width: 50.0,
        fit: BoxFit.contain,
      ),
      Image(
        image: img,
        width: 100.0,
        height: 50.0,
        fit: BoxFit.cover,
      ),
      Image(
        image: img,
        width: 100.0,
        height: 50.0,
        fit: BoxFit.fitWidth,
      ),
      Image(
        image: img,
        width: 100.0,
        height: 50.0,
        fit: BoxFit.fitHeight,
      ),
      Image(
        image: img,
        width: 100.0,
        height: 50.0,
        fit: BoxFit.scaleDown,
      ),
      Image(
        image: img,
        height: 50.0,
        width: 100.0,
        fit: BoxFit.none,
      ),
      Image(
        image: img,
        width: 100.0,
        color: Colors.blue,
        colorBlendMode: BlendMode.difference,
        fit: BoxFit.fill,
      ),
      Image(
        image: img,
        width: 100.0,
        height: 200.0,
        repeat: ImageRepeat.repeatY,
      )
    ].map((e) {
      return Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 100,
              child: e,
            ),
          ),
          Text(e.fit.toString())
        ],
      );
    }).toList();
  }
}
