import 'package:yx_tool/src/core/extensions/string_extension.dart';
import 'package:yx_tool/src/core/crypto/digest/crc32.dart';
import 'package:yx_tool/src/core/test/yx_test.dart';

void main() {
  testExecute(
    title: 'crc32',
    function: () {
      var uint8list = '123'.bytes;
      print(uint8list);
      print(crc32.convert(uint8list));
    },
    execute: true,
  );
}
