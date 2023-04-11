import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

const double pickerItemHeight = 38.0;

/// 定义某列某行所显示的内容，column 代表列的索引，index 代表 第component列中的第 index 个元素
typedef ItemBuilder = Widget Function(int column, int row, bool isSelected);

/// 创建一级数据widget列表
typedef CreateWidgetList = List<Widget> Function();

/// 数据适配 Delegate
abstract class MultiDataPickerAdapter extends ChangeNotifier {
  /// 定义显示几列内容
  int numberOfColumn();

  /// 定义每一列所显示的行数， column 代表列的索引，
  int numberOfRowsInColumn(int column);

  /// 定义某列某行所显示的内容，column 代表列的索引，index 代表 第component列中的第 index 个元素
  String titleForRowInColumn(int column, int row);

  /// 定义选择更改后的操作
  void selectRowInColumn(int column, int row);

  /// 初始选中的行数
  int getSelectedRowForColumn(int column);

  /// 自定义实现Widget样式，更灵活
  Widget buildPicker(BuildContext context, int column, Widget child) => child;
}

/// 多级数据选择弹窗
class MultiPicker extends StatefulWidget {
  /// 多级数据选择弹窗的数据来源，自定义delegate继承该类，实现具体方法即可自定义每一列、每一行的具体内容
  final MultiDataPickerAdapter controller;

  /// 自定义实现 item Widget样式，更灵活
  final ItemBuilder? itemBuilder;

  /// 选中的文案样式
  final TextStyle? selectedTextStyle;

  /// 未选中的文案样式
  final TextStyle? unselectedTextStyle;

  /// 选择轮盘的滚动行为
  final ScrollBehavior? behavior;

  /// 选择轮盘的高度
  final double height;

  /// 选择轮盘的背景色
  final Color backgroundColor;


  final EdgeInsetsGeometry? margin;

  /// 选择轮盘的内边距
  final EdgeInsetsGeometry? padding;

  /// 选择轮盘的每一行的高度
  final double itemExtent;

  const MultiPicker({
    Key? key,
    required this.controller,
    this.itemBuilder,
    this.height = 200,
    this.behavior,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.backgroundColor = Colors.white,
    this.margin,
    this.padding,
    this.itemExtent = pickerItemHeight,
  }) : super(key: key);

  @override
  _MultiPickerState createState() => _MultiPickerState();
}

class _MultiPickerState extends State<MultiPicker> {
  final List<FixedExtentScrollController> _scrollControllers = [];

  @override
  void initState() {
    super.initState();
    _initControllers();
    widget.controller.addListener(_onSyncItem);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onSyncItem);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MultiPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initControllers();
  }

  void _initControllers() {
    _scrollControllers.clear();
    for (int i = 0; i < widget.controller.numberOfColumn(); i++) {
      int row = widget.controller.getSelectedRowForColumn(i);
      FixedExtentScrollController controller =
      FixedExtentScrollController(initialItem: row);
      _scrollControllers.add(controller);
    }
  }

  void _onSyncItem() {
    if (widget.controller.numberOfColumn() != _scrollControllers.length) {
      _initControllers();
    }
    for (int i = 0; i < widget.controller.numberOfColumn(); i++) {
      int row = widget.controller.getSelectedRowForColumn(i);
      final controller = _scrollControllers[i];
      if (controller.hasClients && controller.selectedItem != row) {
        //print('_onSyncItem column: $i, row: $row');
        controller.jumpToItem(row);
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: Stack(
        children: [

          Container(
            height: widget.height,
            padding: widget.padding,
            child: _configMultiDataPickerWidget(),
          ),
          Positioned.fill(child: _buildSelectionOverLayer()),
        ],
      ),
    );
  }

  //选择的内容widget
  Widget _configMultiDataPickerWidget() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: _pickers(),
    );
  }

  //picker数据
  List<Widget> _pickers() {
    List<Widget> pickers = [];
    for (int i = 0; i < widget.controller.numberOfColumn(); i++) {
      Widget picker = _configSinglePicker(i);
      pickers.add(Expanded(flex: 1, child: picker));
    }
    return pickers;
  }

  Widget _defaultItemBuilder(int column, int row, bool isSelected) {
    return Center(
      child: Text(
        widget.controller.titleForRowInColumn(column, row),
      ),
    );
  }

  TextStyle _defaultTextStyle(bool isSelected) {
    return isSelected
        ? const TextStyle(
      color: Color(0xFF39393A),
      fontSize: 18,
    )
        : const TextStyle(
      color: Color(0xFFAAAAAA),
      fontSize: 18,
    );
  }

  //构建单列数据
  Widget _configSinglePicker(int column) {
    final adapter = widget.controller;
    List<Widget> list = [];
    int selectedRow = adapter.getSelectedRowForColumn(column);
    for (int index = 0;
    index < adapter.numberOfRowsInColumn(column);
    index++) {
      bool isSelected = selectedRow == index;
      final itemBuilder = widget.itemBuilder ?? _defaultItemBuilder;
      Widget child = itemBuilder(column, index, isSelected);
      final textStyle =
      isSelected ? widget.selectedTextStyle : widget.unselectedTextStyle;
      final defaultTextStyle = _defaultTextStyle(isSelected);
      list.add(
        DefaultTextStyle(
          style: defaultTextStyle.merge(textStyle),
          child: child,
        ),
      );
    }
    final picker = ScrollConfiguration(
      behavior: widget.behavior ?? CupertinoScrollBehavior(),
      child: CupertinoPicker(
        key: Key(column.toString()),
        backgroundColor: null,
        scrollController: _scrollControllers[column],
        itemExtent: widget.itemExtent,
        diameterRatio: 100,
        squeeze: 1,
        selectionOverlay: null,
        //lineColor: lineColor,
        onSelectedItemChanged: (index) {
          if (index >= 0 && index < adapter.numberOfRowsInColumn(column)) {
            adapter.selectRowInColumn(column, index);
            HapticFeedback.mediumImpact();
            return;
          }
        },
        children: list.isNotEmpty ? list : [const Center(child: Text(''))],
      ),
    );
    return adapter.buildPicker(context, column, picker);
  }

  Widget _buildSelectionOverLayer() {
    return IgnorePointer(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(
            height: widget.itemExtent,
          ),
          child: const MultiPickerSelectionOverlay(
            radius: 4,
          ),
        ),
      ),
    );
  }
}

