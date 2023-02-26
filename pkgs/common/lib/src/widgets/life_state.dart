// @dart=2.12
import 'package:flutter/material.dart';

/// state 的initState和dispose事件监听
enum LifeState {
  none,
  initialized,
  disposed
}

typedef LifeStateObserver = Function(LifeStateOwner owner, LifeState state);

abstract class LifeStateOwner {

  LifeState get state;

  /// 添加事件监听，如果已经iniState，或者dispose，则会直接回调state
  void addObserver(LifeStateObserver observer);

  /// 清除事件监听
  void removeObserver(LifeStateObserver observer);
}

class LifeStateOwnerImpl extends LifeStateOwner {
  LifeState _state;

  LifeStateOwnerImpl({LifeState state = LifeState.none}): _state = state;

  @override
  LifeState get state => _state;

  final List<LifeStateObserver> _observers = [];

  @override
  void addObserver(LifeStateObserver observer) {
    if (_state == LifeState.disposed) {
      return;
    }
    _observers.add(observer);
    if (_state.index >= LifeState.initialized.index) {
      _onStateChange(observer, _state);
    }
  }

  @override
  void removeObserver(LifeStateObserver observer) {
    _observers.remove(observer);
  }

  void _dispatchState(LifeState state) {
    if (_state == state) {
      return;
    }
    _state = state;
    for (var observer in _observers) {
      _onStateChange(observer, state);
    }
    if (_state == LifeState.disposed) {
      _observers.clear();
    }
  }

  void _onStateChange(LifeStateObserver observer, LifeState state) {
    observer(this, state);
  }

}

mixin LifeStateOwnerMixin<T extends StatefulWidget> on State<T> implements LifeStateOwner {

  final LifeStateOwnerImpl _impl = LifeStateOwnerImpl();

  @override
  LifeState get state => _impl.state;

  @override
  void addObserver(LifeStateObserver observer) {
    _impl.addObserver(observer);
  }

  @override
  void removeObserver(LifeStateObserver observer) {
    _impl.removeObserver(observer);
  }


  @override
  void initState() {
    super.initState();
    _impl._dispatchState(LifeState.initialized);
  }


  @override
  void dispose() {
    super.dispose();
    _impl._dispatchState(LifeState.disposed);
  }

}


mixin ChangeNotifierLifeStateOwnerMixin on ChangeNotifier implements LifeStateOwner {
  final LifeStateOwnerImpl _impl =
      LifeStateOwnerImpl(state: LifeState.initialized);

  @override
  LifeState get state => _impl.state;

  @override
  void addObserver(LifeStateObserver observer) {
    _impl.addObserver(observer);
  }

  @override
  void removeObserver(LifeStateObserver observer) {
    _impl.removeObserver(observer);
  }

  @override
  void dispose() {
    super.dispose();
    _impl._dispatchState(LifeState.disposed);
  }

}

extension ChangeNotifierLifeState on ChangeNotifier {

  void withLifeState(LifeStateOwner owner, VoidCallback listener) {
    owner.addObserver((owner, state) {
      if (state == LifeState.initialized) {
        addListener(listener);
      } else if (state == LifeState.disposed) {
        removeListener(listener);
      }
    });
  }

}