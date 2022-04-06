import 'package:yx_tool/yx_tool.dart';

void main() async {
  testExecute(
    title: 'TimeInterval Test',
    function: () async {
      var timer = TimeInterval();

      timer.start('1');
      await Future.delayed(Duration(milliseconds: 800));
      timer.start('2');
      await Future.delayed(Duration(milliseconds: 900));

      print('Timer 1 took ${timer.intervalMs("1")} ms');
      print('Timer 2 took ${timer.intervalMs("2")} ms');
    },
  );
}
