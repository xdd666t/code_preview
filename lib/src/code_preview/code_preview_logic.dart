import 'dart:async';
import 'dart:convert';

import 'package:code_preview/src/code_preview/code_preview_state.dart';
import 'package:code_preview/src/util/code_kit.dart';
import 'package:code_preview/src/util/view_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../code_preview.dart';
import '../util/code_reg.dart';

class CodePreviewLogic extends ChangeNotifier {
  CodePreviewState state = CodePreviewState();

  CodePreviewLogic({
    required Object code,
    required CodeBuilder? codeBuilder,
  }) {
    state.code = code;
    state.codeBuilder = codeBuilder;
  }

  void onInit() {
    processCode();
  }

  void processCode() {
    ViewUtils.addSafeUse(() async {
      // 处理逻辑
      var assetFilePaths = await _getAssetFilePaths();
      // 匹配内容
      _matchContent(assetFilePaths);
    });
  }

  void onCopy() {
    state.copyTimer?.cancel();
    state.copyTimer = Timer(const Duration(seconds: 5), () {
      state.copyStatus = CopyStatus.not;
      notifyListeners();
    });

    state.copyStatus = CopyStatus.done;
    notifyListeners();

    Clipboard.setData(ClipboardData(text: state.codeContent));
  }

  void _matchContent(List<String> assetFilePaths) async {
    var type = state.code.runtimeType.toString();
    String codeContent = '';
    String correctPath = '';
    // 尝试进行文件名匹配
    final fileName = CodeKit.toUnderline(type);
    for (String path in assetFilePaths) {
      if (path.endsWith('/$fileName.dart')) {
        final allContent = await rootBundle.loadString(path);
        var isMatch = CodeReg.matchType(allContent, type);
        if (isMatch) {
          codeContent = allContent;
          correctPath = path;
          break;
        }
      }
    }
    // 如果文件名没匹配上, 则进行全量匹配
    if (codeContent == '') {
      for (String path in assetFilePaths) {
        final allContent = await rootBundle.loadString(path);
        var isMatch = CodeReg.matchType(allContent, type);
        if (isMatch) {
          codeContent = allContent;
          correctPath = path;
          break;
        }
      }
    }
    if (codeContent == '') {
      return;
    }
    state.codeBuilder?.call(codeContent);
    state.codeContent = codeContent;
    state.customParam = CustomParam(
      codeContent: CodeReg.removeComment(codeContent),
      codeFileName: CodeReg.pathToFileName(correctPath),
      codePath: correctPath,
      parseParam: CodeReg.parseParam(codeContent),
    );

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
