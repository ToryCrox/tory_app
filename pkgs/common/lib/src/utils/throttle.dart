// @dart=2.12
import 'dart:async';

/// 节流对象：提供一个方法，在单位时间内只首次响应行为.(可以控制响应行为完成后
/// 是否继续响应接下来的行为)
/// [func] 行为方法
/// 可选 [duration] 单位节流时间
class Throttle {
  final Duration _duration;

  bool _enable = true;

  Timer? _timer;

  Throttle({Duration duration = const Duration(milliseconds: 800)})
      : _duration = duration;

  /// [preventFuc]处于节流状态的回调
  /// [func] 行为方法
  void call(FutureOr<void> Function()? func, {Function? preventFuc}) async {
    if (func == null) return;
    if (_enable) {
      _enable = false;
      await func.call();
      _timer = Timer(_duration, () => _enable = true);
    } else {
      preventFuc?.call();
    }
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
