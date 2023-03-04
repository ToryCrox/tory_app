
/// String的扩展，String是可空的
extension StringExtension on String? {
  /// 是否为空
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// 是否不为空
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// 是否为空白
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  /// 是否不为空白
  bool get isNotNullOrBlank => !isNullOrBlank;

  /// 是否为数字
  bool get isNumber =>
      isNotNullOrEmpty && RegExp(r'^-?\d+\.?\d*$').hasMatch(this!);

  /// 是否为整数
  bool get isInt => isNotNullOrEmpty && RegExp(r'^-?\d+$').hasMatch(this!);

  /// 是否为浮点数
  bool get isDouble => isNotNullOrEmpty && RegExp(r'^-?\d+\.\d+$').hasMatch(this!);

  /// 是否是Url
  bool get isUrl => isNotNullOrEmpty && RegExp(r'^https?://').hasMatch(this!);
}