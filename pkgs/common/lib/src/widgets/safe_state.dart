
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// 防止dispose后调用导致报错
mixin SafeStateMixin<T extends StatefulWidget> on State<T> {

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    } else {
      debugPrint('SafeStateMixin setState after disposed');
    }
  }

  /// 下一帧时执行，并且setState
  void setNextState(VoidCallback fn) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        fn();
      });
    });
  }

  /// 下一帧时执行，不执行setState
  void addNextTask(VoidCallback fn) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        fn();
      }
    });
  }
}


abstract class SafeState<T extends StatefulWidget> extends State<T> with SafeStateMixin<T> {

}

/// 防止dispose后调用导致报错
mixin SafeChangeNotifierMixin on ChangeNotifier {

  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    } else {
      debugPrint('SafeChangeNotifierMixin notifyListeners after disposed');
    }
  }
}

abstract class SafeChangeNotifier extends ChangeNotifier with SafeChangeNotifierMixin {

}

class SafeValueNotifier<T> extends ValueNotifier<T> with SafeChangeNotifierMixin {

  SafeValueNotifier(T value) : super(value);

  @override
  set value(T newValue) {
    if (const DeepCollectionEquality().equals(value, newValue)) {
      return;
    }
    super.value = newValue;
  }
}