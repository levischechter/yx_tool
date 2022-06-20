import 'package:yx_tool/src/core/io/checksum/crc4.dart';
import 'package:yx_tool/src/core/test/yx_test.dart';
import 'package:yx_tool/src/core/util/hex_util.dart';

void main() {
  testExecute(
    title: 'CRC4 Test',
    function: () {
      var crc4 = CRC4ITU();
      crc4.updateList(HexUtil.decodeHex('01 03 00 12 35 61 48 55 56 15 23 48 97 65 11 25 65 63 48 75 66 48 22 45', delimiter: ' '));
      print(crc4.getValue());
      print(crc4.getHexValue());
      print(crc4.getBinaryValue());
    },
    execute: true,
  );
}
