part of '../code_preview.dart';

class _CpCode extends StatelessWidget {
  const _CpCode({Key? key, required this.data}) : super(key: key);

  final CodePreviewState data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 36),
      child: LayoutBuilder(builder: (_, constraint) {
        var config = CodePreview.config;

        var codeShow = Container(
          color: config.codeTheme == CodeTheme.light
              ? Colors.grey.withOpacity(0.1)
              : Colors.black,
          padding: const EdgeInsets.only(
            left: 10,
            right: 20,
            top: 15,
            bottom: 15,
          ),
          alignment: Alignment.centerLeft,
          child: SelectionArea(
            selectionControls: CupertinoTextSelectionControls(),
            child: Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.39,
                  color: Colors.white,
                  letterSpacing: 0.8,
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
