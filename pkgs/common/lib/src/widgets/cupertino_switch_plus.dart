// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// Examples can assume:
// bool _lights = false;
// void setState(VoidCallback fn) { }
const double _kTrackWidth = 51.0;
const double _kTrackHeight = 31.0;
const double _kSwitchWidth = 59.0;
const double _kSwitchHeight = 39.0;

/// An iOS-style switch.
///
/// Used to toggle the on/off state of a single setting.
///
/// The switch itself does not maintain any state. Instead, when the state of
/// the switch changes, the widget calls the [onChanged] callback. Most widgets
/// that use a switch will listen for the [onChanged] callback and rebuild the
/// switch with a new [value] to update the visual appearance of the switch.
///
/// {@tool dartpad}
/// This example shows a toggleable [CupertinoSwitch]. When the thumb slides to
/// the other side of the track, the switch is toggled between on/off.
///
/// ** See code in examples/api/lib/cupertino/switch/cupertino_switch.0.dart **
/// {@end-tool}
///
/// {@tool snippet}
///
/// This sample shows how to use a [CupertinoSwitch] in a [ListTile]. The
/// [MergeSemantics] is used to turn the entire [ListTile] into a single item
/// for accessibility tools.
///
/// ```dart
/// MergeSemantics(
///   child: ListTile(
///     title: const Text('Lights'),
///     trailing: CupertinoSwitch(
///       value: _lights,
///       onChanged: (bool value) { setState(() { _lights = value; }); },
///     ),
///     onTap: () { setState(() { _lights = !_lights; }); },
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [Switch], the Material Design equivalent.
///  * <https://developer.apple.com/ios/human-interface-guidelines/controls/switches/>
///  IOS样式的Switch，支持设置大小，背景颜色渐变
class CupertinoSwitchPlus extends StatefulWidget {
  /// Creates an iOS-style switch.
  ///
  /// The [value] parameter must not be null.
  /// The [dragStartBehavior] parameter defaults to [DragStartBehavior.start] and must not be null.
  const CupertinoSwitchPlus({Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.trackColor,
    this.thumbColor,
    this.dragStartBehavior = DragStartBehavior.start,

    this.activeGradient,
    this.switchWidth = _kSwitchWidth,
    this.switchHeight = _kSwitchHeight,
    this.switchPadding = const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
    this.trackPadding = const EdgeInsets.all(1),
  }) : super(key: key);

  /// Whether this switch is on or off.
  ///
  /// Must not be null.
  final bool value;

  /// Called when the user toggles with switch on or off.
  ///
  /// The switch passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the switch with the new
  /// value.
  ///
  /// If null, the switch will be displayed as disabled, which has a reduced opacity.
  ///
  /// The callback provided to onChanged should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// CupertinoSwitch(
  ///   value: _giveVerse,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _giveVerse = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool>? onChanged;

  /// The color to use when this switch is on.
  ///
  /// Defaults to [CupertinoColors.systemGreen] when null and ignores
  /// the [CupertinoTheme] in accordance to native iOS behavior.
  final Color? activeColor;

  /// The gradient to use when this switch is on.
  /// switch激活时, 背景渐变色
  final Gradient? activeGradient;

  /// The color to use for the background when the switch is off.
  ///
  /// Defaults to [CupertinoColors.secondarySystemFill] when null.
  final Color? trackColor;

  /// The color to use for the thumb of the switch.
  ///
  /// Defaults to [CupertinoColors.white] when null.
  final Color? thumbColor;

