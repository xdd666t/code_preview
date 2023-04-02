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
    return Container(
      height: 36,
      color: const Color(0xFF343541),
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

              return Icon(icons, color: Colors.white, size: 16);
            }),
            const SizedBox(width: 10),
            Text(
              data.copyStatus == CopyStatus.not ? 'Copy code' : "Copied",
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ]),
        ),
      ),
    );
  }
}
