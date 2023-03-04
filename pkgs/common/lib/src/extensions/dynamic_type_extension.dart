
import 'dart:ui';

import '../../common.dart';

/// 根据TypeUtil的实现，扩展dynamic类型的成员，用来安全解析各种类型的数据
/// 直接调用TypeUtil的方法，不需要再传入默认值
/// 都用to为前缀，例如 int get toInt => TypeUtil.parseInt(this)
/// 实现了一些常用的类型转换，例如：int, double, bool, String, List, , Map, Set, Color
/// 其中因为toString是关键字，所以用toJsonString代替
extension DynamicTypeExtension on dynamic {
  /// 转换成int
  /// 如果value是bool，则true转换成1， false为0
  int get toInt => TypeUtil.parseInt(this);

  /// 解析bool类型
  /// - 如果为bool类型，则直接返回
  /// - 如果为num类型，则为0表示false，否则为true
  /// - 如果为String类型，则'true'表示true，否则转换Int类型， 判断是否为0
  bool get toBool => TypeUtil.parseBool(this);

  /// 转换成String
  /// 如果value是bool，则true转换成'1'， false为'0'
  /// 如果value是Map或List, Set，则转换成json字符串
  String get toJsonString => TypeUtil.parseString(this);

  /// 转换成double
  /// 如果value是bool，则true转换成1.0， false为0.0
  /// 如果value是String，则转换成double
  /// 如果value是int，则转换成double
  /// 如果value是double，则直接返回
  /// 如果value是其他类型，则返回0.0
  double get toDouble => TypeUtil.parseDouble(this);

  /// 转换成List
  /// 如果value是List，则直接返回
  List<String> get toStringList => TypeUtil.parseStringList(this);

  /// 转换成List
  /// 如果value是List，则直接返回
  List<int> get toIntList => TypeUtil.parseIntList(this);

  /// 转换成Map
  /// 如果value是Map，则直接返回
  /// 如果value是List，则转换成Map
  /// 如果value是Set，则转换成Map
  /// 如果value是其他类型，则返回空Map
  Map<String, dynamic> get toMap => TypeUtil.parseMap(this);

  /// 转换成Color
  /// 如果value是Color，则直接返回
  /// 如果value是String，则转换成Color
  Color get toColor => TypeUtil.parseColor(this);
}

