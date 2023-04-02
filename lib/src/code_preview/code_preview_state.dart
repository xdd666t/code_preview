import 'dart:async';

import '../../code_preview.dart';

class CodePreviewState {
  late Object code;

  String codeContent = '';

  CodeBuilder? codeBuilder;

  CopyStatus copyStatus = CopyStatus.not;

  Timer? copyTimer;
}

enum CopyStatus {
  // 未复制
  not,
  // 已经复制
  done,
}
