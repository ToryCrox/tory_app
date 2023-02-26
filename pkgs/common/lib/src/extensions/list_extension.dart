

import 'package:common/common.dart';

extension ExtendedList<T> on List<T> {

  /// 交换
  void swapSafe(int index1, int index2) {
    if (!checkIndex(index1)) return;
    if (!checkIndex(index2)) return;
    if (index1 != index2) {
      var tmp1 = this[index1];
      this[index1] = this[index2];
      this[index2] = tmp1;
    }
  }
}