enum CodeTheme {
  light,
  dark,
}

class CodePreviewConing {
  CodePreviewConing({
    this.codeTheme = CodeTheme.light,
  });

  CodeTheme codeTheme;
}
