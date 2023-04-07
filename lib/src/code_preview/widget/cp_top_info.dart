part of '../code_preview.dart';

class _CpTopInfo extends StatelessWidget {
  const _CpTopInfo({
    Key? key,
    required this.data,
    required this.onCopy,
  }) : super(key: key);

  final CodePreviewState data;

  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    var config = CodePreview.config;
    var background = config.codeTheme == CodeTheme.light
        ? Colors.grey.withOpacity(0.20)
        : const Color(0xFF343541);
    var textColor =
        config.codeTheme == CodeTheme.light ? Colors.black : Colors.white;

    return Container(
      height: 36,
      color: background,
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () => onCopy(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Builder(builder: (context) {
              IconData icons;
              if (data.copyStatus == CopyStatus.not) {
                icons = Icons.content_copy_outlined;
              } else {
                icons = Icons.done;
              }

              return Icon(icons, color: textColor, size: 16);
            }),
            const SizedBox(width: 10),
            Text(
              data.copyStatus == CopyStatus.not ? 'Copy code' : "Copied",
              style: TextStyle(color: textColor, fontSize: 14),
            ),
          ]),
        ),
      ),
    );
  }
}
