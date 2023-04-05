part of '../code_preview.dart';

class _CpBg extends StatefulWidget {
  const _CpBg({
    Key? key,
    required this.logic,
    required this.customBuilder,
    required this.builder,
  }) : super(key: key);

  final CodePreviewLogic logic;

  final List<Widget> Function(CodePreviewLogic logic) builder;

  final CustomBuilder? customBuilder;

  @override
  State<_CpBg> createState() => _CpBgState();
}

class _CpBgState extends State<_CpBg> {
  BuildContext? _context;

  @override
  void initState() {
    widget.logic.onInit();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _CpBg oldWidget) {
    if (_context == null) {
      return;
    }

    var logic = Easy.of<CodePreviewLogic>(_context!);
    var curState = widget.logic.state;
    if (logic.state.code != curState.code) {
      logic.state = curState;
      logic.processCode();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierEasy(
      create: (_) => widget.logic,
      builder: (BuildContext context) {
        _context = context;
        return EasyBuilder<CodePreviewLogic>(builder: (logic) {
          if (widget.customBuilder != null) {
            return widget.customBuilder!(logic.state.customParam);
          }

          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Colors.white,
              child: Stack(children: widget.builder(logic)),
            ),
          );
        });
      },
    );
  }
}
