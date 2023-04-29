import 'package:code_preview/src/code_preview/code_preview_state.dart';
import 'package:code_preview/src/helper/code_highlight/syntax_highlighter.dart';
import 'package:code_preview/src/state_manage/easy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../code_preview.dart';
import '../state_manage/build.dart';
import '../state_manage/change_notifier_easy.dart';
import 'code_preview_logic.dart';

part 'widget/cp_bg.dart';

part 'widget/cp_code.dart';

part 'widget/cp_top_info.dart';

typedef CustomBuilder = Widget Function(Widget codeWidget, CustomParam? param);
typedef CodeBuilder = void Function(String codeContent);

class CodePreview extends StatelessWidget {
  const CodePreview({
    Key? key,
    required this.className,
    this.codeBuilder,
    this.customBuilder,
  }) : super(key: key);

  static CodePreviewConfig config = CodePreviewConfig();

  /// 传入你需要预览展示的类名, eg | className: "CodePreview"
  ///
  /// 谨慎使用: xxx.runtimeType.toString(), Flutter web release模式下类型名会被压缩
  final String className;

  /// 当code内容计算出来后, 该回调会被调用
  final CodeBuilder? codeBuilder;

  /// 可使用该参数自定义代码预览样式
  final CustomBuilder? customBuilder;

  @override
  Widget build(BuildContext context) {

    return _CpBg(
      logic: CodePreviewLogic(className: className, codeBuilder: codeBuilder),
      customBuilder: customBuilder,
      builder: (CodePreviewLogic logic) => [
        // 顶部功能区
        _CpTopInfo(
          data: logic.state,
          onCopy: () => logic.onCopy(),
        ),

        //代码预览区
        _CpCode(data: logic.state),
      ],
    );
  }
}