  /// {@template flutter.cupertino.CupertinoSwitch.dragStartBehavior}
  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], the drag behavior used to move the
  /// switch from on to off will begin at the position where the drag gesture won
  /// the arena. If set to [DragStartBehavior.down] it will begin at the position
  /// where a down event was first detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag
  /// animation smoother and setting it to [DragStartBehavior.down] will make
  /// drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.start].
  ///
  /// See also:
  ///
  ///  * [DragGestureRecognizer.dragStartBehavior], which gives an example for
  ///    the different behaviors.
  ///
  /// {@endtemplate}
  final DragStartBehavior dragStartBehavior;

  /// Switch整体的宽高
  final double switchWidth;
  final double switchHeight;

  /// Switch的padding
  /// - 用于控制Switch的大小
  /// - trackerWidth = switchWidth - switchPadding.left - switchPadding.right
  /// - trackerHeight = switchHeight - switchPadding.top - switchPadding.bottom
  final EdgeInsetsGeometry switchPadding;
  /// Switch的padding
  /// - 用于控制thumb的大小
  /// - thumbRadius = (trackerWidth - thumbPadding.left - thumbPadding.right) / 2
  final EdgeInsetsGeometry trackPadding;

  @override
  State<CupertinoSwitchPlus> createState() => _CupertinoSwitchState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('value', value: value, ifTrue: 'on', ifFalse: 'off', showName: true));
    properties.add(ObjectFlagProperty<ValueChanged<bool>>('onChanged', onChanged, ifNull: 'disabled'));
  }
}

class _CupertinoSwitchState extends State<CupertinoSwitchPlus> with TickerProviderStateMixin {
  late TapGestureRecognizer _tap;
  late HorizontalDragGestureRecognizer _drag;

  late AnimationController _positionController;
  late CurvedAnimation position;

  late AnimationController _reactionController;
  late Animation<double> _reaction;

  bool get isInteractive => widget.onChanged != null;

  // A non-null boolean value that changes to true at the end of a drag if the
  // switch must be animated to the position indicated by the widget's value.
  bool needsPositionAnimation = false;

  @override
  void initState() {
    super.initState();

    _tap = TapGestureRecognizer()
      ..onTapDown = _handleTapDown
      ..onTapUp = _handleTapUp
      ..onTap = _handleTap
      ..onTapCancel = _handleTapCancel;
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..dragStartBehavior = widget.dragStartBehavior;

    _positionController = AnimationController(
      duration: _kToggleDuration,
      value: widget.value ? 1.0 : 0.0,
      vsync: this,
    );
    position = CurvedAnimation(
      parent: _positionController,
      curve: Curves.linear,
    );
    _reactionController = AnimationController(
      duration: _kReactionDuration,
      vsync: this,
    );
    _reaction = CurvedAnimation(
      parent: _reactionController,
      curve: Curves.ease,
    );
  }

  @override
  void didUpdateWidget(CupertinoSwitchPlus oldWidget) {
    super.didUpdateWidget(oldWidget);
    _drag.dragStartBehavior = widget.dragStartBehavior;

    if (needsPositionAnimation || oldWidget.value != widget.value) {
      _resumePositionAnimation(isLinear: needsPositionAnimation);
    }
  }