class MultiPickerSelectionOverlay extends StatelessWidget {

  const MultiPickerSelectionOverlay({
    Key? key,
    this.radius = 4,
    this.background = CupertinoColors.tertiarySystemFill,
    this.overlayHorizontalMargin = 0,
  }) : super(key: key);

  final double radius;
  final Color background;
  final double overlayHorizontalMargin;

  @override
  Widget build(BuildContext context) {
    final Radius r = Radius.circular(radius);

    return Container(
      margin: EdgeInsetsDirectional.only(
        start: overlayHorizontalMargin,
        end: overlayHorizontalMargin,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(r),
        color: CupertinoDynamicColor.resolve(background, context),
      ),
    );
  }
}


///默认的选择轮盘滚动行为，Android去除默认的水波纹动画效果
class _DefaultScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

/// 实现了部分默认逻辑的 Delegate
class DefaultMultiPickerController extends MultiDataPickerAdapter {
  ///数据源
  final List<MultiPickerItem> data;

  /// 每一列选中的数据
  List<int> _selectedIndexes = [];

  int _numberOfComponent = 0;

  DefaultMultiPickerController({
    required this.data,
    List<int>? selectedIndexes,
  }) {
    _numberOfComponent = _getDataDeep(data);
    assert(
    selectedIndexes == null || selectedIndexes.length == _numberOfComponent,
    'selectedIndexes length must be equal to numberOfComponent');
    debugPrint('_numberOfComponent: $_numberOfComponent');
    if (selectedIndexes != null) {
      _selectedIndexes = List.from(selectedIndexes);
    } else {
      _selectedIndexes = List.filled(_numberOfComponent, 0);
    }
  }

  /// 深度遍历data，判断有几列数据
  int _getDataDeep(List<MultiPickerItem> data) {
    if (data.isEmpty) {
      return 0;
    }
    int depth = 0;
    for (MultiPickerItem entity in data) {
      int childDepth = _getDataDeep(entity.children);
      if (childDepth > depth) {
        depth = childDepth;
      }
    }
    return depth + 1;
  }

  @override
  int getSelectedRowForColumn(int column) {
    return column < _selectedIndexes.length ? _selectedIndexes[column] : 0;
  }

  ///显示几列内容
  @override
  int numberOfColumn() {
    return _numberOfComponent;
  }

  @override
  int numberOfRowsInColumn(int column) {
    if (data.isEmpty) {
      return 0;
    }
    if (column == 0) {
      return data.length;
    }

    /// 计算第component有多少个数据
    int preSelectedIndex = _selectedIndexes[0];
    MultiPickerItem pickerItem = data[preSelectedIndex];
    for (int i = 1; i < column; i++) {
      int preSelectedIndex = _selectedIndexes[i];
      pickerItem = pickerItem.children[preSelectedIndex];
    }
    return pickerItem.children.length;
  }

  @override
  void selectRowInColumn(int column, int row) {
    _selectedIndexes[column] = row;
    if (column > 0) {
      final preColumn = column - 1;
      /// 将上一列的子节点记录下来
      _entityForRowInColumn(preColumn, _selectedIndexes[preColumn])?._childSelected = row;
    }
    if (column < _selectedIndexes.length - 1) {
      for (int i = column + 1; i < _selectedIndexes.length; i++) {
        _selectedIndexes[i] = _entityForRowInColumn(i - 1, _selectedIndexes[i - 1])?._childSelected ?? 0;
      }
    }
    notifyListeners();
  }

