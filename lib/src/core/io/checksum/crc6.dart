import 'package:yx_tool/src/core/io/checksum/crc_checksum.dart';

/// Name:    CRC-6/ITU           x6+x+1
/// Poly:    0x03
/// Init:    0x00
/// Refin:   True
/// Refout:  True
/// Xorout:  0x00
/// Note:
class CRC6ITU extends CRCChecksum {
  @override
  int getValue() {
    return wCRCin & 0x3f;
  }

  @override
  void updateInt(int b) {
    wCRCin ^= b;
    for (var i = 0; i < 8; ++i) {
      if ((wCRCin & 1) == 0) {
        wCRCin = ((wCRCin & 0xff) >> 1) & 0xff;
      } else {
        // 0x30 = (reverse 0x03)>>(8-6)
        wCRCin = (((wCRCin & 0xff) >> 1) ^ 0x30) & 0xff;
      }
    }
  }
}
