import 'package:alloo_demo/widgets/alloo_easy_refresh.dart';
import 'package:alloo_demo/widgets/alloo_loading.dart';
import 'package:alloo_demo/widgets/alloo_popup_loading.dart';
import 'package:alloo_demo/widgets/alloo_smart_refresher.dart';
import 'package:alloo_demo/widgets/frame_image_animation.dart';
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

  final AllooRefreshController _refreshController = AllooRefreshController();

  @override
  void initState() {
    super.initState();
    repository.rebuild.listen((event) {
      setState(() {});
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
        controller: _refreshController,
        onRefresh: () async {
          print('onRefresh!!!');
          await repository.refresh();
        },
        child: _buildLoadingMoreList(),
      ),
    );
  }

  Widget _buildAnimation() {
    return GestureDetector(
      onTap: () {
        print('_buildAnimation tap');
        _refreshController.callRefresh();
      },
      child: const AllooLoading(size: 80),
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
          if (index == 0) {
            return _buildAnimation();
          }
          return ListTile(
            title: Text(item),
            onTap: () {
              print('onTap $item');
              if (index == 1) {
                showLoadingDialog(context, text: 'Loading...');
                Future.delayed(const Duration(milliseconds: 5000), () {
                  hideLoadingDialog();
                });
              } else if (index == 2) {
                hideLoadingDialog();
              }
            },
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
    await Future.delayed(const Duration(seconds: 1));
    if (!isloadMoreAction) {
      clear();
    }
    final count = length;
    addAll(List.generate(20, (index) => 'item ${count + index}'));
    return true;
  }
}