  MultiPickerItem? _entityForRowInColumn(int column, int row) {
    if (0 == column) {
      if (data.isEmpty) return null;
      return data[row];
    } else {
      int preSelectedIndex = _selectedIndexes[0];
      MultiPickerItem pickerItem = data[preSelectedIndex];
      for (int i = 1; i < column; i++) {
        int preSelectedIndex = _selectedIndexes[i];
        if (preSelectedIndex >= pickerItem.children.length) return null;
        pickerItem = pickerItem.children[preSelectedIndex];
      }
      return pickerItem.children[row];
    }
  }

  @override
  String titleForRowInColumn(int column, int row) {
    return _entityForRowInColumn(column, row)?.text ?? '';
  }

  List<MultiPickerItem>? getSelectedItems() {
    if (data.isEmpty) return null;
    List<MultiPickerItem> items = [];
    for (int i = 0; i < _selectedIndexes.length; i++) {
      items.add(_entityForRowInColumn(i, _selectedIndexes[i])!);
    }
    return items;
  }
}

/// 适用于 DefaultMultiDataPickerDelegate 的数据类
class MultiPickerItem {
  /// 显示内容
  final String text;

  /// 数据值
  final dynamic value;

  /// 子项
  final List<MultiPickerItem> children;

  int _childSelected = 0;

  MultiPickerItem({
    required this.text,
    this.value,
    this.children = const [],
  });
}



class SinglePickerAdapter extends MultiDataPickerAdapter {
  ///数据源
  final List<SinglePickerItem> data;

  /// 每一列选中的数据
  int _selectedIndex = 0;

  SinglePickerAdapter({
    required this.data,
    int? selectedIndex,
  }) {
    if (selectedIndex != null && selectedIndex >= 0 && selectedIndex < data.length) {
      _selectedIndex = selectedIndex;
    }
  }

  @override
  int getSelectedRowForColumn(int column) {
    return _selectedIndex;
  }

  ///显示几列内容
  @override
  int numberOfColumn() {
    return 1;
  }

  @override
  int numberOfRowsInColumn(int column) {
    return data.length;
  }

  @override
  void selectRowInColumn(int column, int row) {
    _selectedIndex = row;
    notifyListeners();
  }

  @override
  String titleForRowInColumn(int column, int row) {
    return data[row].text;
  }

  SinglePickerItem? getSelectedItem() {
    if (data.isEmpty) return null;
    return data[_selectedIndex];
  }
}


class SinglePickerItem<T> {
  final String text;
  final T? value;

  const SinglePickerItem({
    required this.text,
    this.value,
  });

  @override
  String toString() {
    return 'SinglePickerItem{text: $text, value: $value}';
  }
}


abstract class TweenRelationPickerAdapter<T> extends MultiDataPickerAdapter {

  int _selectedIndex = 0;
  int _subSelectedIndex = 0;
  bool _isScrolling = false;

  int get selectedIndex => _selectedIndex;

  int get subSelectedIndex => _subSelectedIndex;

  final Map<int, int> _remainSelectedIndexes = {};

  int get remainSubSelectedIndex => _remainSelectedIndexes[_selectedIndex] ?? 0;

  T get selectedMainItem => getMainItems()[_selectedIndex];

  T? get selectedSubItem =>
      _subSelectedIndex >= 0 && _subSelectedIndex < getSubItems().length
          ? getSubItems()[_subSelectedIndex]
          : null;

  List<T> getMainItems();

  List<T> getSubItems();

  String getTitleOfItem(T item);

  Future loadSubItems(T mainItem);

  bool isEnableConfirm() => !_isScrolling;

  @override
  int numberOfColumn() => 2;

  @override
  int getSelectedRowForColumn(int column) {
    if (column == 0) {
      return _selectedIndex;
    } else {
      return _subSelectedIndex;
    }
  }

  @override
  int numberOfRowsInColumn(int column) {
    if (column == 0) {
      return getMainItems().length;
    } else {
      return getSubItems().length;
    }
  }

  @override
  String titleForRowInColumn(int column, int row) {
    if (column == 0) {
      return getTitleOfItem(getMainItems()[row]);
    } else {
      return getTitleOfItem(getSubItems()[row]);
    }
  }

  /// 监听Picker滚动状态，当滚动停止时，调用此方法
  void onMainScrollEnd() {
    loadSubItems(selectedMainItem);
  }

  @override
  void selectRowInColumn(int column, int row) {
    if (column == 0) {
      _selectedIndex = row;
    } else {
      _subSelectedIndex = row;
      _remainSelectedIndexes[_selectedIndex] = _subSelectedIndex;
    }
    notifyListeners();
  }

  /// 监听Picker滚动状态，当滚动停止时, 调用onScrollEnd
  /// 重写此方法，可以在滚动停止时，获取当前选中的数据
  /// 只监听非最后一列的滚动
  @override
  Widget buildPicker(BuildContext context, int column, Widget child) {
    if (column == numberOfColumn() - 1) {
      return child;
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollEndNotification) {
          onMainScrollEnd();
          _isScrolling = false;
        } else if (notification is ScrollStartNotification) {
          _isScrolling = true;
        }
        return true;
      },
      child: child,
    );
  }
}

