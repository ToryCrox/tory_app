import 'package:alloo_demo/widgets/alloo_alert_dialog.dart';
import 'package:alloo_demo/widgets/alloo_check_box.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';

class AllooTestDialogPage extends StatefulWidget {
  const AllooTestDialogPage({Key? key}) : super(key: key);

  @override
  State<AllooTestDialogPage> createState() => _AllooTestDialogPageState();
}

class _AllooTestDialogPageState extends State<AllooTestDialogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dialog相关测试'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('没有标题，一个按钮'),
            onTap: () {
              AllooAlertDialog.show(
                context: context,
                contentText: '是否取消关注',
              );
            },
          ),
          ListTile(
            title: const Text('没有标题，两个按钮'),
            onTap: () {
              AllooAlertDialog.show(
                context: context,
                contentText: '你已被主播设为管理员，管理员可以将任何不',
                negativeButton: const AllooNegativeButton(),
              );
            },
          ),
          ListTile(
            title: const Text('有标题，一个按钮，有关闭按钮'),
            onTap: () {
              AllooAlertDialog.show(
                context: context,
                title: '温馨提示',
                contentText: '退出直播间将不再收听该直播',
                showClose: true,
              );
            },
          ),
          ListTile(
            title: const Text('有标题，两个按钮'),
            onTap: () {
              AllooAlertDialog.show(
                context: context,
                title: '温馨提示',
                contentText: 'Alloo提倡真实交友，自我介绍需要完成真人认证才能填写哦~',
                negativeButton: const AllooNegativeButton(),
              );
            },
          ),
          ListTile(
            title: const Text('有标题，两个按钮，自定义内容，确认按钮文字自定义'),
            onTap: () {
              AllooAlertDialog.show(
                context: context,
                title: '你未上传头像',
                content: const Text('完成真人认证需要先上传头像\n上传头像可获得金币奖励哟~'),
                negativeButton: const AllooNegativeButton(),
                positiveButton: AllooPositiveButton(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: '立即上传'),
                        WidgetSpan(child: SizedBox(width: 2)),
                        TextSpan(
                            text: '+15',
                            style: TextStyle(
                              color: Color(0xFFFFE886),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('带钩选项'),
            onTap: () async {
              final AllooCheckBoxController checkController =
                  AllooCheckBoxController(false);
              final result = await AllooAlertDialog.show(
                context: context,
                title: '你想要将这位观众踢出直播间吗？',
                //contentText: '加入本直播间黑名单，永久禁止进入',
                content: GestureDetector(
                  child: AllooCheckBox(
                    controller: checkController,
                    padding: const EdgeInsets.only(top: 3),
                    child: const Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('加入本直播间黑名单，永久禁止进入'),
                    ),
                  ),
                ),
                negativeButton: const AllooNegativeButton(),
              );
              dog.d('结果为 是否确认: ${result}, 勾选结果为: ${checkController.value}');
            },
          ),
        ],
      ),
    );
  }
}
