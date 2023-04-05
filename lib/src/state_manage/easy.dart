import 'package:flutter/material.dart';

import 'change_notifier_easy.dart';

class Easy {
  Easy._();

  /// 获取EasyP实例
  /// 获取实例的时候,listener参数老是写错,这边直接用俩个方法区分了
  static T of<T extends ChangeNotifier>(BuildContext context) {
    return _getInheritedElement<T>(context).value;
  }

  /// 注册监听控件
  static T register<T extends ChangeNotifier>(BuildContext context) {
    var element = _getInheritedElement<T>(context);
    context.dependOnInheritedElement(element);
    return element.value;
  }

  /// 获取距离当前Element最近继承InheritedElement<T>的组件
  static EasyInheritedElement<T>
      _getInheritedElement<T extends ChangeNotifier>(BuildContext context) {
    var inheritedElement =
        context.getElementForInheritedWidgetOfExactType<EasyInherited<T>>()
            as EasyInheritedElement<T>?;

    if (inheritedElement == null) {
      throw EasyNotFoundException(T);
    }

    return inheritedElement;
  }
}

class EasyNotFoundException implements Exception {
  EasyNotFoundException(this.valueType);

  final Type valueType;

  @override
  String toString() => 'Error: Could not find the EasyP<$valueType>';
}
