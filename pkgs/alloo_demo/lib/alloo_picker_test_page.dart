import 'package:alloo_demo/widgets/alloo_picker_dialog.dart';
import 'package:common/common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'widgets/multi_data_picker_widget.dart';

class AllooPickerTestPage extends StatefulWidget {
  const AllooPickerTestPage({Key? key}) : super(key: key);

  @override
  State<AllooPickerTestPage> createState() => _AllooPickerTestPageState();
}

class _AllooPickerTestPageState extends State<AllooPickerTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Picker相关测试'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Picker'),
            onTap: () async {
              final result = await AllooPickerDialog.showSinglePicker(
                  context: context,
                  title: '选择城市',
                  subtitle: '请选择你所在的城市',
                  icon: Image.asset(
                    'assets/images/ic_person_nick_name.webp',
                    package: 'alloo_demo',
                  ),
                  items: [
                    SinglePickerItem(text: '武汉', value: 1),
                    SinglePickerItem(text: '北京', value: 2),
                    SinglePickerItem(text: '上海', value: 3),
                    SinglePickerItem(text: '广州', value: 4),
                  ]);
              print('showSinglePicker: $result');
            },
          ),
          ListTile(
            title: const Text('Picker2'),
            onTap: () async {
              final result = await AllooPickerDialog.showTweenPicker(
                context: context,
                title: '选择城市',
                titleAlignment: Alignment.center,
                adapter: LocationAdapter(),
              );
              print('showTweenPicker: $result');
            },
          ),
          ListTile(
            title: const Text('Picker3'),
            onTap: () async {
              final result = await AllooPickerDialog.showTweenPicker(
                context: context,
                title: '选择年龄',
                titleAlignment: Alignment.center,
                adapter: AgeAdapter('不限', 20, 50),
              );
              print('showTweenPicker: $result');
            },
          ),

          ListTile(
            title: const Text('Picker4'),
            onTap: () async {
              final result = await AllooPickerDialog.showTweenPicker(
                context: context,
                title: '选择身高',
                titleAlignment: Alignment.center,
                adapter: _HeightDataAdapter('不限', 160, 180),
              );
              print('showTweenPicker: $result');
            },
          ),
        ],
      ),
    );
  }
}

class Area {
  final int id;
  final String name;

  Area(this.id, this.name);

  @override
  String toString() {
    return 'Area{id: $id, name: $name}';
  }
}

class LocationAdapter extends TweenRelationPickerAdapter<Area> {
  final List<Area> _state = [];
  final Map<Area, List<Area>> _cityMap = {};

  List<Area> _cityList = [];

  LocationAdapter() {
    final allArea = Area(0, '不限');
    _state.add(allArea);
    _cityMap[allArea] = [allArea];
    _cityList = [allArea];
    _loadState();
  }

  /// 加载国家
  Future _loadState() async {
    Future.delayed(const Duration(seconds: 1), () {
      _state.clear();
      _state.addAll([
        Area(0, '不限'),
        Area(1, '中国'),
        Area(2, '美国'),
        Area(3, '英国'),
        Area(4, '法国'),
      ]);
      notifyListeners();
    });
  }

  @override
  List<Area> getMainItems() {
    return _state;
  }

  @override
  List<Area> getSubItems() {
    return _cityList;
  }

  @override
  String getTitleOfItem(Area item) {
    return item.name;
  }

  @override
  bool isEnableConfirm() {
    return listEquals(getSubItems(), _cityMap[selectedMainItem]);
  }

  @override
  Future loadSubItems(Area mainItem) async {
    dog.d('loadSubItems....$mainItem');
    final subItems = _cityMap[mainItem];
    if (subItems != null) {
      _cityList = subItems;
    } else {
      await Future.delayed(const Duration(seconds: 5));
      final items = await _loadCityList(mainItem);
      _cityMap[mainItem] = items;
      if (mainItem == selectedMainItem) {
        _cityList = items;
      }
    }
    /// 记录位置
    selectRowInColumn(1, remainSubSelectedIndex);
  }

