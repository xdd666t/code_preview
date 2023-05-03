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
//     RegExp regex = RegExp(r'''///\s*(?<key>.[^-]+)[:：]+\s*
// (?<value>(?:(?:-\s*)?[^\n]+\n)+)(?:(?!///|class).)*''', multiLine: true, dotAll: true);
    RegExp regex = RegExp(r"///\s*(?<key>\S+)[\s,:.：。]+(?<value>.+)");

    Iterable<RegExpMatch> matches = regex.allMatches(codeContent);
    Map<String, List<String>> map = {};
    for (RegExpMatch match in matches) {
      // 对key相关处理
      String key = match.namedGroup('key') ?? '';
      key = key.replaceAll(',', '');
      key = key.replaceAll(':', '');
      key = key.replaceAll('：', '');
      key = key.replaceAll('。', '');
      key = key.trim();

      // 对value相关处理
      String value = match.namedGroup('value') ?? '';

      // 如果 value 以 "- " 开头，则将其转换为列表
      if (value.startsWith('-')) {
        List<String> list = [];
        RegExp listRegex = RegExp(r"(^\s*-?\s*)(.*)");
        for (String line in value.split('\n')) {
          Match listMatch = listRegex.firstMatch(line.trim()) as Match;
          list.add(listMatch.group(2)?.trim() ?? '');
        }
        map[key] = list;
      } else {
        map[key] = [value];
      }
    }

    return map;
  }

  static String removeComment(String codeContent) {
    RegExp exp = RegExp(r"///.*\n");
    return codeContent.replaceAll(exp, "");
  }
}
