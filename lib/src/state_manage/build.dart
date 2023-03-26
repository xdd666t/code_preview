import 'package:flutter/material.dart';

import 'easy.dart';

class EasyBuilder<T extends ChangeNotifier> extends StatelessWidget {
  const EasyBuilder(
    this.builder, {
    Key? key,
  }) : super(key: key);

  final Widget Function() builder;

  @override
  Widget build(BuildContext context) {
    Easy.register<T>(context);
    return builder();
  }
}

class EasyBuilderAll<T extends ChangeNotifier> extends StatelessWidget {
  const EasyBuilderAll(
    this.builder, {
    Key? key,
  }) : super(key: key);

  final Widget Function(BuildContext context, T easyP) builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, Easy.register<T>(context));
  }
}
