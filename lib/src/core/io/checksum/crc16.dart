import 'dart:typed_data';

import 'package:yx_tool/src/core/io/checksum/checksum.dart';
import 'package:yx_tool/src/core/util/hex_util.dart';
import 'package:yx_tool/src/core/util/str_util.dart';

abstract class CRC16Checksum extends Checksum {
  ///CRC16 Checksum 结果值
  late int wCRCin;

  CRC16Checksum() {
    reset();
  }

  @override
  int getValue() {
    return wCRCin;
  }

  /// 获取16进制的CRC16值
  /// param [isPadding] 不足4位时，是否填充0以满足位数
  /// return 16进制的CRC16值，4位
  @override
  String getHexValue([bool isPadding = false]) {
    var hex = HexUtil.toHex(getValue());
    if (isPadding) {
      hex = StrUtil.padLeft(hex, 4, '0');
    }
    return hex;
  }

  @override
  void reset() {
    wCRCin = 0x0000;
  }

  @override
  void update(Uint8List b, [int off = 0, int? len]) {
    len ??= b.length;
    for (var i = off; i < off + len; i++) {
      updateInt(b[i]);
    }
  }
}

///CRC16_IBM：多项式x16+x15+x2+1（0x8005），初始值0x0000，低位在前，高位在后，结果与0x0000异或
///0xA001是0x8005按位颠倒后的结果
class CRC16IBM extends CRC16Checksum {
  static final int _WC_POLY = 0xa001;

  @override
  void updateInt(int b) {
    wCRCin ^= (b & 0x00ff);
    for (var i = 0; i < 8; i++) {
      if ((wCRCin & 0x0001) != 0) {
        wCRCin >>= 1;
        wCRCin ^= _WC_POLY;
      } else {
        wCRCin >>= 1;
      }
    }
  }
}

/// CRC16_ANSI
class CRC16Ansi extends CRC16Checksum {
  static final int _WC_POLY = 0xa001;

  @override
  void reset() {
    wCRCin = 0xffff;
  }

  @override
  void updateInt(int b) {
    var hi = wCRCin >> 8;
    hi ^= b;
    wCRCin = hi;

    for (var i = 0; i < 8; i++) {
      var flag = wCRCin & 0x0001;
      wCRCin = wCRCin >> 1;
      if (flag == 1) {
        wCRCin ^= _WC_POLY;
      }
    }
  }
}

/// CRC16_CCITT：多项式x16+x12+x5+1（0x1021），初始值0x0000，低位在前，高位在后，结果与0x0000异或
/// 0x8408是0x1021按位颠倒后的结果。
class CRC16CCITT extends CRC16Checksum {
  static final int _WC_POLY = 0x8408;

  @override
  void updateInt(int b) {
    wCRCin ^= (b & 0x00ff);
    for (var j = 0; j < 8; j++) {
      if ((wCRCin & 0x0001) != 0) {
        wCRCin >>= 1;
        wCRCin ^= _WC_POLY;
      } else {
        wCRCin >>= 1;
      }
    }
  }
}

/// CRC16_CCITT_FALSE：多项式x16+x12+x5+1（0x1021），初始值0xFFFF，低位在后，高位在前，结果与0x0000异或
class CRC16CCITTFalse extends CRC16Checksum {
  static final int _WC_POLY = 0x1021;

  @override
  void reset() {
    wCRCin = 0xffff;
  }

  @override
  void update(Uint8List b, [int off = 0, int? len]) {
    super.update(b, off, len);
    wCRCin &= 0xffff;
  }

  @override
  void updateInt(int b) {
    for (var i = 0; i < 8; i++) {
      var bit = ((b >> (7 - i) & 1) == 1);
      var c15 = ((wCRCin >> 15 & 1) == 1);
      wCRCin <<= 1;
      if (c15 ^ bit) {
        wCRCin ^= _WC_POLY;
      }
    }
  }
}

/// CRC16_DNP：多项式x16+x13+x12+x11+x10+x8+x6+x5+x2+1（0x3D65），初始值0x0000，低位在前，高位在后，结果与0xFFFF异或
/// 0xA6BC是0x3D65按位颠倒后的结果
class CRC16DNP extends CRC16Checksum {
  static final int _WC_POLY = 0xA6BC;

  @override
  void update(Uint8List b, [int off = 0, int? len]) {
    super.update(b, off, len);
    wCRCin ^= 0xffff;
  }

