enum CodeTheme {
  light,
  dark,
}

class CodePreviewConfig {
  CodePreviewConfig({
    this.codeTheme = CodeTheme.light,
    this.removeParseComment = true,
  });

  CodeTheme codeTheme;

  /// 移除解析的注释
  bool removeParseComment;
}
