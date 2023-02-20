


import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:async/async.dart';

main() {


  test('Future', () async {
    Future<String> delayValue = Future.delayed(const Duration(milliseconds: 100), ()=> 'xxxxssss');
    print('delayValue1: ${await delayValue}');
    await Future.delayed(const Duration(milliseconds: 2000));
    print('delayValue2: ${[].runtimeType}');
  });

  test('json', () {
    final map = jsonDecode('{}');
    print('jsonMap: ${map['user']}');
  });

  test('map test', (){
    final Map<String, String> map = {'a': 'a', 'b': "b"};
    assert(map is Map<String, dynamic>);
  });

  test('List is', (){
    final list = [1];
    print('list is: ${list is List<String>}');
  });
}


