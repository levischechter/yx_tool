import 'package:yx_tool/yx_tool.dart';

void main() {
  testExecute(
    title: 'BetweenFormatter Test',
    function: () async {
      var formatter = BetweenFormatter(betweenMs: 36000241200,level: Level.MILLISECOND);
      print(formatter);
    },
  );
}