import 'dart:async';

import '../../code_preview.dart';

class CodePreviewState {
  late String className;

  String codeContent = '';

  CodeBuilder? codeBuilder;

  CopyStatus copyStatus = CopyStatus.not;

  Timer? copyTimer;

  CustomParam? customParam;
}

enum CopyStatus {
  // 未复制
  not,
  // 已经复制
  done,
}
