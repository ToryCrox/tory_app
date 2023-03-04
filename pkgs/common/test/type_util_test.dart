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

    /// parseList测试用例, 泛型可能是数字，小数，布尔值，字符串, Map, List, Set
    /// 需要调用parseList的第二个参数用来解析泛型, 例如 TypeUtil.parseList<int>(['1', '2'], (e) => TypeUtil.parseInt(e))
    test('parseList', () {
      expect(TypeUtil.parseIntList(['1', '2']), [1, 2]);
      expect(TypeUtil.parseIntList('["1","2"]'), [1, 2]);
      expect(TypeUtil.parseStringList(['1', '2']), ['1', '2']);
      expect(TypeUtil.parseStringList('["1","2"]'), ['1', '2']);
      expect(TypeUtil.parseList("1", (e) => TypeUtil.parseString(e)), []);
    });
  });

  group('DynamicTypeExtension', () {
    // toInt测试用例，和TypeUtil.parseInt一样
    test('toInt', () {
      expect(null.toInt, 0);
      expect('null'.toInt, 0);
      expect(''.toInt, 0);
      expect('1'.toInt, 1);
      expect('1.0'.toInt, 1);
      expect('1.1'.toInt, 1);
      expect('1.9'.toInt, 1);
      expect('1.9'.toInt, 1);
      expect('true'.toInt, 0);
      expect('false'.toInt, 0);
      expect('false'.toInt, 0);
    });
    /// toDouble测试用例，和TypeUtil.parseDouble一样
    test('toDouble', () {
      expect(null.toDouble, 0.0);
      expect('null'.toDouble, 0.0);
      expect(''.toDouble, 0.0);
      expect('1'.toDouble, 1.0);
      expect('1.0'.toDouble, 1.0);
      expect('1.1'.toDouble, 1.1);
      expect('1.9'.toDouble, 1.9);
      expect('1.9'.toDouble, 1.9);
      expect('true'.toDouble, 0.0);
      expect('false'.toDouble, 0.0);
      expect('false'.toDouble, 0.0);
    });
    /// toBool测试用例，和TypeUtil.parseBool一样
    test('toBool', () {
      expect(null.toBool, false);
      expect('null'.toBool, false);
      expect(''.toBool, false);
      expect('1'.toBool, true);
      expect('1.0'.toBool, true);
      expect('1.1'.toBool, true);
      expect('1.9'.toBool, true);
      expect('1.9'.toBool, true);
      expect('true'.toBool, true);
      expect('false'.toBool, false);
      expect('false'.toBool, false);
    });
    /// toString测试用例，和TypeUtil.parseString一样
    test('toString', () {
      expect(null.toString, '');
      expect('null'.toString, '');
      expect(''.toString, '');
      expect('1'.toString, '1');
      expect('1.0'.toString, '1.0');
      expect('1.1'.toString, '1.1');
      expect('1.9'.toString, '1.9');
      expect('1.9'.toString, '1.9');
      expect('true'.toString, 'true');
      expect('false'.toString, 'false');
      expect('false'.toString, 'false');
    });
    /// toColor测试用例，和TypeUtil.parseColor一样
    test('toColor', () {
      expect(null.toColor, Colors.transparent);
      expect('null'.toColor, Colors.transparent);
      expect(''.toColor, Colors.transparent);
      expect('1'.toColor, Colors.transparent);
      expect('1.0'.toColor, Colors.transparent);
      expect('1.1'.toColor, Colors.transparent);
      expect('1.9'.toColor, Colors.transparent);
      expect('1.9'.toColor, Colors.transparent);
      expect('true'.toColor, Colors.transparent);
      expect('false'.toColor, Colors.transparent);
      expect('false'.toColor, Colors.transparent);
      expect('0x00000000'.toColor, Colors.transparent);
      expect('0xFF000000'.toColor, Colors.black);
      expect('0xFF0000FF'.toColor, const Color(0xFF0000FF));
      expect('0xFF00FF00'.toColor, const Color(0xFF00FF00));
      expect('0xFFFF0000'.toColor, const Color(0xFFFF0000));
      expect('0xFFFFFF00'.toColor, const Color(0xFFFFFF00));
      expect('0xFFFFFFFF'.toColor, const Color(0xFFFFFFFF));
      expect('#00000000'.toColor, Colors.transparent);
      expect('#FF000000'.toColor, Colors.black);
      expect('#FF0000FF'.toColor, const Color(0xFF0000FF));
      expect('#00FF00'.toColor, const Color(0xFF00FF00));
      expect('#FF0000'.toColor, const Color(0xFFFF0000));
      expect('#FFFF00'.toColor, const Color(0xFFFFFF00));
      expect('#FFFFFF'.toColor, const Color(0xFFFFFFFF));
    });
  });
}
