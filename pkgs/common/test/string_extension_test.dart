

import 'package:common/src/extensions/string_extension.dart';
import 'package:flutter_test/flutter_test.dart';

/// StringExtension测试用例

void main() {

  group('StringExtension', () {
    /// isNullOrEmpty测试用例
    test('isNullOrEmpty', () {
      expect(''.isNullOrEmpty, true);
      expect(' '.isNullOrEmpty, false);
      expect('null'.isNullOrEmpty, false);
      expect(null.isNullOrEmpty, true);
    });
    /// isNotNullOrEmpty测试用例
    test('isNotNullOrEmpty', () {
      expect(''.isNotNullOrEmpty, false);
      expect(' '.isNotNullOrEmpty, true);
      expect('null'.isNotNullOrEmpty, true);
      expect(null.isNotNullOrEmpty, false);
    });
    /// isNullOrBlank测试用例
    test('isNullOrBlank', () {
      expect(''.isNullOrBlank, true);
      expect(' '.isNullOrBlank, true);
      expect('null'.isNullOrBlank, false);
      expect(null.isNullOrBlank, true);
    });
    /// isNotNullOrBlank测试用例
    test('isNotNullOrBlank', () {
      expect(''.isNotNullOrBlank, false);
      expect(' '.isNotNullOrBlank, false);
      expect('null'.isNotNullOrBlank, true);
      expect(null.isNotNullOrBlank, false);
    });
    /// isNumber测试用例
    test('isNumber', () {
      expect(''.isNumber, false);
      expect(' '.isNumber, false);
      expect('null'.isNumber, false);
      expect(null.isNumber, false);
      expect('1'.isNumber, true);
      expect('1.0'.isNumber, true);
      expect('1.1'.isNumber, true);
      expect('1.9'.isNumber, true);
      expect('1.9'.isNumber, true);
      expect('true'.isNumber, false);
      expect('false'.isNumber, false);
      expect('false'.isNumber, false);
      expect('true'.isNumber, false);
      expect('false'.isNumber, false);
      expect('false'.isNumber, false);
    });
    /// isInt测试用例
    test('isInt', () {
      expect(''.isInt, false);
      expect(' '.isInt, false);
      expect('null'.isInt, false);
      expect(null.isInt, false);
      expect('1'.isInt, true);
      expect('1.0'.isInt, false);
      expect('1.1'.isInt, false);
      expect('1.9'.isInt, false);
      expect('1.9'.isInt, false);
      expect('true'.isInt, false);
      expect('false'.isInt, false);
      expect('false'.isInt, false);
      expect('true'.isInt, false);
      expect('false'.isInt, false);
      expect('false'.isInt, false);
    });
    /// isDouble测试用例
    test('isDouble', () {
      expect(''.isDouble, false);
      expect(' '.isDouble, false);
      expect('null'.isDouble, false);
      expect(null.isDouble, false);
      expect('1'.isDouble, false);
      expect('1.0'.isDouble, true);
      expect('1.1'.isDouble, true);
      expect('1.9'.isDouble, true);
      expect('1.9'.isDouble, true);
      expect('true'.isDouble, false);
      expect('false'.isDouble, false);
      expect('false'.isDouble, false);
      expect('true'.isDouble, false);
      expect('false'.isDouble, false);
      expect('false'.isDouble, false);
    });
    /// isUrl测试用例
    test('isUrl', () {
      expect(''.isUrl, false);
      expect(' '.isUrl, false);
      expect('null'.isUrl, false);
      expect(null.isUrl, false);
      expect('1'.isUrl, false);
      expect('1.0'.isUrl, false);
      expect('1.9'.isUrl, false);
      expect('true'.isUrl, false);
      expect('false'.isUrl, false);
      expect('http://www.baidu.com'.isUrl, true);
      expect('https://www.baidu.com'.isUrl, true);
      expect('http://www.baidu.com/'.isUrl, true);
      expect('https://www.baidu.com/'.isUrl, true);
      expect('http://www.baidu.com:8080'.isUrl, true);
      expect('https://www.baidu.com:8080'.isUrl, true);
      expect('http://www.baidu.com:8080/'.isUrl, true);
      expect('https://www.baidu.com:8080/'.isUrl, true);
      expect('http://www.baidu.com:8080/a/b/c'.isUrl, true);
      expect('https://www.baidu.com:8080/a/b/c'.isUrl, true);
      expect('http://www.baidu.com:8080/a/b/c/'.isUrl, true);
      expect('https://www.baidu.com:8080/a/b/c/'.isUrl, true);
      expect('http://www.baidu.com:8080/a/b/c?a=1&b=2'.isUrl, true);
      expect('https://www.baidu.com:8080/a/b/c?a=1&b=2'.isUrl, true);
      expect('http://www.baidu.com:8080/a/b/c/?a=1&b=2'.isUrl, true);
      expect('https://www.baidu.com:8080/a/b/c/?a=1&b=2'.isUrl, true);
    });

  });
}