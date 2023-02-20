import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesListPage extends StatefulWidget {
  const SharedPreferencesListPage({Key? key}) : super(key: key);

  @override
  State<SharedPreferencesListPage> createState() =>
      _SharedPreferencesListPageState();
}

class _SharedPreferencesListPageState extends State<SharedPreferencesListPage> {
  static const hideKeyPrefix = '_#_';

  late SharedPreferences _prefs;

  final List<String> _keys = [];

  @override
  void initState() {
    super.initState();

    _initData();
  }

  Future _initData() async {
    _prefs = await SharedPreferences.getInstance();
    _keys.clear();
    _keys.addAll(_prefs
        .getKeys()
        .where((element) => !element.startsWith(hideKeyPrefix)));
    sortAndRefresh();
  }

  void sortAndRefresh() {
    _keys.sort();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SharedPreferences"),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return ListView.builder(
      itemCount: _keys.length,
      itemBuilder: _buildItem,
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final key = _keys[index];
    return ListTile(
      onTap: (){
        _onTapTile(key);
      },
      title: Text(key),
      subtitle: Text(_prefs.get(key)?.toString() ?? ''),
    );
  }

  void _onTapTile(String key) {

  }
}