  @override
  void updateInt(int b) {
    wCRCin ^= (b & 0x00ff);
    for (var j = 0; j < 8; j++) {
      if ((wCRCin & 0x0001) != 0) {
        wCRCin >>= 1;
        wCRCin ^= _WC_POLY;
      } else {
        wCRCin >>= 1;
      }
    }
  }
}

/// CRC16_MAXIM：多项式x16+x15+x2+1（0x8005），初始值0x0000，低位在前，高位在后，结果与0xFFFF异或
/// 0xA001是0x8005按位颠倒后的结果
class CRC16Maxim extends CRC16Checksum {
  static final int _WC_POLY = 0xa001;

  @override
  void update(Uint8List b, [int off = 0, int? len]) {
    super.update(b, off, len);
    wCRCin ^= 0xffff;
  }

  @override
  void updateInt(int b) {
    wCRCin ^= (b & 0x00ff);
    for (var j = 0; j < 8; j++) {
      if ((wCRCin & 0x0001) != 0) {
        wCRCin >>= 1;
        wCRCin ^= _WC_POLY;
      } else {
        wCRCin >>= 1;
      }
    }
  }
}

/// CRC-16 (Modbus)
/// CRC16_MODBUS：多项式x16+x15+x2+1（0x8005），初始值0xFFFF，低位在前，高位在后，结果与0x0000异或
/// 0xA001是0x8005按位颠倒后的结果
class CRC16Modbus extends CRC16Checksum {
  static final int _WC_POLY = 0xa001;

  @override
  void reset() {
    wCRCin = 0xffff;
  }

  @override
  void updateInt(int b) {
    wCRCin ^= (b & 0x00ff);
    for (var j = 0; j < 8; j++) {
      if ((wCRCin & 0x0001) != 0) {
        wCRCin >>= 1;
        wCRCin ^= _WC_POLY;
      } else {
        wCRCin >>= 1;
      }
    }
  }
}

/// CRC16_USB：多项式x16+x15+x2+1（0x8005），初始值0xFFFF，低位在前，高位在后，结果与0xFFFF异或
/// 0xA001是0x8005按位颠倒后的结果
class CRC16USB extends CRC16Checksum {
  static final int _WC_POLY = 0xa001;

  @override
  void reset() {
    wCRCin = 0xFFFF;
  }

  @override
  void update(Uint8List b, [int off = 0, int? len]) {
    super.update(b, off, len);
    wCRCin ^= 0xffff;
  }

  @override
  void updateInt(int b) {
    wCRCin ^= (b & 0x00ff);
    for (var j = 0; j < 8; j++) {
      if ((wCRCin & 0x0001) != 0) {
        wCRCin >>= 1;
        wCRCin ^= _WC_POLY;
      } else {
        wCRCin >>= 1;
      }
    }
  }
}

/// CRC16_X25：多项式x16+x12+x5+1（0x1021），初始值0xffff，低位在前，高位在后，结果与0xFFFF异或
/// 0x8408是0x1021按位颠倒后的结果。
class CRC16X25 extends CRC16Checksum {
  static final int _WC_POLY = 0x8408;

  @override
  void reset() {
    wCRCin = 0xffff;
  }

  @override
  void update(Uint8List b, [int off = 0, int? len]) {
    super.update(b, off, len);
    wCRCin ^= 0xffff;
  }

  @override
  void updateInt(int b) {
    wCRCin ^= (b & 0x00ff);
    for (var j = 0; j < 8; j++) {
      if ((wCRCin & 0x0001) != 0) {
        wCRCin >>= 1;
        wCRCin ^= _WC_POLY;
      } else {
        wCRCin >>= 1;
      }
    }
  }
}

/// CRC-CCITT (XModem)
/// CRC16_XMODEM：多项式x16+x12+x5+1（0x1021），初始值0x0000，低位在后，高位在前，结果与0x0000异或
class CRC16XModem extends CRC16Checksum {
  // 0001 0000 0010 0001 (0, 5, 12)
  static final int _WC_POLY = 0x1021;

  @override
  void update(Uint8List b, [int off = 0, int? len]) {
    super.update(b, off, len);
    wCRCin &= 0xffff;
  }

  @override
  void updateInt(int b) {
    for (var i = 0; i < 8; i++) {
      var bit = ((b >> (7 - i) & 1) == 1);
      var c15 = ((wCRCin >> 15 & 1) == 1);
      wCRCin <<= 1;
      if (c15 ^ bit) {
        wCRCin ^= _WC_POLY;
      }
    }
  }
}
