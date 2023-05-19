import 'package:alloo_demo/widgets/alloo_easy_refresh.dart';
import 'package:alloo_demo/widgets/alloo_smart_refresher.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllooRefreshPage extends StatefulWidget {
  const AllooRefreshPage({Key? key}) : super(key: key);

  @override
  State<AllooRefreshPage> createState() => _AllooRefreshPageState();
}

class _AllooRefreshPageState extends State<AllooRefreshPage> {

  late final repository = LoadingMoreRepository();

  @override
  void initState() {
    super.initState();
    repository.rebuild.listen((event) {
      setState(() {

      });
    });
    repository.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refresh list'),
      ),
      body: AllooEasyRefresh(
        onRefresh: () async {
          await repository.refresh();
        },
        child: _buildLoadingMoreList(),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(repository[index]),
        );
      },
      itemCount: repository.length,
    );
  }

  Widget _buildLoadingMoreList() {
    return LoadingMoreList<String>(
      ListConfig(
        itemBuilder: (BuildContext context, String item, int index) {
          return ListTile(
            title: Text(item),
          );
        },
        sourceList: repository,
      ),
    );
  }
}

class LoadingMoreRepository extends LoadingMoreBase<String> {
  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    await Future.delayed(const Duration(seconds: 2));
    if (!isloadMoreAction) {
      clear();
    }
    addAll(List.generate(20, (index) => 'item $index'));
    return true;
  }
}
