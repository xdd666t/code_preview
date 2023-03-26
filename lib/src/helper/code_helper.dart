class CodeHelper {
  static CodeHelper? _instance;

  static CodeHelper get instance => _instance ??= CodeHelper._();

  CodeHelper._();

  Map<String, String> codeMap = {};
}
