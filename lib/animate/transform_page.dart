import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'widget/scale_size_widget.dart';

class TransformPage extends StatefulWidget {
  const TransformPage({Key? key}) : super(key: key);

  @override
  State<TransformPage> createState() => _TransformPageState();
}

class _TransformPageState extends State<TransformPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transform测试"),
      ),
      body: Column(
        children: [
          _buildScaleTest(),
        ],
      ),
    );
  }

  _buildScaleTest() {
    return Container(
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ScaleSizeWidget(
              scale: 20 / 12,
              textAligned: Alignment.bottomCenter,
              child: Text(
                'Recommend',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          Text(
            'Recommend',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
