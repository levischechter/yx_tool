import 'package:yx_tool/src/core/io/checksum/crc6.dart';
import 'package:yx_tool/src/core/test/yx_test.dart';
import 'package:yx_tool/src/core/util/hex_util.dart';

void main() {
  testExecute(
    title: 'CRC6ITU Test',
    function: () {
      var crc6 = CRC6ITU();
      crc6.updateList(HexUtil.decodeHex(
          '01 03 00 12 35 61 48 55 56 15 23 48 97 65 11 25 65 63 48 75 66 48 22 45',
          delimiter: ' '));
      print(crc6.getValue());
      print(crc6.getHexValue());
      print(crc6.getBinaryValue());
    },
    execute: true,
  );
}
