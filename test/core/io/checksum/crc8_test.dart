import 'package:yx_tool/src/core/io/checksum/crc8.dart';
import 'package:yx_tool/src/core/test/yx_test.dart';
import 'package:yx_tool/src/core/util/hex_util.dart';

void main() {
  testExecute(
    title: 'CRC8 Test',
    function: () {
      var crc8 = CRC8();
      crc8.updateList(HexUtil.decodeHex('01 03', delimiter: ' '));
      print(crc8.getValue());
      print(crc8.getHexValue());
      print(crc8.getBinaryValue());
    },
    execute: true,
  );

  testExecute(
    title: 'CRC8ITU Test',
    function: () {
      var crc8 = CRC8ITU();
      crc8.updateList(HexUtil.decodeHex('01 03', delimiter: ' '));
      print(crc8.getValue());
      print(crc8.getHexValue());
      print(crc8.getBinaryValue());
    },
    execute: true,
  );

  testExecute(
    title: 'CRC8ROHC Test',
    function: () {
      var crc8 = CRC8ROHC();
      crc8.updateList(HexUtil.decodeHex('01 03', delimiter: ' '));
      print(crc8.getValue());
      print(crc8.getHexValue());
      print(crc8.getBinaryValue());
    },
    execute: true,
  );

  testExecute(
    title: 'CRC8MAXIM Test',
    function: () {
      var crc8 = CRC8MAXIM();
      crc8.updateList(HexUtil.decodeHex('01 03', delimiter: ' '));
      print(crc8.getValue());
      print(crc8.getHexValue());
      print(crc8.getBinaryValue());
    },
    execute: true,
  );
}