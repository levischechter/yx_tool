import 'package:yx_tool/src/core/test/yx_test.dart';
import 'package:yx_tool/src/core/text/string_builder.dart';

void main() {
  testExecute(
    title: 'StringBuilder Test',
    function: () {
      var sb = StringBuilder(10);
      sb.append('abcd');
      print('$sb : ${sb.capacity}');
      sb.insert(1, 'hh');
      print('$sb : ${sb.capacity}');
      sb.reverse();
      print('$sb : ${sb.capacity}');
      sb.delete(1, 3);
      print('$sb : ${sb.capacity}');
      sb.replace(1, 3, 'FengLingYue');
      print('$sb : ${sb.capacity}');
      sb.appendAll(['嘻嘻', '哈哈', '嘤嘤'],
          separator: ',', before: '[', suffix: ']');
      print('$sb : ${sb.capacity}');
      sb.append(StringBuilder.from('风灵月影').deleteCharAt(1)).deleteCharAt(1);
      print('$sb : ${sb.capacity}');

      print(sb.bytes());
    },
    execute: true,
  );
}
