import 'package:yx_tool/core/test/yx_test.dart';
import 'package:yx_tool/core/util/hex_util.dart';

void main() {
  testExecute(
    title: 'HexUtil.encodeHexStr Test',
    function: () {
      var encodeHexStr = HexUtil.encodeHexStr('我是一个字符串');
      print(encodeHexStr);
      print(HexUtil.decodeHexStr(encodeHexStr));
    },
    execute: true,
  );

  testExecute(
    title: 'HexUtil.encodeColor Test',
    function: () {
      var encodeHexStr = HexUtil.encodeColor(red: 12, green: 16, blue: 32);
      print(encodeHexStr);
      var hexColor = HexUtil.decodeColor(encodeHexStr);
      print(hexColor);
    },
    execute: false,
  );
}
