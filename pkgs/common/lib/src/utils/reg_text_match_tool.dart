
import 'package:flutter/widgets.dart';

/// 正则表达式匹配工具类
/// 用来正则替换字符串
/// 可以常用实现类 [RegTextStringMatchTool] 和 [RegTextSpanMatchTool]
/// 例子见 [RegTextSpanMatchTool]
class RegTextMatchTool<T> {
  final String text;
  final List<_MatchResult<T>> _matches = [];
  final DefaultMatchBuilder defaultBuilder; 

  /// 构造函数
  /// [text] 要匹配的字符串
  /// [defaultBuilder] 默认的字符串匹配规则，没有匹配到的字符串会使用这个规则
  RegTextMatchTool(this.text, this.defaultBuilder);

  /// 添加匹配规则
  void addMatch(Pattern pattern, RegTextMatch<T> builder) {
    final matches = pattern.allMatches(text);
    var index = 0;
    for (final match in matches) {
      /// 如果匹配到的字符串与以前的匹配重叠，则忽略
      print('${match.pattern}=>${match.start}=>${match.end}, ${match.group(0)}');
      if (!_isOverlap(match)) {
        _matches.add(_MatchResult(index++, match, builder));
      }
    }
  }

  /// 是否重叠的匹配区域
  bool _isOverlap(Match match) {
    return _matches.any((e) {
      final m = e.match;
      return (m.start <= match.start && match.start < m.end) ||
          (m.start < match.end && match.end <= m.end);
    });
  }

  /// 构建
  List<T> build() {
    if (_matches.isEmpty) {
      return [defaultBuilder(text)];
    }
    final result = <T>[];
    int lastEnd = 0;
    // 按照匹配的顺序排序
    _matches.sort((a, b) => a.match.start - b.match.start);
    for (final match in _matches) {
      if (match.match.start > lastEnd) {
        result.add(defaultBuilder(text.substring(lastEnd, match.match.start)));
      }
      result.add(match.builder(match.index, match.match));
      lastEnd = match.match.end;
    }
    if (lastEnd < text.length) {
      result.add(defaultBuilder(text.substring(lastEnd)));
    }
    return result;
  }

}

typedef DefaultMatchBuilder<T> = T Function(String text);

/// 匹配结果, index是匹配的顺序, match是匹配的结果
typedef RegTextMatch<T> = T Function(int index, Match match);

class _MatchResult<T> {
  final int index;
  final Match match;
  final RegTextMatch<T> builder;

  _MatchResult(this.index, this.match, this.builder);
}


/// 通过正则表达式匹配字符串
class RegTextStringMatchTool extends RegTextMatchTool<String> {
  RegTextStringMatchTool(String text) : super(text, (text) => text);

  String buildText([String separator = ""]) {
    return build().join();
  }
}

/// 创建span widget
/// 通过正则表达式匹配字符串
/// 使用示例:
/// ```
/// final tool = RegTextSpanMatchTool('hello world');
/// tool.addMatch(RegExp(r'hello'), (index, match) => TextSpan(text: match[0]!, style: TextStyle(color: Colors.red)));
/// tool.addMatch(RegExp(r'world'), (index, match) => TextSpan(text: match[0]!, style: TextStyle(color: Colors.blue)));
/// final span = tool.buildSpan();
/// ```
class RegTextSpanMatchTool extends RegTextMatchTool<InlineSpan> {
  RegTextSpanMatchTool(String text) : super(text, (text) => TextSpan(text: text));

  InlineSpan buildSpan() {
    final children = build();
    if (children.length == 1) {
      return children.first;
    }
    return TextSpan(children: children);
  }
}