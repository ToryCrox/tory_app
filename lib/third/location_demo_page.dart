// @ignore_hardcode
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:common/common.dart';

class LocationDemoPage extends StatefulWidget {
  const LocationDemoPage({Key? key}) : super(key: key);

  @override
  State<LocationDemoPage> createState() => _LocationDemoPageState();
}

class _LocationDemoPageState extends State<LocationDemoPage> {
  Location location = Location();

  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('位置模拟'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(
      children: [
        ElevatedButton(
          onPressed: () {
            _tapToGetLocation();
          },
          child: const Text('点击获取位置'),
        ),
        Text(_message)
      ],
    );
  }

  Future _tapToGetLocation() async {
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      setState((){
        _message = '位置服务不可用，请求位置服务中....';
      });
      dog.d(_message);

      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        setState(() {
          _message = '位置服务不可用，请求位置服务失败....';
        });
        dog.d(_message);
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      setState(() {
        _message = '无位置服务权限，请求位置服务权限中....';
      });
      dog.d(_message);
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        setState(() {
          _message = '无位置服务权限，请求位置服务权限失败....';
        });
        dog.d(_message);
        return;
      }
    }

    setState(() {
      _message = '获取位置中....';
    });
    dog.d(_message);
    _locationData = await location.getLocation();

    setState(() {
      _message = 'altitude: ${_locationData.latitude},longitude: ${_locationData.longitude}';
    });
    dog.d(_locationData);
  }
}
