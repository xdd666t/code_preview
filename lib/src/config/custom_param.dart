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
  /// key的前面必须加@,eg(@title, @***)
  /// key与value的之间,必须使用分号分割,eg(@***: *******)
  /// value如果需要换行,换行的文案前必须中划线
  /// 使用: parseParam['title'], 或者 parseParam['***']
  ///
  /// /// @title:
  /// ///  - test title one
  /// ///  - test title two
  /// /// @content: test content
  /// /// @description: test description
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
