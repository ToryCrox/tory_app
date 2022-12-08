// @dart=2.12

class RoomWelcomeItem {

  final String name;
  final bool isNewer;
  final int financeLevel;// 财富等级
  final int fontColor;
  final String background;

  const RoomWelcomeItem({
    required this.name,
    required this.isNewer,
    required this.financeLevel,
    required this.fontColor,
    required this.background,
  });
}