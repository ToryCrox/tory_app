import 'dart:math' as math;

import 'package:common/common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 拷贝自 [ListTile]，目标是自适应高度，更高的定制自由度
/// 去掉dense和visualDensity
/// - 去掉icon的大小限制
/// - 去掉minLeadingWidth
class LiteListTile extends StatelessWidget {
  /// Creates a list tile.
  ///
  /// If [isThreeLine] is true, then [subtitle] must not be null.
  ///
  /// Requires one of its ancestors to be a [Material] widget.
  const LiteListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.isThreeLine = false,
    this.shape,
    this.style,
    this.selectedColor,
    this.iconColor,
    this.textColor,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.mouseCursor,
    this.selected = false,
    this.focusColor,
    this.hoverColor,
    this.focusNode,
    this.autofocus = false,
    this.tileColor,
    this.selectedTileColor,
    this.enableFeedback,
    this.horizontalTitleGap,
    this.horizontalTrailGap,
    this.minVerticalPadding,
    this.minTileHeight = 56,
    this.verticalTitlePadding = 0,
    this.elevation = 0,
  }) : assert(!isThreeLine || subtitle != null);

  /// A widget to display before the title.
  ///
  /// Typically an [Icon] or a [CircleAvatar] widget.
  final Widget? leading;

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  ///
  /// This should not wrap. To enforce the single line limit, use
  /// [Text.maxLines].
  final Widget? title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  ///
  /// If [isThreeLine] is false, this should not wrap.
  ///
  /// If [isThreeLine] is true, this should be configured to take a maximum of
  /// two lines. For example, you can use [Text.maxLines] to enforce the number
  /// of lines.
  ///
  /// The subtitle's default [TextStyle] depends on [TextTheme.bodyText2] except
  /// [TextStyle.color]. The [TextStyle.color] depends on the value of [enabled]
  /// and [selected].
  ///
  /// When [enabled] is false, the text color is set to [ThemeData.disabledColor].
  ///
  /// When [selected] is false, the text color is set to [ListTileTheme.textColor]
  /// if it's not null and to [TextTheme.caption]'s color if [ListTileTheme.textColor]
  /// is null.
  final Widget? subtitle;

  /// A widget to display after the title.
  ///
  /// Typically an [Icon] widget.
  ///
  /// To show right-aligned metadata (assuming left-to-right reading order;
  /// left-aligned for right-to-left reading order), consider using a [Row] with
  /// [CrossAxisAlignment.baseline] alignment whose first item is [Expanded] and
  /// whose second child is the metadata text, instead of using the [trailing]
  /// property.
  final Widget? trailing;

  /// Whether this list tile is intended to display three lines of text.
  ///
  /// If true, then [subtitle] must be non-null (since it is expected to give
  /// the second and third lines of text).
  ///
  /// If false, the list tile is treated as having one line if the subtitle is
  /// null and treated as having two lines if the subtitle is non-null.
  ///
  /// When using a [Text] widget for [title] and [subtitle], you can enforce
  /// line limits using [Text.maxLines].
  final bool isThreeLine;

  /// {@template flutter.material.ListTile.shape}
  /// Defines the tile's [InkWell.customBorder] and [Ink.decoration] shape.
  /// {@endtemplate}
  ///
  /// If this property is null then [ListTileThemeData.shape] is used. If that
  /// is also null then a rectangular [Border] will be used.
  ///
  /// See also:
  ///
  /// * [ListTileTheme.of], which returns the nearest [ListTileTheme]'s
  ///   [ListTileThemeData].
  final ShapeBorder? shape;

  /// Defines the color used for icons and text when the list tile is selected.
  ///
  /// If this property is null then [ListTileThemeData.selectedColor]
  /// is used. If that is also null then [ColorScheme.primary] is used.
  ///
  /// See also:
  ///
  /// * [ListTileTheme.of], which returns the nearest [ListTileTheme]'s
  ///   [ListTileThemeData].
  final Color? selectedColor;

  /// Defines the default color for [leading] and [trailing] icons.
  ///
  /// If this property is null then [ListTileThemeData.iconColor] is used.
  ///
  /// See also:
  ///
  /// * [ListTileTheme.of], which returns the nearest [ListTileTheme]'s
  ///   [ListTileThemeData].
  final Color? iconColor;

  /// Defines the default color for the [title] and [subtitle].
  ///
  /// If this property is null then [ListTileThemeData.textColor] is used. If that
  /// is also null then [ColorScheme.primary] is used.
  ///
  /// See also:
  ///
  /// * [ListTileTheme.of], which returns the nearest [ListTileTheme]'s
  ///   [ListTileThemeData].
  final Color? textColor;

  /// Defines the font used for the [title].
  ///
  /// If this property is null then [ListTileThemeData.style] is used. If that
  /// is also null then [ListTileStyle.list] is used.
  ///
  /// See also:
  ///
  /// * [ListTileTheme.of], which returns the nearest [ListTileTheme]'s
  ///   [ListTileThemeData].
  final ListTileStyle? style;

  /// The tile's internal padding.
  ///
  /// Insets a [ListTile]'s contents: its [leading], [title], [subtitle],
  /// and [trailing] widgets.
  ///
  /// If null, `EdgeInsets.symmetric(horizontal: 16.0)` is used.
  final EdgeInsetsGeometry? contentPadding;

  /// Whether this list tile is interactive.
  ///
  /// If false, this list tile is styled with the disabled color from the
  /// current [Theme] and the [onTap] and [onLongPress] callbacks are
  /// inoperative.
  final bool enabled;

  /// Called when the user taps this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final GestureTapCallback? onTap;

  /// Called when the user long-presses on this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final GestureLongPressCallback? onLongPress;

  /// {@template flutter.material.ListTile.mouseCursor}
  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  ///
  /// If [mouseCursor] is a [MaterialStateProperty<MouseCursor>],
  /// [MaterialStateProperty.resolve] is used for the following [MaterialState]s:
  ///
  ///  * [MaterialState.selected].
  ///  * [MaterialState.disabled].
  /// {@endtemplate}
  ///
  /// If null, then the value of [ListTileThemeData.mouseCursor] is used. If
  /// that is also null, then [MaterialStateMouseCursor.clickable] is used.
  ///
  /// See also:
  ///
  ///  * [MaterialStateMouseCursor], which can be used to create a [MouseCursor]
  ///    that is also a [MaterialStateProperty<MouseCursor>].
  final MouseCursor? mouseCursor;

  /// If this tile is also [enabled] then icons and text are rendered with the same color.
  ///
  /// By default the selected color is the theme's primary color. The selected color
  /// can be overridden with a [ListTileTheme].
  ///
  /// {@tool dartpad}
  /// Here is an example of using a [StatefulWidget] to keep track of the
  /// selected index, and using that to set the `selected` property on the
  /// corresponding [ListTile].
  ///
  /// ** See code in examples/api/lib/material/list_tile/list_tile.selected.0.dart **
  /// {@end-tool}
  final bool selected;

  /// The color for the tile's [Material] when it has the input focus.
  final Color? focusColor;

  /// The color for the tile's [Material] when a pointer is hovering over it.
  final Color? hoverColor;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@template flutter.material.ListTile.tileColor}
  /// Defines the background color of `ListTile` when [selected] is false.
  ///
  /// When the value is null, the `tileColor` is set to [ListTileTheme.tileColor]
  /// if it's not null and to [Colors.transparent] if it's null.
  /// {@endtemplate}
  final Color? tileColor;

  /// Defines the background color of `ListTile` when [selected] is true.
  ///
  /// When the value if null, the `selectedTileColor` is set to [ListTileTheme.selectedTileColor]
  /// if it's not null and to [Colors.transparent] if it's null.
  final Color? selectedTileColor;

  /// {@template flutter.material.ListTile.enableFeedback}
  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a
  /// long-press will produce a short vibration, when feedback is enabled.
  ///
  /// When null, the default value is true.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  final bool? enableFeedback;

  /// The horizontal gap between the titles and the leading/trailing widgets.
  ///
  /// If null, then the value of [ListTileTheme.horizontalTitleGap] is used. If
  /// that is also null, then a default value of 16 is used.
  final double? horizontalTitleGap;


  /// title和trail的间隙，默认与horizontalTitleGap相同
  final double? horizontalTrailGap;

  /// The minimum padding on the top and bottom of the title and subtitle widgets.
  ///
  /// If null, then the value of [ListTileTheme.minVerticalPadding] is used. If
  /// that is also null, then a default value of 4 is used.
  final double? minVerticalPadding;

  /// 默认最小高度
  final double minTileHeight;

  /// title和subTitle的间距
  final double verticalTitlePadding;

  /// 阴影深度
  final double elevation;

  /// Add a one pixel border in between each tile. If color isn't specified the
  /// [ThemeData.dividerColor] of the context's [Theme] is used.
  ///
  /// See also:
  ///
  ///  * [Divider], which you can use to obtain this effect manually.
  static Iterable<Widget> divideTiles({ BuildContext? context, required Iterable<Widget> tiles, Color? color }) {
    assert(tiles != null);
    assert(color != null || context != null);
    tiles = tiles.toList();

    if (tiles.isEmpty || tiles.length == 1) {
      return tiles;
    }

    Widget wrapTile(Widget tile) {
      return DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          border: Border(
            bottom: Divider.createBorderSide(context, color: color),
          ),
        ),
        child: tile,
      );
    }

    return <Widget>[
      ...tiles.take(tiles.length - 1).map(wrapTile),
      tiles.last,
    ];
  }

  Color? _iconColor(ThemeData theme, ListTileThemeData tileTheme) {
    if (!enabled) {
      return theme.disabledColor;
    }

    if (selected) {
      return selectedColor ?? tileTheme.selectedColor ?? theme.listTileTheme.selectedColor ?? theme.colorScheme.primary;
    }

    final Color? color = iconColor ?? tileTheme.iconColor ?? theme.listTileTheme.iconColor;
    if (color != null) {
      return color;
    }

    switch (theme.brightness) {
      case Brightness.light:
      // For the sake of backwards compatibility, the default for unselected
      // tiles is Colors.black45 rather than colorScheme.onSurface.withAlpha(0x73).
        return Colors.black45;
      case Brightness.dark:
        return null; // null - use current icon theme color
    }
  }

  Color? _textColor(ThemeData theme, ListTileThemeData tileTheme, Color? defaultColor) {
    if (!enabled) {
      return theme.disabledColor;
    }

    if (selected) {
      return selectedColor ?? tileTheme.selectedColor ?? theme.listTileTheme.selectedColor ?? theme.colorScheme.primary;
    }

    return textColor ?? tileTheme.textColor ?? theme.listTileTheme.textColor ?? defaultColor;
  }

  TextStyle _titleTextStyle(ThemeData theme, ListTileThemeData tileTheme) {
    final TextStyle textStyle;
    switch(style ?? tileTheme.style ?? theme.listTileTheme.style ?? ListTileStyle.list) {
      case ListTileStyle.drawer:
        textStyle = theme.useMaterial3 ? theme.textTheme.bodyMedium! : theme.textTheme.bodyText1!;
        break;
      case ListTileStyle.list:
        textStyle = theme.useMaterial3 ? theme.textTheme.titleMedium! : theme.textTheme.subtitle1!;
        break;
    }
    final Color? color = _textColor(theme, tileTheme, textStyle.color);
    return  textStyle.copyWith(color: color);
  }

  TextStyle _subtitleTextStyle(ThemeData theme, ListTileThemeData tileTheme) {
    final TextStyle textStyle = theme.useMaterial3 ? theme.textTheme.bodyMedium! : theme.textTheme.bodyText2!;
    final Color? color = _textColor(
      theme,
      tileTheme,
      theme.useMaterial3 ? theme.textTheme.bodySmall!.color : theme.textTheme.caption!.color,
    );
    return  textStyle.copyWith(color: color);
  }

  TextStyle _trailingAndLeadingTextStyle(ThemeData theme, ListTileThemeData tileTheme) {
    final TextStyle textStyle = theme.useMaterial3 ? theme.textTheme.bodyMedium! : theme.textTheme.bodyText2!;
    final Color? color = _textColor(theme, tileTheme, textStyle.color);
    return textStyle.copyWith(color: color);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final ThemeData theme = Theme.of(context);
    final ListTileThemeData tileTheme = ListTileTheme.of(context);
    final IconThemeData iconThemeData = IconThemeData(color: _iconColor(theme, tileTheme));

    TextStyle? leadingAndTrailingTextStyle;
    if (leading != null || trailing != null) {
      leadingAndTrailingTextStyle = _trailingAndLeadingTextStyle(theme, tileTheme);
    }

    Widget? leadingIcon;
    if (leading != null) {
      leadingIcon = AnimatedDefaultTextStyle(
        style: leadingAndTrailingTextStyle!,
        duration: kThemeChangeDuration,
        child: leading!,
      );
    }

    final TextStyle titleStyle = _titleTextStyle(theme, tileTheme);
    final Widget titleText = AnimatedDefaultTextStyle(
      style: titleStyle,
      duration: kThemeChangeDuration,
      child: title ?? const SizedBox(),
    );

    Widget? subtitleText;
    TextStyle? subtitleStyle;
    if (subtitle != null) {
      subtitleStyle = _subtitleTextStyle(theme, tileTheme);
      subtitleText = AnimatedDefaultTextStyle(
        style: subtitleStyle,
        duration: kThemeChangeDuration,
        child: subtitle!,
      );
    }

    Widget? trailingIcon;
    if (trailing != null) {
      trailingIcon = AnimatedDefaultTextStyle(
        style: leadingAndTrailingTextStyle!,
        duration: kThemeChangeDuration,
        child: trailing!,
      );
    }

    const EdgeInsets defaultContentPadding = EdgeInsets.symmetric(horizontal: 16.0);
    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets resolvedContentPadding = contentPadding?.resolve(textDirection)
        ?? tileTheme.contentPadding?.resolve(textDirection)
        ?? defaultContentPadding;

    final Set<MaterialState> states = <MaterialState>{
      if (!enabled || (onTap == null && onLongPress == null)) MaterialState.disabled,
      if (selected) MaterialState.selected,
    };

    final MouseCursor effectiveMouseCursor = MaterialStateProperty.resolveAs<MouseCursor?>(mouseCursor, states)
        ?? tileTheme.mouseCursor?.resolve(states)
        ?? MaterialStateMouseCursor.clickable.resolve(states);
    final horizontalTitleGap = this.horizontalTitleGap ?? tileTheme.horizontalTitleGap ?? 16;
    return ThrottleInkWell(
      shape: shape ?? tileTheme.shape,
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      mouseCursor: effectiveMouseCursor,
      hoverColor: hoverColor,
      enableFeedback: enableFeedback ?? tileTheme.enableFeedback ?? true,
      elevation: elevation,
      child: Semantics(
        selected: selected,
        enabled: enabled,
        child: SafeArea(
          top: false,
          bottom: false,
          minimum: resolvedContentPadding,
          child: IconTheme.merge(
            data: iconThemeData,
            child: _ListTile(
              leading: leadingIcon,
              title: titleText,
              subtitle: subtitleText,
              trailing: trailingIcon,
              isThreeLine: isThreeLine,
              textDirection: textDirection,
              titleBaselineType: titleStyle.textBaseline!,
              subtitleBaselineType: subtitleStyle?.textBaseline,
              horizontalTitleGap: horizontalTitleGap,
              horizontalTrailGap: horizontalTrailGap ?? horizontalTitleGap,
              minVerticalPadding: minVerticalPadding ?? tileTheme.minVerticalPadding ?? 4,
              minTileHeight: math.max(0, minTileHeight - resolvedContentPadding.vertical),
              verticalTitlePadding: verticalTitlePadding,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Widget>('leading', leading, defaultValue: null));
    properties.add(DiagnosticsProperty<Widget>('title', title, defaultValue: null));
    properties.add(DiagnosticsProperty<Widget>('subtitle', subtitle, defaultValue: null));
    properties.add(DiagnosticsProperty<Widget>('trailing', trailing, defaultValue: null));
    properties.add(FlagProperty('isThreeLine', value: isThreeLine, ifTrue:'THREE_LINE', ifFalse: 'TWO_LINE', showName: true, defaultValue: false));
    properties.add(DiagnosticsProperty<ShapeBorder>('shape', shape, defaultValue: null));
    properties.add(DiagnosticsProperty<ListTileStyle>('style', style, defaultValue: null));
    properties.add(ColorProperty('selectedColor', selectedColor, defaultValue: null));
    properties.add(ColorProperty('iconColor', iconColor, defaultValue: null));
    properties.add(ColorProperty('textColor', textColor, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('contentPadding', contentPadding, defaultValue: null));
    properties.add(FlagProperty('enabled', value: enabled, ifTrue: 'true', ifFalse: 'false', showName: true, defaultValue: true));
    properties.add(DiagnosticsProperty<Function>('onTap', onTap, defaultValue: null));
    properties.add(DiagnosticsProperty<Function>('onLongPress', onLongPress, defaultValue: null));
    properties.add(DiagnosticsProperty<MouseCursor>('mouseCursor', mouseCursor, defaultValue: null));
    properties.add(FlagProperty('selected', value: selected, ifTrue: 'true', ifFalse: 'false', showName: true, defaultValue: false));
    properties.add(ColorProperty('focusColor', focusColor, defaultValue: null));
    properties.add(ColorProperty('hoverColor', hoverColor, defaultValue: null));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode, defaultValue: null));
    properties.add(FlagProperty('autofocus', value: autofocus, ifTrue: 'true', ifFalse: 'false', showName: true, defaultValue: false));
    properties.add(ColorProperty('tileColor', tileColor, defaultValue: null));
    properties.add(ColorProperty('selectedTileColor', selectedTileColor, defaultValue: null));
    properties.add(FlagProperty('enableFeedback', value: enableFeedback, ifTrue: 'true', ifFalse: 'false', showName: true));
    properties.add(DoubleProperty('horizontalTitleGap', horizontalTitleGap, defaultValue: null));
    properties.add(DoubleProperty('minVerticalPadding', minVerticalPadding, defaultValue: null));
  }
}

// Identifies the children of a _ListTileElement.
enum _ListTileSlot {
  leading,
  title,
  subtitle,
  trailing,
}

class _ListTile extends RenderObjectWidget with SlottedMultiChildRenderObjectWidgetMixin<_ListTileSlot> {
  const _ListTile({
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.isThreeLine,
    required this.textDirection,
    required this.titleBaselineType,
    required this.horizontalTitleGap,
    required this.horizontalTrailGap,
    required this.minVerticalPadding,
    this.subtitleBaselineType,
    required this.minTileHeight,
    required this.verticalTitlePadding,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool isThreeLine;
  final TextDirection textDirection;
  final TextBaseline titleBaselineType;
  final TextBaseline? subtitleBaselineType;
  final double horizontalTitleGap;
  final double horizontalTrailGap;
  final double minVerticalPadding;
  final double minTileHeight;
  final double verticalTitlePadding;

  @override
  Iterable<_ListTileSlot> get slots => _ListTileSlot.values;

  @override
  Widget? childForSlot(_ListTileSlot slot) {
    switch (slot) {
      case _ListTileSlot.leading:
        return leading;
      case _ListTileSlot.title:
        return title;
      case _ListTileSlot.subtitle:
        return subtitle;
      case _ListTileSlot.trailing:
        return trailing;
    }
  }

  @override
  _RenderListTile createRenderObject(BuildContext context) {
    return _RenderListTile(
      isThreeLine: isThreeLine,
      textDirection: textDirection,
      titleBaselineType: titleBaselineType,
      subtitleBaselineType: subtitleBaselineType,
      horizontalTitleGap: horizontalTitleGap,
      horizontalTrailGap: horizontalTrailGap,
      minVerticalPadding: minVerticalPadding,
      minTileHeight: minTileHeight,
      verticalTitlePadding: verticalTitlePadding,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderListTile renderObject) {
    renderObject
      ..isThreeLine = isThreeLine
      ..textDirection = textDirection
      ..titleBaselineType = titleBaselineType
      ..subtitleBaselineType = subtitleBaselineType
      ..horizontalTitleGap = horizontalTitleGap
      ..minVerticalPadding = minVerticalPadding
      ..minTileHeight = minTileHeight
      ..verticalTitlePadding = verticalTitlePadding
      ..horizontalTrailGap = horizontalTrailGap;
  }
}

class _RenderListTile extends RenderBox with SlottedContainerRenderObjectMixin<_ListTileSlot> {
  _RenderListTile({
    required bool isThreeLine,
    required TextDirection textDirection,
    required TextBaseline titleBaselineType,
    TextBaseline? subtitleBaselineType,
    required double horizontalTitleGap,
    required double horizontalTrailGap,
    required double minVerticalPadding,
    required double minTileHeight,
    required double verticalTitlePadding,
  }) : _isThreeLine = isThreeLine,
        _textDirection = textDirection,
        _titleBaselineType = titleBaselineType,
        _subtitleBaselineType = subtitleBaselineType,
        _horizontalTitleGap = horizontalTitleGap,
        _horizontalTrailGap = horizontalTrailGap,
        _minVerticalPadding = minVerticalPadding,
        _minTileHeight = minTileHeight,
        _verticalTitlePadding = verticalTitlePadding;

  RenderBox? get leading => childForSlot(_ListTileSlot.leading);
  RenderBox? get title => childForSlot(_ListTileSlot.title);
  RenderBox? get subtitle => childForSlot(_ListTileSlot.subtitle);
  RenderBox? get trailing => childForSlot(_ListTileSlot.trailing);

  // The returned list is ordered for hit testing.
  @override
  Iterable<RenderBox> get children {
    return <RenderBox>[
      if (leading != null)
        leading!,
      if (title != null)
        title!,
      if (subtitle != null)
        subtitle!,
      if (trailing != null)
        trailing!,
    ];
  }

  double _minTileHeight;
  double get minTileHeight => _minTileHeight;
  set minTileHeight(double value) {
    if (_minTileHeight == value) {
      return;
    }
    _minTileHeight = value;
    markNeedsLayout();
  }

  double _verticalTitlePadding;
  double get verticalTitlePadding => _verticalTitlePadding;
  set verticalTitlePadding(double value) {
    if (_verticalTitlePadding == value) {
      return;
    }
    _verticalTitlePadding = value;
    markNeedsLayout();
  }


  bool get isThreeLine => _isThreeLine;
  bool _isThreeLine;
  set isThreeLine(bool value) {
    assert(value != null);
    if (_isThreeLine == value) {
      return;
    }
    _isThreeLine = value;
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    assert(value != null);
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  TextBaseline get titleBaselineType => _titleBaselineType;
  TextBaseline _titleBaselineType;
  set titleBaselineType(TextBaseline value) {
    assert(value != null);
    if (_titleBaselineType == value) {
      return;
    }
    _titleBaselineType = value;
    markNeedsLayout();
  }

  TextBaseline? get subtitleBaselineType => _subtitleBaselineType;
  TextBaseline? _subtitleBaselineType;
  set subtitleBaselineType(TextBaseline? value) {
    if (_subtitleBaselineType == value) {
      return;
    }
    _subtitleBaselineType = value;
    markNeedsLayout();
  }

  double get horizontalTitleGap => _horizontalTitleGap;
  double _horizontalTitleGap;
  double get _effectiveHorizontalTitleGap => _horizontalTitleGap;

  set horizontalTitleGap(double value) {
    if (_horizontalTitleGap == value) {
      return;
    }
    _horizontalTitleGap = value;
    markNeedsLayout();
  }

  double _horizontalTrailGap;
  double get horizontalTrailGap => _horizontalTrailGap;
  set horizontalTrailGap(double value) {
    if (_horizontalTrailGap == value) {
      return;
    }
    _horizontalTrailGap = value;
    markNeedsLayout();
  }

  double get minVerticalPadding => _minVerticalPadding;
  double _minVerticalPadding;

  set minVerticalPadding(double value) {
    assert(value != null);
    if (_minVerticalPadding == value) {
      return;
    }
    _minVerticalPadding = value;
    markNeedsLayout();
  }

  @override
  bool get sizedByParent => false;

  static double _minWidth(RenderBox? box, double height) {
    return box == null ? 0.0 : box.getMinIntrinsicWidth(height);
  }

  static double _maxWidth(RenderBox? box, double height) {
    return box == null ? 0.0 : box.getMaxIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final double leadingWidth = leading != null
        ? leading!.getMinIntrinsicWidth(height) + _effectiveHorizontalTitleGap
        : 0.0;
    return leadingWidth
        + math.max(_minWidth(title, height), _minWidth(subtitle, height))
        + _maxWidth(trailing, height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final double leadingWidth = leading != null
        ? leading!.getMaxIntrinsicWidth(height) + _effectiveHorizontalTitleGap
        : 0.0;
    return leadingWidth
        + math.max(_maxWidth(title, height), _maxWidth(subtitle, height))
        + _maxWidth(trailing, height);
  }


  @override
  double computeMinIntrinsicHeight(double width) {
    final double leadingHeight = leading != null
        ? leading!.getMinIntrinsicHeight(width)
        : 0.0;
    final double titleHeight = title != null ? title!.getMinIntrinsicHeight(width) : 0.0;
    final double subtitleHeight = subtitle != null ? subtitle!.getMinIntrinsicHeight(width) : 0.0;
    final double middleHeight = titleHeight +
        subtitleHeight +
        _verticalTitlePadding * 2 +
        (subtitleHeight > 0.0 ? verticalTitlePadding : 0.0);
    final double trailingHeight = trailing != null ? trailing!.getMinIntrinsicHeight(width) : 0.0;
    return [minTileHeight, leadingHeight, middleHeight, trailingHeight].max;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeMinIntrinsicHeight(width);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(title != null);
    final BoxParentData parentData = title!.parentData! as BoxParentData;
    return parentData.offset.dy + title!.getDistanceToActualBaseline(baseline)!;
  }

  static double? _boxBaseline(RenderBox box, TextBaseline baseline) {
    return box.getDistanceToBaseline(baseline);
  }

  static Size _layoutBox(RenderBox? box, BoxConstraints constraints) {
    if (box == null) {
      return Size.zero;
    }
    box.layout(constraints, parentUsesSize: true);
    return box.size;
  }

  static void _positionBox(RenderBox box, Offset offset) {
    final BoxParentData parentData = box.parentData! as BoxParentData;
    parentData.offset = offset;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    assert(debugCannotComputeDryLayout(
      reason: 'Layout requires baseline metrics, which are only available after a full layout.',
    ));
    return Size.zero;
  }

  // All of the dimensions below were taken from the Material Design spec:
  // https://material.io/design/components/lists.html#specs
  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final bool hasLeading = leading != null;
    final bool hasSubtitle = subtitle != null;
    final bool hasTrailing = trailing != null;

    final BoxConstraints looseConstraints = constraints.loosen();

    final double tileWidth = looseConstraints.maxWidth;
    final Size leadingSize = _layoutBox(leading, looseConstraints);
    final Size trailingSize = _layoutBox(trailing, looseConstraints);
    assert(
    tileWidth != leadingSize.width || tileWidth == 0.0,
    'Leading widget consumes entire tile width. Please use a sized widget, '
        'or consider replacing ListTile with a custom widget '
        '(see https://api.flutter.dev/flutter/material/ListTile-class.html#material.ListTile.4)',
    );
    assert(
    tileWidth != trailingSize.width || tileWidth == 0.0,
    'Trailing widget consumes entire tile width. Please use a sized widget, '
        'or consider replacing ListTile with a custom widget '
        '(see https://api.flutter.dev/flutter/material/ListTile-class.html#material.ListTile.4)',
    );

    final double titleStart = hasLeading
        ? leadingSize.width + _effectiveHorizontalTitleGap
        : 0.0;
    final double adjustedTrailingWidth = hasTrailing
        ? trailingSize.width + _horizontalTrailGap
        : 0.0;
    final BoxConstraints textConstraints = looseConstraints.tighten(
      width: tileWidth - titleStart - adjustedTrailingWidth,
    );
    final Size titleSize = _layoutBox(title, textConstraints);
    final Size subtitleSize = _layoutBox(subtitle, textConstraints);


    final middleHeight = titleSize.height +
        subtitleSize.height +
        minVerticalPadding * 2 +
        (subtitleSize.height > 0.0 ? verticalTitlePadding : 0.0);
    double tileHeight = [minTileHeight, leadingSize.height, middleHeight, trailingSize.height].max;
    double titleY;
    double? subtitleY;

    if (!hasSubtitle) {
      titleY = (tileHeight - titleSize.height) / 2.0;
    } else {
      assert(subtitleBaselineType != null);
      titleY = (tileHeight - middleHeight) / 2.0;
      subtitleY = titleY + titleSize.height + verticalTitlePadding;
    }

    // This attempts to implement the redlines for the vertical position of the
    // leading and trailing icons on the spec page:
    //   https://material.io/design/components/lists.html#specs
    // The interpretation for these redlines is as follows:
    //  - For large tiles (> 72dp), both leading and trailing controls should be
    //    a fixed distance from top. As per guidelines this is set to 16dp.
    //  - For smaller tiles, trailing should always be centered. Leading can be
    //    centered or closer to the top. It should never be further than 16dp
    //    to the top.
    double leadingY = (tileHeight - leadingSize.height) / 2.0;
    final double trailingY = (tileHeight - trailingSize.height) / 2.0;

    switch (textDirection) {
      case TextDirection.rtl: {
        if (hasLeading) {
          _positionBox(leading!, Offset(tileWidth - leadingSize.width, leadingY));
        }
        _positionBox(title!, Offset(adjustedTrailingWidth, titleY));
        if (hasSubtitle) {
          _positionBox(subtitle!, Offset(adjustedTrailingWidth, subtitleY!));
        }
        if (hasTrailing) {
          _positionBox(trailing!, Offset(0.0, trailingY));
        }
        break;
      }
      case TextDirection.ltr: {
        if (hasLeading) {
          _positionBox(leading!, Offset(0.0, leadingY));
        }
        _positionBox(title!, Offset(titleStart, titleY));
        if (hasSubtitle) {
          _positionBox(subtitle!, Offset(titleStart, subtitleY!));
        }
        if (hasTrailing) {
          _positionBox(trailing!, Offset(tileWidth - trailingSize.width, trailingY));
        }
        break;
      }
    }

    size = constraints.constrain(Size(tileWidth, tileHeight));
    assert(size.width == constraints.constrainWidth(tileWidth));
    assert(size.height == constraints.constrainHeight(tileHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void doPaint(RenderBox? child) {
      if (child != null) {
        final BoxParentData parentData = child.parentData! as BoxParentData;
        context.paintChild(child, parentData.offset + offset);
      }
    }
    doPaint(leading);
    doPaint(title);
    doPaint(subtitle);
    doPaint(trailing);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, { required Offset position }) {
    assert(position != null);
    for (final RenderBox child in children) {
      final BoxParentData parentData = child.parentData! as BoxParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - parentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }
}