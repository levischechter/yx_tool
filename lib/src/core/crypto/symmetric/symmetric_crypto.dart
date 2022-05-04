import 'dart:typed_data';

import 'package:yx_tool/src/core/util/hex_util.dart';
import 'package:yx_tool/src/core/util/str_util.dart';

abstract class SymmetricCrypto {
  /// 加密
  Uint8List encrypt(Uint8List data);

  /// 解密
  Uint8List decrypt(Uint8List data);

  /// 加密并使用十六进制输出
  String encryptHex(Uint8List data) {
    return HexUtil.encodeHex(encrypt(data));
  }

  /// utf8编码后加密
  Uint8List encryptStr(String data) {
    return encrypt(StrUtil.encodeUtf8(data));
  }

  /// 加密并使用十六进制输出
  String encryptStrHex(String data) {
    return HexUtil.encodeHex(encrypt(StrUtil.encodeUtf8(data)));
  }

  /// 解密并使用十六进制输出
  String decryptHex(Uint8List data) {
    return HexUtil.encodeHex(decrypt(data));
  }

  /// 解密并使用utf8解码输出
  String decryptStr(Uint8List data) {
    return StrUtil.decode(decrypt(data));
  }
}
