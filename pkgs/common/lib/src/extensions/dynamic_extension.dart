

import '../../common.dart';

extension DynamicExtension on dynamic {

  /// 比较是否相等
  bool equal(dynamic other) {
    return const DeepCollectionEquality().equals(this, other);
  }

}

extension NullableExtension<T> on T? {

  /// 如果不为空，则执行block
  /// 使用范例
  /// ```dart
  /// 1.let((it) => print(it));
  /// null.let((it) => print(it));
  /// ```
  R? let<R>(R Function(T it) block) {
    if (this != null) {
      return block(this as T);
    }
    return null;
  }
}