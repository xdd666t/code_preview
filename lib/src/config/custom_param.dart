class CustomParam {
  CustomParam({
    required this.codeContent,
    required this.codeFileName,
    required this.codePath,
    required this.parseParam,
  });

  /// 代码内容
  final String codeContent;

  /// 代码内容的路径
  final String codePath;

  /// 代码内容的文件名
  final String codeFileName;

  /// 解析代码的map参数集
  ///
  /// eg:
  /// 可解析下述的title,***及其后面的内容, *** 非固定内容, 可随意命名
  /// 使用: parseParam['title'], 或者 parseParam['***']
  ///
  /// /// title:
  /// ///   - test title one
  /// ///   - test title two
  /// /// content: test content
  /// /// ***: test one
  /// class OneWidget extends StatelessWidget {
  ///   const OneWidget({Key? key}) : super(key: key);
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return const Placeholder();
  ///   }
  /// }
  final Map<String, List<String>> parseParam;
}
