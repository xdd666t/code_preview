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
    required String className,
    required CodeBuilder? codeBuilder,
  }) {
    state.className = className;
    state.codeBuilder = codeBuilder;
  }

  void onInit() {
    processCode();
  }

  void processCode() {
    ViewUtils.addSafeUse(() async {
      loadingCode(true);
      // 处理逻辑
      var assetFilePaths = await _getAssetFilePaths();
      // 匹配内容
      await _matchContent(assetFilePaths);
      loadingCode(false);
    });
  }

  void loadingCode(bool loading) {
    state.loadingCode = loading;
    notifyListeners();
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

  Future<void> _matchContent(List<String> assetFilePaths) async {
    var type = state.className;

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

    Map<String, String> parseParam = CodeReg.parseParam(codeContent);
    // 处理是否需要去掉注释
    if (CodePreview.config.removeParseComment) {
      codeContent = CodeReg.removeComment(codeContent);
    }

    state.codeBuilder?.call(codeContent);
    state.codeContent = codeContent;
    state.customParam = CustomParam(
      codeContent: codeContent,
      codeFileName: CodeReg.pathToFileName(correctPath),
      codePath: correctPath,
      parseParam: parseParam,
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
