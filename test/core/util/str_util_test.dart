import 'package:yx_tool/core/test/yx_test.dart';
import 'package:yx_tool/core/util/yx_util.dart';

void main() {
  testExecute(
    title: 'StrUtil.isNullOrUndefinedStr Test',
    function: () {
      print(StrUtil.isNullOrUndefinedStr('undefined'));
    },
    execute: false,
  );

  testExecute(
    title: 'StrUtil.reversed Test',
    function: () {
      print(StrUtil.reversed('undefined'));
    },
    execute: false,
  );

  testExecute(
    title: 'StrUtil.repeat Test',
    function: () {
      print(StrUtil.repeat('undefined', 3));
    },
    execute: false,
  );

  testExecute(
    title: 'StrUtil.uint8List Test',
    function: () {
      print(StrUtil.uint8List('undefined'));
    },
    execute: false,
  );

  testExecute(
    title: 'StrUtil.isUpperCase Test',
    function: () {
      print(StrUtil.isUpperCase('UNDEFINED'));
    },
    execute: false,
  );

  testExecute(
    title: 'StrUtil.swapCase Test',
    function: () {
      print(StrUtil.swapCase('UNDEFINED'));
    },
    execute: false,
  );

  testExecute(
    title: 'StrUtil.indicesOf Test',
    function: () {
      var pattern = RegExp(r'[A-Z]');
      print(StrUtil.indicesOf('AbbAbb', pattern));
    },
    execute: false,
  );

  testExecute(
    title: 'StrUtil.toUnderlineCase Test',
    function: () {
      print(StrUtil.toUnderlineCase('_Abb_Abb'));
      print(StrUtil.toUnderlineCase('_AB_AB'));
      print(StrUtil.toUnderlineCase('aBccaBcc'));
      print(StrUtil.toUnderlineCase('aBCaBC'));
      print(StrUtil.toUnderlineCase('ABccABcc'));
      print(StrUtil.toUnderlineCase('ABC'));
      print(StrUtil.toUnderlineCase('AbcAbc'));
    },
    execute: false,
  );

  testExecute(
    title: 'StrUtil.toCamelCase Test',
    function: () {
      print(StrUtil.toCamelCase('hello_world'));
    },
    execute: false,
  );
}
