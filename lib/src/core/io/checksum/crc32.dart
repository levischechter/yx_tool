import 'package:yx_tool/src/core/io/checksum/crc_checksum.dart';

/// Name:    CRC-32  x32+x26+x23+x22+x16+x12+x11+x10+x8+x7+x5+x4+x2+x+1
/// Poly:    0x4C11DB7
/// Init:    0xFFFFFFF
/// Refin:   True
/// Refout:  True
/// Xorout:  0xFFFFFFF
/// Alias:   CRC_32/ADCCP
/// Use:     WinRAR,ect.
class CRC32 extends CRCChecksum {
  @override
  int getValue() {
    return ~wCRCin & 0xffffffff;
  }

  @override
  void reset() {
    wCRCin = 0xffffffff;
  }

  @override
  void updateInt(int b) {
    wCRCin ^= b;
    for (var i = 0; i < 8; ++i) {
      if ((wCRCin & 1) != 0) {
        // 0xEDB88320= reverse 0x04C11DB7
        wCRCin = ((wCRCin >> 1) ^ 0xEDB88320) & 0xffffffff;
      } else {
        wCRCin = (wCRCin >> 1) & 0xffffffff;
      }
    }
  }
}

/// Name:    CRC-32/MPEG-2  x32+x26+x23+x22+x16+x12+x11+x10+x8+x7+x5+x4+x2+x+1
/// Poly:    0x4C11DB7
/// Init:    0xFFFFFFF
/// Refin:   False
/// Refout:  False
/// Xorout:  0x0000000
/// Note:
class CRC32MPEG2 extends CRCChecksum {
  @override
  int getValue() {
    return wCRCin & 0xffffffff;
  }

  @override
  void reset() {
    wCRCin = 0xffffffff;
  }

  @override
  void updateInt(int b) {
    wCRCin ^= b << 24;
    for (var i = 0; i < 8; ++i) {
      if ((wCRCin & 0x80000000) != 0) {
        wCRCin = (wCRCin << 1) ^ 0x04C11DB7 & 0xffffffff;
      } else {
        wCRCin <<= 1 & 0xffffffff;
      }
    }
  }
}
