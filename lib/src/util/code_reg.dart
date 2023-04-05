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

  static Map<String, String> parseParam(String codeContent) {
    RegExp exp = RegExp(r"///\s*(\S+)[\s,:.：。]+(.+)");

    Iterable<Match> matches = exp.allMatches(codeContent);
    Map<String, String> map = {};
    for (Match match in matches) {
      String? key = match.group(1);
      String? value = match.group(2);
      map[key ?? ''] = value ?? '';
    }
    return map;
  }

  static String removeComment(String codeContent) {
    RegExp exp = RegExp(r"///.*\n");
    return codeContent.replaceAll(exp, "");
  }
}
