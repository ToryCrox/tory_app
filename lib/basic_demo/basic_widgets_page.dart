import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BasicWidgetsPage extends StatefulWidget {
  const BasicWidgetsPage({Key? key}) : super(key: key);

  @override
  State<BasicWidgetsPage> createState() => _BasicWidgetsPageState();
}

class _BasicWidgetsPageState extends State<BasicWidgetsPage> {
  var _isSwitchSelected = false;
  var _isCheckboxSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("基础组件测试"),
      ),
      body: ListView(
        children: [
          createSwitchAnCheckBoxWidget(),
          ...createTextField(),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 1,
            child: LinearProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
            ),
          ),
          // 圆形进度条直径指定为100
          Center(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation(Colors.blue),
              ),
            ),
          ),
          buildSpinKit(context),
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

  /// switch和checkbox测试
  Widget createSwitchAnCheckBoxWidget() {
    return Row(
      children: [
        Expanded(
          child: Switch(
            value: _isSwitchSelected,
            onChanged: (value) {
              setState(() {
                _isSwitchSelected = !_isSwitchSelected;
              });
            },
          ),
        ),
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
}
