part of '../code_preview.dart';

class _CpCode extends StatelessWidget {
  const _CpCode({Key? key, required this.data}) : super(key: key);

  final CodePreviewState data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 25),
      alignment: Alignment.centerLeft,
      child: SelectionArea(
        selectionControls: CupertinoTextSelectionControls(),
        child: Text.rich(
          TextSpan(
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.white,
            ),
            children: [
              DartSyntaxHighlighter().format(data.codeContent.trim()),
            ],
          ),
        ),
      ),
    );
  }
}
