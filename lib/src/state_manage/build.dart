import 'package:flutter/material.dart';

import 'easy.dart';

class EasyBuilder<T extends ChangeNotifier> extends StatelessWidget {
  const EasyBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Widget Function(T easyP) builder;

  @override
  Widget build(BuildContext context) {
    return builder(Easy.register<T>(context));
  }
}