  Future<List<Area>> _loadCityList(Area state) async {
    switch (state.id) {
      case 0:
        return [Area(0, '不限')];
      case 1:
        return [Area(0, '不限'), Area(1, '北京'), Area(2, '上海'), Area(3, '广州')];
      case 2:
        return [Area(0, '不限'), Area(1, '纽约'), Area(2, '洛杉矶'), Area(3, '旧金山')];
      case 3:
        return [Area(0, '不限'), Area(1, '伦敦'), Area(2, '曼彻斯特'), Area(3, '利物浦')];
      case 4:
        return [Area(0, '不限'), Area(1, '巴黎'), Area(2, '马赛'), Area(3, '里昂')];
      default:
        return [Area(0, '不限')];
    }
  }
}


class AgeAdapter extends TweenRelationPickerAdapter<int> {
  static const limitStartAge = 18;
  static const limitEndAge = 60;
  static const undefinedAge = 0;

  List<int> _startAgeList = [];
  List<int> _endAgeList = [];
  String defaultStr;

  AgeAdapter(this.defaultStr, int? startAge, int? endAge) {
    _startAgeList = [undefinedAge, ..._generateStartAge()];
    _defaultSelect(0, _startAgeList, startAge);
    _endAgeList = _generateEndAge();
    _defaultSelect(1, _endAgeList, startAge);
  }

  void _defaultSelect(int column, List<int> ages, int? age) {
    age ??= 0;
    final index = ages.indexOf(age);
    if (index != -1) {
      selectRowInColumn(column, index);
    }
  }

  List<int> _generateStartAge() {
    return List.generate(limitEndAge - limitStartAge, (index) => index + limitStartAge);
  }

  List<int> _generateEndAge() {
    if (selectedMainItem == undefinedAge) return [undefinedAge];
    return List.generate(
      limitEndAge - selectedMainItem,
      (index) => index + selectedMainItem + 1,
    );
  }

  @override
  List<int> getMainItems() {
    return _startAgeList;
  }

  @override
  List<int> getSubItems() {
    return _endAgeList;
  }

  @override
  String getTitleOfItem(int item) {
    return item == 0 ? defaultStr : '$item';
  }

  @override
  Future loadSubItems(int mainItem) async {
    final oldEndAge = selectedSubItem;
    _endAgeList = _generateEndAge();
    final int newIndex;
    if (oldEndAge == null || oldEndAge <= mainItem) {
      newIndex = 0;
    } else if (oldEndAge > _endAgeList.last) {
      newIndex = _endAgeList.length - 1;
    } else {
      newIndex = _endAgeList.indexOf(oldEndAge);
    }
    selectRowInColumn(1, newIndex);
  }

}

class _HeightDataAdapter extends TweenRelationPickerAdapter<int> {
  static const limitStartHeight = 140;
  static const limitEndHeight = 200;
  static const undefinedHeight = 0;

  List<int> _startHeightList = [];
  List<int> _endHeightList = [];

  String defaultStr;

  _HeightDataAdapter(this.defaultStr, int? startHeight, int? endHeight) {
    _startHeightList = [undefinedHeight, ..._generateStartHeight()];
    _defaultSelect(0, _startHeightList, startHeight);
    _endHeightList = _generateEndHeight();
    _defaultSelect(1, _endHeightList, endHeight);
  }

  void _defaultSelect(int column, List<int> heights, int? height) {
    height ??= 0;
    final index = heights.indexOf(height);
    if (index != -1) {
      selectRowInColumn(column, index);
    }
  }

  List<int> _generateStartHeight() {
    return List.generate(
        limitEndHeight - limitStartHeight, (index) => index + limitStartHeight);
  }

  List<int> _generateEndHeight() {
    if (selectedMainItem == undefinedHeight) return [undefinedHeight];
    return List.generate(
      limitEndHeight - selectedMainItem,
      (index) => index + selectedMainItem + 1,
    );
  }

  @override
  List<int> getMainItems() {
    return _startHeightList;
  }

  @override
  List<int> getSubItems() {
    return _endHeightList;
  }

  @override
  String getTitleOfItem(int item) {
    return item == 0 ? defaultStr : '${item}cm';
  }

  @override
  Future loadSubItems(int mainItem) async {
    final oldEndHeight = selectedSubItem;
    _endHeightList = _generateEndHeight();
    final int newIndex;
    if (oldEndHeight == null || oldEndHeight <= mainItem) {
      newIndex = 0;
    } else if (oldEndHeight > _endHeightList.last) {
      newIndex = _endHeightList.length - 1;
    } else {
      newIndex = _endHeightList.indexOf(oldEndHeight);
    }
    selectRowInColumn(1, newIndex);
  }
}