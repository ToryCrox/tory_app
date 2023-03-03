

class TextUtil {

  /// Regex of url.
  static const String regexUrl = '[a-zA-Z]+://[^\\s]*';


  /// isEmpty
  static bool isEmpty(String? text) {
    return text == null || text.isEmpty;
  }


  /// 判断是否是http url
  /// [s] url
  /// [return] true: 是http url
  static bool isHttpUrl(String? s) {
    if (isEmpty(s)) {
      return false;
    }

    return s!.startsWith(RegExp(r'http(s?):\/\/'));
  }

  /// Return whether input matches regex of url.
  static bool isURL(String input) {
    return matches(regexUrl, input);
  }

  /// Return whether input matches regex.
  /// [regex] regex
  /// [input] input
  /// [return] true: matches
  static bool matches(String regex, String input) {
    if (input.isEmpty) return false;
    return RegExp(regex).hasMatch(input);
  }
}