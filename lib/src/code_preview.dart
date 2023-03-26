import 'package:code_preview/src/helper/code_highlight/syntax_highlighter.dart';
import 'package:code_preview/src/state_manage/build.dart';
import 'package:flutter/material.dart';

import 'code_preview_logic.dart';
import 'state_manage/change_notifier_easy.dart';
import 'state_manage/easy.dart';

class CodePreview extends StatelessWidget {
  const CodePreview({
    Key? key,
    required this.code,
  }) : super(key: key);

  /// 传入你需要预览展示的实例, eg | code: CodePreview()
  final Object code;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierEasy(
      create: (_) => CodePreviewLogic(code: code),
      builder: (BuildContext context) {
        var logic = Easy.of<CodePreviewLogic>(context);

        return EasyBuilder<CodePreviewLogic>(() {
          return Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16),
                children: [DartSyntaxHighlighter().format(logic.codeContent)],
              ),
            ),
          );
        });
      },
    );
  }
}
