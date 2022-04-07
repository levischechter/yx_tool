library yx_text;

import 'dart:async';

import 'package:yx_tool/core/date/yx_date.dart';

/// 执行测试
FutureOr testExecute({String title = '', bool timer = true, required Function function, bool execute = true}) async {
  if (execute) {
    print('====>$title start execute...');
    var suffix = '';
    if (timer) {
      var timer = TimeInterval();
      suffix = ': ${timer.intervalPretty()} ms';
    }
    function();
    print('====<$title end execute$suffix');
  }
}
