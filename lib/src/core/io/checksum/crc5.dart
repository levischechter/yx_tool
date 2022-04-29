import 'package:yx_tool/src/core/io/checksum/crc_checksum.dart';

/// Name:    CRC-5/EPC           x5+x3+1
/// Poly:    0x09
/// Init:    0x09
/// Refin:   False
/// Refout:  False
/// Xorout:  0x00
/// Note:
class CRC5EPC extends CRCChecksum {
  @override
  int getValue() {
    return wCRCin >> 3 & 0x1f;
  }

  @override
  void reset() {
    // Initial value: 0x48 = 0x09<<(8-5)
    wCRCin = 0x48;
  }

  @override
  void updateInt(int b) {
    wCRCin ^= b;
    for (var i = 0; i < 8; i++) {
      if ((wCRCin & 0x80) != 0) {
        wCRCin = ((wCRCin << 1) ^ 0x48) & 0xff; // 0x48 = 0x09<<(8-5)
      } else {
        wCRCin <<= 1;
      }
    }
  }
}

/// Name:    CRC-5/EPC           x5+x3+1
/// Poly:    0x09
/// Init:    0x09
/// Refin:   False
/// Refout:  False
/// Xorout:  0x00
/// Note:
class CRC5ITU extends CRCChecksum {
  @override
  int getValue() {
    return wCRCin & 0x1f;
  }

  @override
  void updateInt(int b) {
    wCRCin ^= b;
    for (var i = 0; i < 8; ++i) {
      if ((wCRCin & 1) == 0) {
        wCRCin = ((wCRCin & 0xff) >> 1) & 0xff;
      } else {
        // 0x15 = (reverse 0x15)>>(8-5)
        wCRCin = (((wCRCin & 0xff) >> 1) ^ 0x15) & 0xff;
      }
    }
  }
}

/// Name:    CRC-5/USB           x5+x2+1
/// Poly:    0x05
/// Init:    0x1F
/// Refin:   True
/// Refout:  True
/// Xorout:  0x1F
/// Note:
class CRC5USB extends CRCChecksum {
  @override
  int getValue() {
    return wCRCin ^ 0x1F & 0x1f;
  }

  @override
  void reset() {
    // Initial value
    wCRCin = 0x1F;
  }

  @override
  void updateInt(int b) {
    wCRCin ^= b;
    for (var i = 0; i < 8; ++i) {
      if ((wCRCin & 1) == 0) {
        wCRCin = ((wCRCin & 0xff) >> 1) & 0xff;
      } else {
        // 0x14 = (reverse 0x05)>>(8-5)
        wCRCin = (((wCRCin & 0xff) >> 1) ^ 0x14) & 0xff;
      }
    }
  }
}
