import 'package:yx_tool/src/core/io/checksum/crc_checksum.dart';

/// Name:    CRC-7/MMC           x7+x3+1
/// Poly:    0x09
/// Init:    0x00
/// Refin:   False
/// Refout:  False
/// Xorout:  0x00
/// Use:     MultiMediaCard,SD,ect.
class CRC7MMC extends CRCChecksum {
  @override
  int getValue() {
    return wCRCin >> 1 & 0x7f;
  }

  @override
  void updateInt(int b) {
    wCRCin ^= b;
    for (var i = 0; i < 8; ++i) {
      if ( (wCRCin & 0x80) ==0) {
        wCRCin <<= 1;
      } else {
        // 0x12 = 0x09<<(8-7)
        wCRCin = ((wCRCin << 1) ^ 0x12) & 0xff;
      }
    }
  }
}
