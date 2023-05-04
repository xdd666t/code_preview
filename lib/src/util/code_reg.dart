class CodeReg {
  CodeReg._();

  static bool matchType(String allContent, String type) {
    RegExp regExp = RegExp(r'class\s+' + type);
    return regExp.hasMatch(allContent);
  }

  static String pathToFileName(String path) {
    RegExp regExp = RegExp(r'[^/]+$');
    Match match = regExp.firstMatch(path) as Match;
    String? filename = match.group(0);
    return filename ?? '';
  }

  static Map<String, List<String>> parseParam(String codeContent) {
    RegExp regex = RegExp(
      r"@(?<key>.+)[:：]+\s*(?<value>.+(?:(?!\n.*\bclass\b)[^@]*)*)",
    );
    Iterable<RegExpMatch> matches = regex.allMatches(codeContent);
    Map<String, List<String>> map = {};
    for (RegExpMatch match in matches) {
      // 对key相关处理
      String key = match.namedGroup('key')?.trim() ?? '';
      // 对value相关处理
      String value = match.namedGroup('value') ?? '';
      value = value.replaceAll('///', '').trim();
      value = value.replaceAll('\n', '').trim();
      var valueList = [value];
      if (value.contains('-')) {
        value = value.replaceFirst('-', '').trim();
        var list = value.split('-');
        valueList.clear();
        for (var element in list) {
          valueList.add(element.trim());
        }
      }

      map[key] = valueList;
    }

    return map;
  }

  static String removeComment(String codeContent) {
    RegExp exp = RegExp(r"///.*\n");
    return codeContent.replaceAll(exp, "");
  }
}
