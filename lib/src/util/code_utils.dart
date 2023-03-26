class CodeUtils {
  static String toUnderline(String str) {
    String result = str
        .replaceAllMapped(RegExp('([A-Z])'), (match) => '_${match.group(1)}')
        .toLowerCase();
    if (result.startsWith('_')) {
      result = result.substring(1);
    }
    return result; // big_camel_case
  }

  static bool matchType(String allContent,  String type) {
    RegExp regExp = RegExp(r'class\s+' + type);
    return regExp.hasMatch(allContent);
  }
}
