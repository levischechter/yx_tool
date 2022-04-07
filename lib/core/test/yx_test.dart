library yx_text;

import 'dart:async';

import 'package:yx_tool/core/date/yx_date.dart';

/// 执行测试
FutureOr testExecute({String title = '', bool timer = true, required Function function, bool execute = true, isAsync = false}) async {
  if (execute) {
    print('====>$title start execute...');
    var suffix = '';
    if (timer) {
      var timer = TimeInterval();
      suffix = ': ${timer.intervalPretty()} ms';
    }
    if (isAsync) {
      await function();
    } else {
      function();
    }
    print('====<$title end execute$suffix');
  }
}
