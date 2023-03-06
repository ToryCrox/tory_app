
import '../../common.dart';

/// 一些通用数据的工具类
/// - [equal] 判断两个对象是否相等, 可以进行深度遍历是否相等， 使用[DeepCollectionEquality]进行比较
class DynamicUtil {

  DynamicUtil._();

  /// 判断两个对象是否相等, 可以进行深度遍历是否相等， 使用[DeepCollectionEquality]进行比较
  static bool equal(dynamic a, dynamic b) {
    return const DeepCollectionEquality().equals(a, b);
  }

}