import 'package:yx_tool/src/core/io/checksum/crc32.dart';
import 'package:yx_tool/src/core/test/yx_test.dart';
import 'package:yx_tool/src/core/util/hex_util.dart';

void main() {
  testExecute(
    title: 'CRC32 Test',
    function: () {
      var crc32 = CRC32();
      crc32.updateList(HexUtil.decodeHex('01 03 00 12 35 61 48 55 56 15 23 48 97 65 11 25 65 63 48 75 66 48 22 45', delimiter: ' '));
      print(crc32.getHexValue());
      print(crc32.getBinaryValue());
    },
    execute: true,
  );

  testExecute(
    title: 'CRC32MPEG2 Test',
    function: () {
      var crc32 = CRC32MPEG2();
      crc32.updateList(HexUtil.decodeHex('01 03 00 12 35 61 48 55 56 15 23 48 97 65 11 25 65 63 48 75 66 48 22 45', delimiter: ' '));
      print(crc32.getHexValue());
      print(crc32.getBinaryValue());
    },
    execute: true,
  );
}