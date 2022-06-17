library yx_text;

import 'dart:async';

/// 执行测试
FutureOr testExecute({String title = '', bool timer = true, required Function function, bool execute = true, isAsync = false}) async {
  if (execute) {
    print('$title:');
    var suffix = '';
    late Stopwatch stopwatch;
    if (timer) {
      stopwatch = Stopwatch()..start();
    }
    if (isAsync) {
      await function();
    } else {
      function();
    }
    if (timer) {
      stopwatch.stop();
      suffix = ': ${stopwatch.elapsed}';
    }
    print('$title$suffix\n');
  }
}
