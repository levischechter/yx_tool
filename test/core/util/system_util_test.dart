import 'dart:io';

import 'package:yx_tool/src/core/test/yx_test.dart';
import 'package:yx_tool/src/core/util/system_util.dart';

void main() {
  testExecute(
    title: 'SystemUtil Test',
    function: () {
      var environment = SystemUtil.getEnvList("path");
      print(environment);
      print(SystemUtil.version);
      print(Platform.packageConfig);
    },
    execute: true,
  );
}