  // `isLinear` must be true if the position animation is trying to move the
  // thumb to the closest end after the most recent drag animation, so the curve
  // does not change when the controller's value is not 0 or 1.
  //
  // It can be set to false when it's an implicit animation triggered by
  // widget.value changes.
  void _resumePositionAnimation({ bool isLinear = true }) {
    needsPositionAnimation = false;
    position
      ..curve = isLinear ? Curves.linear : Curves.ease
      ..reverseCurve = isLinear ? Curves.linear : Curves.ease.flipped;
    if (widget.value) {
      _positionController.forward();
    } else {
      _positionController.reverse();
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (isInteractive) {
      needsPositionAnimation = false;
    }
      _reactionController.forward();
  }

  void _handleTap() {
    if (isInteractive) {
      widget.onChanged!(!widget.value);
      _emitVibration();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (isInteractive) {
      needsPositionAnimation = false;
      _reactionController.reverse();
    }
  }

  void _handleTapCancel() {
    if (isInteractive) {
      _reactionController.reverse();
    }
  }

  void _handleDragStart(DragStartDetails details) {
    if (isInteractive) {
      needsPositionAnimation = false;
      _reactionController.forward();
      _emitVibration();
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      final thumbRadius = (widget.switchHeight -
              widget.switchPadding.vertical -
              widget.trackPadding.vertical) /
          2;
      final trackerInnerLength = widget.switchWidth -
          widget.switchPadding.horizontal -
          widget.trackPadding.horizontal -
          thumbRadius * 2;
      position
        ..curve = Curves.linear
        ..reverseCurve = Curves.linear;
      final double delta = details.primaryDelta! / trackerInnerLength;
      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          _positionController.value -= delta;
          break;
        case TextDirection.ltr:
          _positionController.value += delta;
          break;
      }
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    // Deferring the animation to the next build phase.
    setState(() { needsPositionAnimation = true; });
    // Call onChanged when the user's intent to change value is clear.
    if (position.value >= 0.5 != widget.value) {
      widget.onChanged!(!widget.value);
    }
    _reactionController.reverse();
  }

  void _emitVibration() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        HapticFeedback.lightImpact();
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (needsPositionAnimation) {
      _resumePositionAnimation();
    }
    return MouseRegion(
      cursor: isInteractive && kIsWeb ? SystemMouseCursors.click : MouseCursor.defer,
      child: Opacity(
        opacity: widget.onChanged == null ? _kCupertinoSwitchDisabledOpacity : 1.0,
        child: _CupertinoSwitchRenderObjectWidget(
          value: widget.value,
          activeColor: CupertinoDynamicColor.resolve(
            widget.activeColor ?? CupertinoColors.systemGreen,
            context,
          ),
          activeGradient: widget.activeGradient,
          trackColor: CupertinoDynamicColor.resolve(widget.trackColor ?? CupertinoColors.secondarySystemFill, context),
          thumbColor: CupertinoDynamicColor.resolve(widget.thumbColor ?? CupertinoColors.white, context),
          onChanged: widget.onChanged,
          textDirection: Directionality.of(context),
          state: this,
          switchWidth: widget.switchWidth,
          switchHeight: widget.switchHeight,
          switchPadding: widget.switchPadding,
          trackPadding: widget.trackPadding,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tap.dispose();
    _drag.dispose();

    _positionController.dispose();
    _reactionController.dispose();
    super.dispose();
  }
}

class _CupertinoSwitchRenderObjectWidget extends LeafRenderObjectWidget {
  const _CupertinoSwitchRenderObjectWidget({
    Key? key,
    required this.value,
    required this.activeColor,
    required this.activeGradient,
    required this.trackColor,
    required this.thumbColor,
    required this.onChanged,
    required this.textDirection,
    required this.state,
    required this.switchWidth,
    required this.switchHeight,
    required this.switchPadding,
    required this.trackPadding,
  }) : super(key: key);

  final bool value;
  final Color activeColor;
  final Gradient? activeGradient;
  final Color trackColor;
  final Color thumbColor;
  final ValueChanged<bool>? onChanged;
  final _CupertinoSwitchState state;
  final TextDirection textDirection;

  /// Switch整体的宽高
  final double switchWidth;
  final double switchHeight;
  final EdgeInsetsGeometry switchPadding;
  final EdgeInsetsGeometry trackPadding;

  @override
  _RenderCupertinoSwitch createRenderObject(BuildContext context) {
    return _RenderCupertinoSwitch(
      value: value,
      activeColor: activeColor,
      activeGradient: activeGradient,
      trackColor: trackColor,
      thumbColor: thumbColor,
      onChanged: onChanged,
      textDirection: textDirection,
      state: state,
      switchWidth: switchWidth,
      switchHeight: switchHeight,
      switchPadding: switchPadding.resolve(textDirection),
      trackPadding: trackPadding.resolve(textDirection),
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderCupertinoSwitch renderObject) {
    renderObject
      ..value = value
      ..activeColor = activeColor
      ..activeGradient = activeGradient
      ..trackColor = trackColor
      ..thumbColor = thumbColor
      ..onChanged = onChanged
      ..textDirection = textDirection
      ..switchWidth = switchWidth
      ..switchHeight = switchHeight
      ..switchPadding = switchPadding.resolve(Directionality.of(context))
      ..trackPadding = trackPadding.resolve(Directionality.of(context))
    ;
  }
}

// Opacity of a disabled switch, as eye-balled from iOS Simulator on Mac.
const double _kCupertinoSwitchDisabledOpacity = 0.5;

const Duration _kReactionDuration = Duration(milliseconds: 300);
const Duration _kToggleDuration = Duration(milliseconds: 200);

class _RenderCupertinoSwitch extends RenderConstrainedBox {


  _RenderCupertinoSwitch({
    required bool value,
    required Color activeColor,
    Gradient? activeGradient,
    required Color trackColor,
    required Color thumbColor,
    ValueChanged<bool>? onChanged,
    required TextDirection textDirection,
    required _CupertinoSwitchState state,
    required double switchWidth,
    required double switchHeight,
    required EdgeInsets switchPadding,
    required EdgeInsets trackPadding,
  })  : _value = value,
        _activeColor = activeColor,
        _activeGradient = activeGradient,
        _trackColor = trackColor,
        _thumbPainter = CupertinoThumbPainter.switchThumb(color: thumbColor),
        _onChanged = onChanged,
        _textDirection = textDirection,
        _state = state,
        _switchWidth = switchWidth,
        _switchHeight = switchHeight,
        _switchPadding = switchPadding,
        _trackPadding = trackPadding,
        super(additionalConstraints: BoxConstraints.tightFor(width: switchWidth, height: switchHeight)) {
         state.position.addListener(markNeedsPaint);
         state._reaction.addListener(markNeedsPaint);
  }

  double _switchWidth;
  double get switchWidth => _switchWidth;
  set switchWidth(double value) {
    if (value == _switchWidth) {
      return;
    }
    _switchWidth = value;
    additionalConstraints = BoxConstraints.tightFor(width: _switchWidth, height: switchHeight);
    markNeedsLayout();
  }

  double _switchHeight;
  double get switchHeight => _switchHeight;
  set switchHeight(double value) {
    if (value == _switchHeight) {
      return;
    }
    _switchHeight = value;
    additionalConstraints = BoxConstraints.tightFor(width: _switchWidth, height: switchHeight);
    markNeedsLayout();
  }

  EdgeInsets _switchPadding;
  EdgeInsets get switchPadding => _switchPadding;
  set switchPadding(EdgeInsets value) {
    if (value == _switchPadding) {
      return;
    }
    _switchPadding = value;
    markNeedsPaint();
  }

  EdgeInsets _trackPadding;
  EdgeInsets get trackPadding => _trackPadding;
  set trackPadding(EdgeInsets value) {
    if (value == _trackPadding) {
      return;
    }
    _trackPadding = value;
    markNeedsPaint();
  }


  final _CupertinoSwitchState _state;

  bool get value => _value;
  bool _value;
  set value(bool value) {
    if (value == _value) {
      return;
    }
    _value = value;
    markNeedsSemanticsUpdate();
  }

  Color get activeColor => _activeColor;
  Color _activeColor;
  set activeColor(Color value) {
    if (value == _activeColor) {
      return;
    }
    _activeColor = value;
    markNeedsPaint();
  }

  Gradient? _activeGradient;
  Gradient? get activeGradient => _activeGradient;
  set activeGradient(Gradient? value) {
    if (value == _activeGradient) {
      return;
    }
    _activeGradient = value;
    markNeedsPaint();
  }

  Color get trackColor => _trackColor;
  Color _trackColor;
  set trackColor(Color value) {
    if (value == _trackColor) {
      return;
    }
    _trackColor = value;
    markNeedsPaint();
  }

  Color get thumbColor => _thumbPainter.color;
  CupertinoThumbPainter _thumbPainter;
  set thumbColor(Color value) {
    if (value == thumbColor) {
      return;
    }
    _thumbPainter = CupertinoThumbPainter.switchThumb(color: value);
    markNeedsPaint();
  }

  ValueChanged<bool>? get onChanged => _onChanged;
  ValueChanged<bool>? _onChanged;
  set onChanged(ValueChanged<bool>? value) {
    if (value == _onChanged) {
      return;
    }
    final bool wasInteractive = isInteractive;
    _onChanged = value;
    if (wasInteractive != isInteractive) {
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsPaint();
  }

  bool get isInteractive => onChanged != null;

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent && isInteractive) {
      _state._drag.addPointer(event);
      _state._tap.addPointer(event);
    }
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    if (isInteractive) {
      config.onTap = _state._handleTap;
    }

    config.isEnabled = isInteractive;
    config.isToggled = _value;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;

    final double currentValue = _state.position.value;
    final double currentReactionValue = _state._reaction.value;

    final double visualPosition;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - currentValue;
        break;
      case TextDirection.ltr:
        visualPosition = currentValue;
        break;
    }

    final Paint paint = Paint();

    final trackWidth = switchWidth - switchPadding.horizontal;
    final trackHeight = switchHeight - switchPadding.vertical;
    final Rect trackRect = Rect.fromLTWH(
        offset.dx + switchPadding.left,
        offset.dy + switchPadding.top,
        trackWidth,
        trackHeight,
    );
    final trackRadius = trackHeight / 2.0;
    final RRect trackRRect = RRect.fromRectAndRadius(trackRect, Radius.circular(trackRadius));
    final gradient = activeGradient;
    if (gradient != null) {
      /// 处理背景渐变色
      final trackerGradient = _copyGradient(gradient, trackColor);
      //paint.color = const Color(0xFFFFFFFF);
      paint.shader = Gradient.lerp(trackerGradient, gradient, currentValue)!
          .createShader(trackRect, textDirection: textDirection);
    } else {
      paint.color = Color.lerp(trackColor, activeColor, currentValue)!;
    }
    canvas.drawRRect(trackRRect, paint);

    final thumbRadius = (trackHeight - trackPadding.vertical) / 2;
    final thumbStart = trackRect.left + trackPadding.left;
    final thumbEnd = trackRect.right - trackPadding.right;
    final thumbExtension = 7 / 20 * (trackWidth - trackPadding.horizontal - thumbRadius * 2);
    final double currentThumbExtension = thumbExtension * currentReactionValue;
    final double thumbLeft = lerpDouble(
      thumbStart,
      thumbEnd - thumbRadius * 2 - currentThumbExtension,
      visualPosition,
    )!;
    final double thumbRight = lerpDouble(
      thumbStart + thumbRadius * 2 + currentThumbExtension,
      thumbEnd,
      visualPosition,
    )!;
    final double thumbCenterY = offset.dy + size.height / 2.0;
    final Rect thumbBounds = Rect.fromLTRB(
      thumbLeft,
      thumbCenterY - thumbRadius,
      thumbRight,
      thumbCenterY + thumbRadius,
    );

    _clipRRectLayer.layer = context
        .pushClipRRect(needsCompositing, Offset.zero, thumbBounds, trackRRect,
            (PaintingContext innerContext, Offset offset) {
      _thumbPainter.paint(innerContext.canvas, thumbBounds);
    }, oldLayer: _clipRRectLayer.layer);
  }

  final LayerHandle<ClipRRectLayer> _clipRRectLayer = LayerHandle<ClipRRectLayer>();

  Gradient _copyGradient(Gradient gradient, Color color) {
    final Gradient trackerGradient;
    final colors = List.filled(gradient.colors.length, color);
    if (gradient is LinearGradient) {
      trackerGradient = LinearGradient(
        colors: colors,
        stops: gradient.stops,
        begin: gradient.begin,
        end: gradient.end,
        tileMode: gradient.tileMode,
      );
    } else if (gradient is RadialGradient) {
      trackerGradient = RadialGradient(
        colors: colors,
        stops: gradient.stops,
        center: gradient.center,
        radius: gradient.radius,
        tileMode: gradient.tileMode,
      );
    } else if (gradient is SweepGradient) {
      trackerGradient = SweepGradient(
        colors: colors,
        stops: gradient.stops,
        center: gradient.center,
        startAngle: gradient.startAngle,
        endAngle: gradient.endAngle,
        tileMode: gradient.tileMode,
      );
    } else {
      throw UnimplementedError('Gradient type ${gradient.runtimeType} is not supported');
    }
    return trackerGradient;
  }

  @override
  void dispose() {
    _clipRRectLayer.layer = null;
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(FlagProperty('value', value: value, ifTrue: 'checked', ifFalse: 'unchecked', showName: true));
    description.add(FlagProperty('isInteractive', value: isInteractive, ifTrue: 'enabled', ifFalse: 'disabled', showName: true, defaultValue: true));
  }
}
