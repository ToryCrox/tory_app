import 'dart:ui';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// TypeUtil test cases for the `type_util.dart` file.
void main() {
  group('TypeUtil', () {
    // parseInt测试用例，包括null, 'null', '', '1', '1.0', '1.1', '1.9', '1.9', 'true', 'false', 'false', true, false, 1, 2
    test('parseInt', () {
      expect(TypeUtil.parseInt(null), 0);
      expect(TypeUtil.parseInt('null'), 0);
      expect(TypeUtil.parseInt(''), 0);
      expect(TypeUtil.parseInt('1'), 1);
      expect(TypeUtil.parseInt('1.0'), 1);
      expect(TypeUtil.parseInt('1.1'), 1);
      expect(TypeUtil.parseInt('1.9'), 1);
      expect(TypeUtil.parseInt('1.9', 2), 1);
      expect(TypeUtil.parseInt('true'), 0);
      expect(TypeUtil.parseInt('false'), 0);
      expect(TypeUtil.parseInt('false', 1), 1);
      expect(TypeUtil.parseInt(true), 1);
      expect(TypeUtil.parseInt(false), 0);
      expect(TypeUtil.parseInt(1), 1);
      expect(TypeUtil.parseInt(2), 2);
    });
    // parseBool测试用例
    test('parseBool', () {
      expect(TypeUtil.parseBool(null), false);
      expect(TypeUtil.parseBool('null'), false);
      expect(TypeUtil.parseBool(''), false);
      expect(TypeUtil.parseBool('1'), true);
      expect(TypeUtil.parseBool('1.0'), true);
      expect(TypeUtil.parseBool('1.1'), true);
      expect(TypeUtil.parseBool('1.9'), true);
      expect(TypeUtil.parseBool('1.9', true), true);
      expect(TypeUtil.parseBool('true'), true);
      expect(TypeUtil.parseBool('false'), false);
      expect(TypeUtil.parseBool('false', true), false);
    });
    // parseColor测试用例
    test('parseColor', () {
      expect(TypeUtil.parseColor(null), Colors.transparent);
      expect(TypeUtil.parseColor('null'), Colors.transparent);
      expect(TypeUtil.parseColor(''), Colors.transparent);
      expect(TypeUtil.parseColor('1'), Colors.transparent);
      expect(TypeUtil.parseColor('1.0'), Colors.transparent);
      expect(TypeUtil.parseColor('1.1'), Colors.transparent);
      expect(TypeUtil.parseColor('1.9'), Colors.transparent);
      expect(TypeUtil.parseColor('true'), Colors.transparent);
      expect(TypeUtil.parseColor('false'), Colors.transparent);
      expect(TypeUtil.parseColor('0x00000000'), Colors.transparent);
      expect(TypeUtil.parseColor('0xFF000000'), Colors.black);
      expect(TypeUtil.parseColor('0xFF0000FF'), const Color(0xFF0000FF));
      expect(TypeUtil.parseColor('0xFF00FF00'), const Color(0xFF00FF00));
      expect(TypeUtil.parseColor('0xFFFF0000'), const Color(0xFFFF0000));
      expect(TypeUtil.parseColor('0xFFFFFF00'), const Color(0xFFFFFF00));
      expect(TypeUtil.parseColor('0xFFFFFFFF'), const Color(0xFFFFFFFF));
      expect(TypeUtil.parseColor('#00000000'), Colors.transparent);
      expect(TypeUtil.parseColor('#FF000000'), Colors.black);
      expect(TypeUtil.parseColor('#FF0000FF'), const Color(0xFF0000FF));
      expect(TypeUtil.parseColor('#00FF00'), const Color(0xFF00FF00));
      expect(TypeUtil.parseColor('#FF0000'), const Color(0xFFFF0000));
      expect(TypeUtil.parseColor('#FFFF00'), const Color(0xFFFFFF00));
      expect(TypeUtil.parseColor('#FFFFFF'), const Color(0xFFFFFFFF));
    });
    // parseDouble测试用例
    test('parseDouble', () {
      expect(TypeUtil.parseDouble(null), 0.0);
      expect(TypeUtil.parseDouble('null'), 0.0);
      expect(TypeUtil.parseDouble(''), 0.0);
      expect(TypeUtil.parseDouble('1'), 1.0);
      expect(TypeUtil.parseDouble('1.0'), 1.0);
      expect(TypeUtil.parseDouble('1.1'), 1.1);
      expect(TypeUtil.parseDouble('1.9'), 1.9);
      expect(TypeUtil.parseDouble('1.9', 2.0), 1.9);
    });
    // parseString测试用例, 包括null, 数字，小数，布尔值，字符串, Map, List, Set
    test('parseString', () {
      expect(TypeUtil.parseString(null), '');
      expect(TypeUtil.parseString('null'), '');
      expect(TypeUtil.parseString(''), '');
      expect(TypeUtil.parseString('1'), '1');
      expect(TypeUtil.parseString('1.0'), '1.0');
      expect(TypeUtil.parseString('1.1'), '1.1');
      expect(TypeUtil.parseString('1.9'), '1.9');
      expect(TypeUtil.parseString('1.9', '2.0'), '1.9');
      expect(TypeUtil.parseString('true'), 'true');
      expect(TypeUtil.parseString('false'), 'false');
      expect(TypeUtil.parseString('false', 'true'), 'false');
      expect(TypeUtil.parseString(true), 'true');
      expect(TypeUtil.parseString(false), 'false');
      expect(TypeUtil.parseString(1), '1');
      expect(TypeUtil.parseString(2), '2');
      expect(TypeUtil.parseString(2.0), '2.0');
      expect(TypeUtil.parseString(2.1), '2.1');
      expect(TypeUtil.parseString(2.9), '2.9');
      expect(TypeUtil.parseString(2.9, '3.0'), '2.9');
      expect(TypeUtil.parseString('string'), 'string');
      expect(TypeUtil.parseString('string', 'string2'), 'string');
      expect(TypeUtil.parseString({'key': 'value'}), '{"key":"value"}');
      expect(
          TypeUtil.parseString({'key': 'value'}, 'string'), '{"key":"value"}');
      expect(TypeUtil.parseString(['1', '2']), '["1","2"]');
      expect(TypeUtil.parseString(['1', '2'], 'string'), '["1","2"]');
      expect(TypeUtil.parseString({'1', '2'}), '["1","2"]');
    });
  });
}
