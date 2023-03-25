
/// RegTextMatchTool相关的测试用例

import 'package:common/src/utils/reg_text_match_tool.dart';
import 'package:common/src/utils/type_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('testRegMatch', () {
    final tool = RegTextMatchTool<String>(
      'hello {{name}}',
      (text) => text,
    );
    tool.addMatch(RegExp(r'{{name}}'), (index, match) => 'world');
    expect(tool.build(), ['hello ', 'world']);
  });
  test('testRegMatch2', () {
    final input = '{{icon::celebrate}}恭喜！你的魅力吸引到了{{userName}}的注意,'
        ' {{time::1679726627000}}TA对你很感兴趣且多次查看了您的资料,{{time::1679725615000}},'
        ' mappingTime: 2023/3/25 14:43:47';
    final params = {
      "uid": 810002623,
      "userName": "Ellen3",
      't1': 1,
      "mappingTime": {"2023/3/25 14:43:47": 1679726627000}
    };
    final matchTool = RegTextStringMatchTool(input);
    matchTool.addMatch(RegExp(r'\{\{icon::(celebrate)\}\}'), (index, match) => '${match.group(1)}🎉');
    matchTool.addMatch(RegExp(r'\{\{time::(\d+)\}\}'), (index, match) {
      var time = TypeUtil.parseInt(match.group(1));
      /// 判断是否是毫秒
      if (time < 10000000000) {
        time *= 1000;
      }
      final date = DateTime.fromMillisecondsSinceEpoch(time);
      /// 格式化时间: 2023/02/24 10:00:00
      return '${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute}:${date.second}';
    });
    matchTool.addMatch(RegExp(r'\{\{userName\}\}'), (index, match) => TypeUtil.parseString(params['userName']));
    TypeUtil.parseMap(params['mappingTime']).forEach((key, value) {
      matchTool.addMatch(
        key, (index, match) {
          var time = TypeUtil.parseInt(value);
          /// 判断是否是毫秒
          if (time < 10000000000) {
            time *= 1000;
          }
          final date = DateTime.fromMillisecondsSinceEpoch(time);
          /// 格式化时间: 2023/02/24 10:00:00
          return '${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}:${date.second}';
        },
      );
    });
    print(matchTool.buildText());
    expect(matchTool.buildText(), 'celebrate🎉恭喜！你的魅力吸引到了Ellen3的注意, 2023/3/25 14:43:47'
        'TA对你很感兴趣且多次查看了您的资料,2023/3/25 14:26:55, mappingTime: 2023-3-25 14:43:47');
  });
}