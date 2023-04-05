part of '../code_preview.dart';

class _CpCode extends StatelessWidget {
  const _CpCode({Key? key, required this.data}) : super(key: key);

  final CodePreviewState data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 36),
      child: LayoutBuilder(builder: (_, constraint) {
        var config = CodePreview.coning;

        var codeShow = Container(
          color: config.codeTheme == CodeTheme.light
              ? Colors.grey.withOpacity(0.1)
              : Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                  DartSyntaxHighlighter(
                    config.codeTheme == CodeTheme.light
                        ? SyntaxHighlighterStyle.lightThemeStyle()
                        : SyntaxHighlighterStyle.darkThemeStyle(),
                  ).format(data.codeContent.trim()),
                ],
              ),
            ),
          ),
        );

        if (constraint.maxHeight.isFinite) {
          return SingleChildScrollView(child: codeShow);
        }

        return codeShow;
      }),
    );
  }
}
