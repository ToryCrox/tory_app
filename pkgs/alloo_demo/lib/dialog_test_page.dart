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
                /// 默认自带确认按钮，不带取消，需要取消按钮，需要设置negativeButton或者positiveText
                negativeButton: const AllooNegativeButton(),
              );
            },
          ),
          ListTile(
            title: const Text('有标题，一个按钮，有关闭按钮'),
            onTap: () {
              AllooAlertDialog.show(
                context: context,
                titleText: '温馨提示',
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
                titleText: '温馨提示',
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
                titleText: '你未上传头像',
                /// 也可以用content = Text.rich()来自定义内容
                contentRich: [
                  const TextSpan(text: '继续完善资料，可获得 '),
                  const TextSpan(
                    text: 'RP15',
                    style: TextStyle(color: Color(0xFFFF8E2A)),
                  ),
                ],
                negativeButton: const AllooNegativeButton(),
                positiveButton: const AllooPositiveButton(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '立即上传'),
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
                titleText: '你想要将这位观众踢出直播间吗？',
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
          ListTile(
            title: const Text('倒计时自动关闭'),
            onTap: () {
              showWithCountDown(context);
            },
          ),
        ],
      ),
    );
  }


  /// 按钮倒计时自动关闭示例
  Future showWithCountDown(BuildContext context) async {
    /// controller用于手动关闭弹窗
    final controller = AllooAlertDialogController();
    await AllooAlertDialog.show(
      context: context,
      titleText: '温馨提示',
      contentText: '在接听过程中对方有低俗、涉政、辱骂等让您感到不适的行为，请及时挂断向客服举报，我们会立刻帮助处理。',
      positiveButton: AllooPositiveButton(
        child: CountDownWidget(
          countDownTime: 9000,
          builder: (context, timeLeft) => Text('确认(${timeLeft ~/ 1000}s)'),
          onCountDownFinish: () {
            controller.close();
          },
        ),
      ),
      controller: controller,
    );
  }
}
