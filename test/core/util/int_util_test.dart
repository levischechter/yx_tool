import 'package:yx_tool/src/core/test/yx_test.dart';
import 'package:yx_tool/src/core/util/int_util.dart';

void main() {
  testExecute(
    title: 'IntUtil.intToRoman Test',
    function: () {
      print(IntUtil.intToRoman(122));
    },
    execute: false,
  );

  testExecute(
    title: 'IntUtil.romanToInt Test',
    function: () {
      print(IntUtil.romanToInt('CXXII'));
    },
    execute: false,
  );

  testExecute(
    title: 'IntUtil.maxUInt8 Test',
    function: () {
      print(IntUtil.maxInt8);
      print(IntUtil.maxInt16);
      print(IntUtil.maxInt32);
      print(IntUtil.maxInt64);
      print(IntUtil.minInt8);
      print(IntUtil.minInt16);
      print(IntUtil.minInt32);
      print(IntUtil.minInt64);

      print(IntUtil.toInt8(129));
      print(IntUtil.toInt16(IntUtil.maxUInt16));
    },
    execute: true,
  );
}
