import 'package:yx_tool/core/test/yx_test.dart';
import 'package:yx_tool/core/util/int_util.dart';

void main() {
  testExecute(
    title: 'IntUtil.intToRoman Test',
    function: () {
      print(IntUtil.intToRoman(122));
    },
    execute: true,
  );

  testExecute(
    title: 'IntUtil.romanToInt Test',
    function: () {
      print(IntUtil.romanToInt('CXXII'));
    },
    execute: true,
  );
}