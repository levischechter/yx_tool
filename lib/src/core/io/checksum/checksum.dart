import 'dart:typed_data';

import 'package:yx_tool/src/core/util/hex_util.dart';

///表示数据校验和的接口。
abstract class Checksum {
  ///使用指定字节更新当前校验和
  void updateInt(int b);

  ///使用指定的字节数组更新当前校验和
  void updateList(List<int> ints,[int off = 0, int? len]) {
    update(Uint8List.fromList(ints), off, len);
  }

  ///使用指定的字节数组更新当前校验和
  void update(Uint8List ints, [int off = 0, int? len]);

  /// Returns the current checksum value.
  int getValue();

  /// Returns the current checksum hex value.
  String getHexValue() {
    return HexUtil.toHex(getValue());
  }

  /// Returns the current checksum binary value.
  String getBinaryValue() {
    return getValue().toRadixString(2);
  }

  /// Resets the checksum to its initial value.
  void reset();
}
