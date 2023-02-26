
import 'package:common/common.dart';

/// map扩展
extension ExtendedMap on Map<dynamic, dynamic> {

  int getInt(String key, [int defaultValue = 0]) {
    return TypeUtil.parseInt(this[key], defaultValue);
  }

  double getDouble(String key, [double defaultValue = 0]) {
    return TypeUtil.parseDouble(this[key], defaultValue);
  }

  bool getBool(String key, [bool  defaultValue = false]) {
    return TypeUtil.parseBool(this[key], defaultValue);
  }

  String getString(String key, [String  defaultValue = '']) {
    return TypeUtil.parseString(this[key], defaultValue);
  }

  List<T> getList<T>(String key, T Function(dynamic e) f) {
    return TypeUtil.parseList(this[key], f);
  }

  List<int> getIntList(String key) {
    return getList(key, (e) => TypeUtil.parseInt(key));
  }

  List<String> getStringList(String key) {
    return getList(key, (e) => TypeUtil.parseString(key));
  }

  Map<String, dynamic> getMap(String key) {
    return TypeUtil.parseMap(this[key]);
  }
}
