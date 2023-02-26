import 'dart:convert';

/// 一些数据转换工具，主要确保安全
class TypeUtil {
  TypeUtil._();

  /// 转换成int
  /// 如果value是bool，则true转换成1， false为0
  static int parseInt(dynamic value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    if (value == 'null') return defaultValue;

    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        return defaultValue;
      }
    }
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is bool) return value ? 1 : 0;
    return defaultValue;
  }

  /// 解析bool类型
  /// - 如果为num类型，则为1表示true，否则为false
  /// - 如果为String类型，则'true'表示true，否则为false
  static bool parseBool(dynamic value, [bool defaultValue = false]) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is num) return value == 1;
    if (value is String) value.toLowerCase() == 'true';
    return defaultValue;
  }

  /// 转换成String
  static String parseString(dynamic value, [String defaultValue = '']) {
    if (value == null) return '';
    if (value is Map) return jsonEncode(value);
    if (value is List) return jsonEncode(value);
    return '$value';
  }

  static double parseDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return defaultValue;
      }
    }
    return defaultValue;
  }

  /// 解析list， value可以为字符串数组
  static List<T> parseList<T>(dynamic value, T Function(dynamic e) f) {
    if (value == null) return [];
    List list = [];
    if (value is String && value.isNotEmpty) {
      try {
        list = jsonDecode(value);
      } catch (e) {
        list = [];
      }
    } else if (value is List) {
      list = value;
    }

    if (list.isNotEmpty) {
      return list.map((e) => f(e)).toList();
    } else {
      return [];
    }
  }

  static List<String> parseStringList(dynamic value) {
    if (value is List<String>) return value;
    return parseList(value, (e) => parseString(e));
  }

  static List<int> parseIntList(dynamic value) {
    if (value is List<int>) return value;
    return parseList(value, (e) => parseInt(e));
  }

  /// value解析，确保不会报错
  static Map<String, dynamic> parseMap(dynamic value) {
    if (value == null) return {};
    if (value is Map<String, dynamic>) return value;
    if (value is String && value.isNotEmpty) {
      try {
        return jsonDecode(value);
      } catch (e) {
        return {};
      }
    }
    return {};
  }
}
