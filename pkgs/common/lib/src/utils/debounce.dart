// @dart=2.12
import 'dart:async';

/// 防抖类：在触发事件时，不立即执行目标操作，而是给出一个延迟的时间，在该时间范围内
/// 如果再次触发了事件，则重置延迟时间，直到延迟时间结束才会执行目标操作。
/// [func] 行为方法
/// 可选 [duration] 单位时间
class Debounce {
  final Duration _duration;
  Timer? _timer;

  Debounce({Duration duration = const Duration(milliseconds: 800)})
      : _duration = duration;

  void call(Function()? func) {
    if (func == null) return;
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = Timer(_duration, () {
      func.call();
    });
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
