[![pub](https://img.shields.io/pub/v/code_preview?label=pub&logo=dart)](https://pub.dev/packages/code_preview/install) [![stars](https://img.shields.io/github/stars/xdd666t/code_preview?logo=github)](https://github.com/xdd666t/code_preview)  [![issues](https://img.shields.io/github/issues/xdd666t/code_preview?logo=github)](https://github.com/xdd666t/code_preview/issues) 

Language:  English | [中文]()

# Quick start

- Usage: CodePreview, provide the className that needs to be previewed

```dart
import 'package:code_preview/code_preview.dart';
import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CodePreview(className: 'Test');
  }
}
```

- Use effect：[flutter_smart_dialog](https://xdd666t.github.io/flutter_use/web/index.html#/smartDialog?dialogType=CustomDialogEasy)

![image-20230429215042820](https://raw.githubusercontent.com/xdd666t/MyData/master/pic/flutter/blog/202304292234052.png)

# Configuration code file

Because the principle is to traverse resource files, the code file or its folder path that needs to be displayed must be defined under assets. This step provides an automated plug-in solution for everyone

It is strongly recommended that the code that needs to be displayed to the interface be managed in a unified file

- The code of the displayed interface needs the assets definition in pugspec.yaml

![image-20230422224011359](https://raw.githubusercontent.com/xdd666t/MyData/master/pic/flutter/blog/202304292234137.png)

If the folder for code preview is complicated, it is troublesome to define a path every time.

Provide a plugin: Flutter Code Helper

- Installation: Search for `Flutter Code Helper` in Plugins

![image-20230422225244651](https://raw.githubusercontent.com/xdd666t/MyData/master/pic/flutter/blog/202304292234638.png)

- The directory that needs to be automatically generated is defined in pugspec.yaml. The folder can be nested casually, and it will be automatically generated recursively under assets for you.
    - No need to automatically generate, you can: do not write the configuration, or configure an empty array (auto_folder: [])

```dart
code_helper:
  auto_folder: [ "assets/", "lib/widgets/" ]
```

![Apr-09-2023 22-33-42](https://raw.githubusercontent.com/xdd666t/MyData/master/pic/flutter/blog/202304292234691.gif)

**Note**

The above plugin is based on the [FlutterAssetsGenerator](https://github.com/cr1992/FlutterAssetsGenerator) plugin project of  [RayC](https://juejin.cn/user/1662117310377591)

- I took a look at the plug-in code and related functions of RayC, which are different from the implementation of the above functions I expected, and the changes have changed a lot
- If you want to try various new configurations of the plugin project, pull directly to the latest
- If you think of what functions you need later, it is convenient to add them at any time

So I didn't mention pr to its plugin, so I opened a new plugin project separately
