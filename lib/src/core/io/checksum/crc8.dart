import 'package:yx_tool/src/core/io/checksum/crc_checksum.dart';

/// Name:    CRC-8               x8+x2+x+1
/// Poly:    0x07
/// Init:    0x00
/// Refin:   False
/// Refout:  False
/// Xorout:  0x00
/// Note:
class CRC8 extends CRCChecksum {
  static final int _poly = 0x07;

  @override
  void updateInt(int b) {
    wCRCin ^= b;
    for (var i = 0; i < 8; i++) {
      if ((wCRCin & 0x80) == 0) {
        wCRCin <<= 1;
      } else {
        wCRCin = ((wCRCin << 1) ^ _poly) & 0xff;
      }
    }
  }

  @override
  int getValue() {
    return wCRCin & 0xff;
  }
}

/// Name:    CRC-8/ITU           x8+x2+x+1<br>
/// Poly:    0x07<br>
/// Init:    0x00<br>
/// Refin:   False<br>
/// Refout:  False<br>
/// Xorout:  0x55<br>
/// Alias:   CRC-8/ATM<br>
class CRC8ITU extends CRCChecksum {
  static final int _poly = 0x07;

  @override
  void updateInt(int b) {
    wCRCin ^= b;
    for (var i = 0; i < 8; i++) {
      if ((wCRCin & 0x80) == 0) {
        wCRCin <<= 1;
      } else {
        wCRCin = ((wCRCin << 1) ^ _poly) & 0xff;
      }
    }
  }

  @override
  int getValue() {
    return wCRCin ^ 0x55 & 0xff;
  }
}

/// Name:    CRC-8/ROHC          x8+x2+x+1
/// Poly:    0x07
/// Init:    0xFF
/// Refin:   True
/// Refout:  True
/// Xorout:  0x00
/// Note:
class CRC8ROHC extends CRCChecksum {
  static final int _poly = 0xE0;

  @override
  void updateInt(int b) {
    wCRCin ^= b;
    for (var i = 0; i < 8; i++) {
      if ((wCRCin & 0x01) == 0) {
        wCRCin = ((wCRCin & 0xff) >> 1) & 0xff;
      } else {
        wCRCin = (((wCRCin & 0xff) >> 1) ^ _poly) & 0xff;
      }
    }
  }

  @override
  void reset() {
    wCRCin = 0xFF;
  }

  @override
  int getValue() {
    return wCRCin & 0xff;
  }
}

/// Name:    CRC-8/MAXIM         x8+x5+x4+1
/// Poly:    0x31
/// Init:    0x00
/// Refin:   True
/// Refout:  True
/// Xorout:  0x00
/// Alias:   DOW-CRC,CRC-8/IBUTTON
/// Use:     Maxim(Dallas)'s some devices,e.g. DS18B20
class CRC8MAXIM extends CRCChecksum {
  @override
  void updateInt(int b) {
    wCRCin ^= b;
    for (var i = 0; i < 8; i++) {
      if ((wCRCin & 1) == 0) {
        wCRCin = ((wCRCin & 0xff) >> 1) & 0xff;
      } else {
        wCRCin = (((wCRCin & 0xff) >> 1) ^ 0x8C) & 0xff;
      }
    }
  }

  @override
  int getValue() {
    return wCRCin & 0xff;
  }
}
