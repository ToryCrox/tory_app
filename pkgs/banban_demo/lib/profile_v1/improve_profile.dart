// @ignore_hardcode

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/base_appbar.dart';
import 'avatar_picker.dart';



class ImproveProfilePage extends StatelessWidget {
  const ImproveProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: const Color(0xFF00DACB),
      ),
      child: const ImproveProfile(),
    );
  }
}

class ImproveProfile extends StatefulWidget {
  const ImproveProfile({Key? key}) : super(key: key);

  @override
  State<ImproveProfile> createState() => _ImproveProfileState();
}

class _ImproveProfileState extends State<ImproveProfile> {
  Profile profile = Profile();

  final TextEditingController _nameController = TextEditingController();

  final ValueNotifier<bool> _submitState = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      profile.nickName = _nameController.text;
      _submitState.value = _nameController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build...");
    return Scaffold(
      backgroundColor: RColor.backgroundColor,
      appBar: const BaseAppBar(
        title: '完善资料',
      ),
      //bottomNavigationBar: _buildSubmitButton(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text("让大家更好的认识你"),
                ),
                const SizedBox(height: 40),
                _buildAvatarSetting(),
                const SizedBox(height: 30),
                _buildNickName(),
                _buildGender(),
                //_buildInviteCode(),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ValueListenableBuilder<bool>(
              valueListenable: _submitState,
              builder: (context, value, child) {
                return _buildSubmitButton(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  final TextStyle _rowTipTextStyle = const TextStyle(
    fontSize: 16,
    color: RColor.secondTextColor,
  );

  void _goAvatarPicker() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return const AvatarPicker();
    }));
    debugPrint("avatarPicker result:$result");
  }

  /// 换头像
  Widget _buildAvatarSetting() {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(50)),
            child: GestureDetector(
              onTap: _goAvatarPicker,
              child: SvgPicture.asset(
                "pkgs/banban_demo/assets/images/ic_login_avatar.svg",
                width: 36,
                height: 36,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          PositionedDirectional(
            end: 20,
            child: GestureDetector(
              onTap: _goAvatarPicker,
              child: Text(
                "换一个 >",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 14),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNickName() {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Text(
            "昵称:",
            style: _rowTipTextStyle,
          ),
          const SizedBox(width: 8),
          Expanded(
              child: TextField(
            controller: _nameController,
            style: const TextStyle(
              fontSize: 16,
              color: RColor.primaryTextColor,
            ),
            maxLength: 20,
            maxLines: 1,
            //textInputAction: TextInputAction.none,
            decoration: const InputDecoration(
              hintText: "请输入昵称",
              hintStyle: TextStyle(fontSize: 16, color: RColor.secondTextColor),
              border: InputBorder.none,
              counterText: "",
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ))
        ],
      ),
    );
  }

  Widget _buildGender() {
    var genderName = "";
    if (profile.gender == 1) {
      genderName = "男生";
    } else if (profile.gender == 2) {
      genderName = "女生";
    }
    return SizedBox(
      height: 48,
      child: GestureDetector(
        onTap: () async {
          final resultGender =
              await _showGenderPicker(profile.gender) ?? profile.gender;
          setState(() {
            profile.gender = resultGender;
          });
        },
        child: Row(
          children: [
            Text(
              "性别:",
              style: _rowTipTextStyle,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                genderName,
                style: const TextStyle(
                    fontSize: 16, color: RColor.primaryTextColor),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: RColor.secondTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteCode() {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Text(
            "邀请码:",
            style: _rowTipTextStyle,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              "选填",
              style: TextStyle(
                fontSize: 16,
                color: RColor.primaryTextColor,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: RColor.secondTextColor,
          ),
        ],
      ),
    );
  }

  /// 弹出性别选择框
  Future<int?> _showGenderPicker(int gender) {
    return showModalBottomSheet<int?>(
      context: context,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      builder: (context) {
        return GenderPicker(
            onGenderChanged: (g) {
              Navigator.pop(context, g);
            },
            gender: gender);
      },
    );
  }

  Widget _buildSubmitButton(bool isEnable) {
    final borderRadius = BorderRadius.circular(24);
    return SafeArea(
      top: false,
      child: InkWell(
        onTap: isEnable
            ? () {
                debugPrint("you click submit");
              }
            : null,
        borderRadius: borderRadius,
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isEnable
                ? Theme.of(context).primaryColor
                : RColor.disableButtonColor,
            borderRadius: borderRadius,
          ),
          child: const Center(
            child: Text(
              "进入",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}

class GenderPicker extends StatelessWidget {
  final int gender;
  final ValueChanged<int> onGenderChanged;

  const GenderPicker(
      {Key? key, required this.onGenderChanged, required this.gender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maleImg = gender == 1
        ? "pkgs/banban_demo/assets/images/ic_gender_inset_male_checked.webp"
        : "pkgs/banban_demo/assets/images/ic_gender_inset_male.webp";
    final femaleImg = gender == 2
        ? "pkgs/banban_demo/assets/images/ic_gender_inset_female_checked.webp"
        : "pkgs/banban_demo/assets/images/ic_gender_inset_female.webp";

    return Container(
      height: 330,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 36),
          Text(
            "完善资料",
            style: TextStyle(
                color: RColor.primaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 6),
          Text(
            "注册成功后性别不可修改",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGenderAvatar("男生", maleImg, 1),
              _buildGenderAvatar("女生", femaleImg, 2),
            ],
          ),
          const SizedBox(height: 40)
        ],
      ),
      // decoration: const BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadiusDirectional.only(
      //     topStart: Radius.circular(10),
      //     topEnd: Radius.circular(10),
      //   ),
      // ),
    );
  }

  Widget _buildGenderAvatar(String text, String img, int gender) {
    return GestureDetector(
      onTap: () {
        onGenderChanged(gender);
      },
      child: Column(
        children: [
          Image.asset(
            img,
            width: 90,
            height: 90,
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }
}

class Profile {
  String nickName = "";
  String avatar = "";
  int gender = 0;
}

class RColor {
  static const Color primaryColor = Color(0xFF00DACB);
  static const Color backgroundColor = Colors.white;
  static const Color secondBgColor = Color(0xFFF5F5F5);
  static const Color primaryTextColor = Color(0xFF202020);
  static const Color secondTextColor = Color(0xB3202020);
  static const Color disableButtonColor = Color(0xFFE6E6E6);
}
