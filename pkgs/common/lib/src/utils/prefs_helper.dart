

import 'dart:convert';

import 'package:common/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 本地存储帮助类，全部为空安全
class PrefsHelper {

  PrefsHelper._();

  static late SharedPreferences _prefs;

  static SharedPreferences get prefs => _prefs;

  static bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  static delete(String key) {
    _prefs.remove(key);
  }

  static Future<bool> init() async {
    _prefs = await SharedPreferences.getInstance();
    return true;
  }

  static int getInt(String key, [int defaultValue = 0]) {
    return TypeUtil.parseInt(_prefs.get(key), defaultValue);
  }

  static Future<bool> setInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  static double getDouble(String key, [double defaultValue = 0]) {
    return TypeUtil.parseDouble(_prefs.get(key), defaultValue);
  }

  static Future<bool>  setDouble(String key, double value) {
    return _prefs.setDouble(key, value);
  }

  static bool getBool(String key, [bool defaultValue = false]) {
    return TypeUtil.parseBool(_prefs.get(key), defaultValue);
  }

  static Future<bool> setBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  static String getString(String key, [String defaultValue = '']) {
    return TypeUtil.parseString(_prefs.get(key), defaultValue);
  }

  static Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  static List<String> getStringList(String key) {
    return _prefs.getStringList(key) ?? [];
  }

  static Future<bool> setStringList(String key, List<String> value) {
    return _prefs.setStringList(key, value);
  }

  static List<T> getList<T>(String key, T Function(String s) fn) {
    return getStringList(key).map((e) => fn(e)).toList();
  }

  static Future<bool> setList<T>(String key, List<T> value, String Function(T e) fn) {
    return _prefs.setStringList(key, value.map((e) => fn(e)).toList());
  }

  static Map<String, dynamic> getMap(String key) {
    return TypeUtil.parseMap(getString(key, ''));
  }

  static Future<bool> setMap(String key, Map<String, dynamic> value) {
    return _prefs.setString(key, jsonEncode(value));
  }

  /// 根据泛型自动获取值，只支持int、double、bool、String、List<String>、Map<String, dynamic>
  static T getValue<T>(String key, T defaultValue) {
    if (T == int) {
      return getInt(key, defaultValue as int) as T;
    } else if (T == double) {
      return getDouble(key, defaultValue as double) as T;
    } else if (T == bool) {
      return getBool(key, defaultValue as bool) as T;
    } else if (T == String) {
      return getString(key, defaultValue as String) as T;
    } else if (T == List<String>) {
      return getStringList(key) as T;
    } else if (T == Map<String, dynamic>) {
      return getMap(key) as T;
    } else {
     throw Exception('not support type: $T');
    }
  }

  /// 根据泛型自动设置值，只支持int、double、bool、String、List<String>、Map<String, dynamic>
  static Future<bool> setValue<T>(String key, T value) async {
    if (T == int) {
      return setInt(key, value as int);
    } else if (T == double) {
      return setDouble(key, value as double);
    } else if (T == bool) {
      return setBool(key, value as bool);
    } else if (T == String) {
      return setString(key, value as String);
    } else if (T == List<String>) {
      return setStringList(key, value as List<String>);
    } else if (T == Map<String, dynamic>) {
      return setMap(key, value as Map<String, dynamic>);
    } else {
      throw Exception('not support type: $T');
    }
  }
}