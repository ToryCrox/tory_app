// @ignore_hardcode
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BasicWidgetsPage extends StatefulWidget {
  const BasicWidgetsPage({Key? key}) : super(key: key);

  @override
  State<BasicWidgetsPage> createState() => _BasicWidgetsPageState();
}

class _BasicWidgetsPageState extends State<BasicWidgetsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("基础组件测试"),
      ),
      body: ListView(
        children: [
          createSwitchAnCheckBoxWidget(),
          ...createTextField(),
          const SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            child: Container(
                width: 88,
                height: 76,
                color: const Color(0xF0191222),
                child: _buildSettingItem()),
          ),
          //buildSpinKit(context),
        ],
      ),
    );
  }

  Row buildSpinKit(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("SpinKit"),
        SpinKitRotatingCircle(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        ),
        SpinKitFadingCircle(
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.red : Colors.green,
              ),
            );
          },
        )
      ],
    );
  }

  final TextEditingController _unameController = TextEditingController();
  var _isShowPass = false;

  @override
  void initState() {
    _unameController.addListener(() {
      debugPrint("name controller: ${_unameController.text}");
    });
  }

  List<Widget> createTextField() {
    return <Widget>[
      TextField(
        autofocus: true,
        controller: _unameController,
        onChanged: (v) {
          debugPrint("name change: $v");
        },
        decoration: const InputDecoration(
            labelText: "用户名",
            hintText: "用户名或邮箱",
            prefixIcon: Icon(Icons.person)),
      ),
      Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                  labelText: "密码",
                  hintText: "您的登录密码",
                  prefixIcon: Icon(Icons.lock)),
              obscureText: !_isShowPass,
            ),
          ),
          Checkbox(
              value: _isShowPass,
              onChanged: (value) {
                setState(() {
                  _isShowPass = !_isShowPass;
                });
              })
        ],
      ),
    ];
  }

  var _isSwitchSelected = false;
  var _isCheckboxSelected = false;

  /// switch和checkbox测试
  Widget createSwitchAnCheckBoxWidget() {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: Switch.adaptive(
                value: _isSwitchSelected,
                onChanged: (value) {
                  setState(() {
                    _isSwitchSelected = !_isSwitchSelected;
                  });
                },
              ),
            ),
          ),
        ),
        Expanded(
            child: CupertinoSwitch(
          value: _isSwitchSelected,
          onChanged: (value) {
            setState(() {
              _isSwitchSelected = !_isSwitchSelected;
            });
          },
        )),
        Expanded(
          child: Checkbox(
            value: _isCheckboxSelected,
            onChanged: (value) {
              setState(
                () {
                  _isCheckboxSelected = !_isCheckboxSelected;
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem() {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 6),
          Stack(
            children: [
              Image.asset(
                'assets/images/ic_auto_mic.png',
                width: 40,
                height: 40,
              ),
              PositionedDirectional(
                bottom: 0,
                end: 0,
                child: SvgPicture.asset(
                  'assets/images/ic_cupertino_switch_open.svg',
                  width: 16,
                  height: 10,
                ),
              )
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Auto-start microphone',
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Color(0xFFBABABA), fontSize: 11, height: 1),
            ),
          )
        ],
      ),
    );
  }
}
