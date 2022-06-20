import 'package:yx_tool/src/core/io/checksum/crc16.dart';
import 'package:yx_tool/src/core/test/yx_test.dart';
import 'package:yx_tool/src/core/util/hex_util.dart';

void main() {
  testExecute(
    title: 'CRC16Ansi Test',
    function: () {
      var crc16 = CRC16Ansi();
      crc16.updateList(HexUtil.decodeHex(
          '01 03 00 12 35 61 48 55 56 15 23 48 97 65 11 25 65 63 48 75 66 48 22 45',
          delimiter: ' '));
      print('HEX: ${crc16.getHexValue()}');
      print('Binary: ${crc16.getBinaryValue()}');
    },
    execute: true,
  );

  testExecute(
    title: 'CRC16CCITT Test',
    function: () {
      var crc16 = CRC16CCITT();
      crc16.updateList(HexUtil.decodeHex(
          '01 03 00 12 35 61 48 55 56 15 23 48 97 65 11 25 65 63 48 75 66 48 22 45',
          delimiter: ' '));
      print('HEX: ${crc16.getHexValue()}');
      print('Binary: ${crc16.getBinaryValue()}');
    },
    execute: true,
  );

  testExecute(
    title: 'CRC16CCITTFalse Test',
    function: () {
      var crc16 = CRC16CCITTFalse();
      crc16.updateList(HexUtil.decodeHex(
          '01 03 00 12 35 61 48 55 56 15 23 48 97 65 11 25 65 63 48 75 66 48 22 45',
          delimiter: ' '));
      print('HEX: ${crc16.getHexValue()}');
      print('Binary: ${crc16.getBinaryValue()}');
    },
    execute: true,
  );

  testExecute(
    title: 'CRC16DNP Test',
    function: () {
      var crc16 = CRC16DNP();
      crc16.updateList(HexUtil.decodeHex(
          '01 03 00 12 35 61 48 55 56 15 23 48 97 65 11 25 65 63 48 75 66 48 22 45',
          delimiter: ' '));
      print('HEX: ${crc16.getHexValue()}');
      print('Binary: ${crc16.getBinaryValue()}');
    },
    execute: true,
  );

  testExecute(
    title: 'CRC16IBM Test',
    function: () {
      var crc16 = CRC16IBM();
      crc16.updateList(HexUtil.decodeHex(
          '01 03 00 12 35 61 48 55 56 15 23 48 97 65 11 25 65 63 48 75 66 48 22 45',
          delimiter: ' '));
      print('HEX: ${crc16.getHexValue()}');
      print('Binary: ${crc16.getBinaryValue()}');
    },
    execute: true,
  );

  testExecute(
    title: 'CRC16Maxim Test',
    function: () {
      var crc16 = CRC16Maxim();
      crc16.updateList(HexUtil.decodeHex(
          '01 03 00 12 35 61 48 55 56 15 23 48 97 65 11 25 65 63 48 75 66 48 22 45',
          delimiter: ' '));
      print('HEX: ${crc16.getHexValue()}');
      print('Binary: ${crc16.getBinaryValue()}');
    },
    execute: true,
  );

  testExecute(
    title: 'CRC16Modbus Test',
    function: () {
      var crc16 = CRC16Modbus();
      crc16.updateList(HexUtil.decodeHex(
          '01 03 00 12 35 61 48 55 56 15 23 48 97 65 11 25 65 63 48 75 66 48 22 45',
          delimiter: ' '));
      print('HEX: ${crc16.getHexValue()}');
      print('HEX RE: ${HexUtil.reverse(crc16.getHexValue())}');
      print('Binary: ${crc16.getBinaryValue()}');
    },
    execute: true,
  );

  testExecute(
    title: 'CRC16USB Test',
    function: () {
      var crc16 = CRC16USB();
      crc16.updateList(HexUtil.decodeHex(
          '01 03 00 12 35 61 48 55 56 15 23 48 97 65 11 25 65 63 48 75 66 48 22 45',
          delimiter: ' '));
      print('HEX: ${crc16.getHexValue()}');
      print('HEX RE: ${HexUtil.reverse(crc16.getHexValue())}');
      print('Binary: ${crc16.getBinaryValue()}');
    },
    execute: true,
  );

  testExecute(
    title: 'CRC16X25 Test',
    function: () {
      var crc16 = CRC16X25();
      crc16.updateList(HexUtil.decodeHex(
          '01 03 00 12 35 61 48 55 56 15 23 48 97 65 11 25 65 63 48 75 66 48 22 45',
          delimiter: ' '));
      print('HEX: ${crc16.getHexValue()}');
      print('HEX RE: ${HexUtil.reverse(crc16.getHexValue())}');
      print('Binary: ${crc16.getBinaryValue()}');
    },
    execute: true,
  );

  testExecute(
    title: 'CRC16XModem Test',
    function: () {
      var crc16 = CRC16XModem();
      crc16.updateList(HexUtil.decodeHex(
          '01 03 00 12 35 61 48 55 56 15 23 48 97 65 11 25 65 63 48 75 66 48 22 45',
          delimiter: ' '));
      print('HEX: ${crc16.getHexValue()}');
      print('HEX RE: ${HexUtil.reverse(crc16.getHexValue())}');
      print('Binary: ${crc16.getBinaryValue()}');
    },
    execute: true,
  );
}
