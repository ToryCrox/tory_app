
/// 集合扩展
extension ExtendedIterable<E> on Iterable<E> {

  /// 获取结果
  E? getOrNull(int index) {
    if (index < 0 || index >= length) {
      return null;
    }
    return elementAt(index);
  }

  /// 检查是否越界
  bool checkIndex(int index) => index >= 0 && index < length;

  /// 在列表中间添加结果
  Iterable<R> mapJoin<R>(R Function(int index, E element) convert, R Function(int index, E element) separator) sync* {
    var index = 0;
    for (var element in this) {
      if (index > 0) {
        yield separator(index, element);
      }
      yield convert(index, element);
      index++;
    }
  }

  Iterable<E> addJoin(E Function(int index, E element) separator) sync* {
    var index = 0;
    for (var element in this) {
      if (index > 0) {
        yield separator(index, element);
      }
      yield element;
      index++;
    }
  }

}
