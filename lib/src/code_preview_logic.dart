import 'dart:convert';

import 'package:code_preview/src/util/code_utils.dart';
import 'package:code_preview/src/util/view_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodePreviewLogic extends ChangeNotifier {
  Object code;
  String codeContent = '';

  CodePreviewLogic({
    required this.code,
  }) {
    ViewUtils.addSafeUse(() async {
      // 处理逻辑
      var assetFilePaths = await _getAssetFilePaths();
      // 匹配内容
      _matchContent(assetFilePaths);
    });
  }

  void _matchContent(List<String> assetFilePaths) async {
    var type = code.runtimeType.toString();
    codeContent = '';
    // 尝试进行文件名匹配
    final fileName = CodeUtils.toUnderline(type);
    for (String path in assetFilePaths) {
      if (path.endsWith('/$fileName.dart')) {
        final allContent = await rootBundle.loadString(path);
        var isMatch = CodeUtils.matchType(allContent, type);
        if (isMatch) {
          codeContent = allContent;
          break;
        }
      }
    }
    // 如果文件名没匹配上, 则进行全量匹配
    if (codeContent == '') {
      for (String path in assetFilePaths) {
        final allContent = await rootBundle.loadString(path);
        var isMatch = CodeUtils.matchType(allContent, type);
        if (isMatch) {
          codeContent = allContent;
          break;
        }
      }
    }
    if (codeContent == '') {
      return;
    }
    notifyListeners();
  }

  Future<List<String>> _getAssetFilePaths() async {
    final List<String> assetFilePaths = [];
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = jsonDecode(manifestContent);
    const suffix = '.dart';
    for (String filePath in manifestMap.keys) {
      if (filePath.endsWith(suffix)) {
        assetFilePaths.add(filePath);
      }
    }

    return assetFilePaths;
  }
}
