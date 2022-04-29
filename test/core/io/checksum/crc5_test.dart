import 'package:yx_tool/src/core/io/checksum/crc5.dart';
import 'package:yx_tool/src/core/test/yx_test.dart';
import 'package:yx_tool/src/core/util/hex_util.dart';

void main() {
  testExecute(
    title: 'CRC5EPC Test',
    function: () {
      var crc5 = CRC5EPC();
      crc5.updateList(HexUtil.decodeHex('01 03 00 12 35 61 48 55 56 15 23 48 97 65 11 25 65 63 48 75 66 48 22 45', delimiter: ' '));
      print(crc5.getValue());
      print(crc5.getHexValue());
      print(crc5.getBinaryValue());
    },
    execute: true,
  );

  testExecute(
    title: 'CRC5ITU Test',
    function: () {
      var crc5 = CRC5ITU();
      crc5.updateList(HexUtil.decodeHex('01 03 00 12 35 61 48 55 56 15 23 48 97 65 11 25 65 63 48 75 66 48 22 45', delimiter: ' '));
      print(crc5.getValue());
      print(crc5.getHexValue());
      print(crc5.getBinaryValue());
    },
    execute: true,
  );

  testExecute(
    title: 'CRC5USB Test',
    function: () {
      var crc5 = CRC5USB();
      crc5.updateList(HexUtil.decodeHex('01 03 00 12 35 61 48 55 56 15 23 48 97 65 11 25 65 63 48 75 66 48 22 45', delimiter: ' '));
      print(crc5.getValue());
      print(crc5.getHexValue());
      print(crc5.getBinaryValue());
    },
    execute: true,
  );
}