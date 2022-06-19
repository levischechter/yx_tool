import 'dart:typed_data';

import 'package:pointycastle/export.dart';

abstract class Asymmetric {
  /// 摘要算法
  Digest digest;

  /// 公钥
  RSAPublicKey? publicKey;

  /// 私钥
  RSAPrivateKey? privateKey;

  Asymmetric({required this.digest, this.publicKey, this.privateKey});

  /// 加密
  Uint8List encrypt({bool isPublicKey = true, required Uint8List data});

  /// 解密
  Uint8List decrypt({bool isPublicKey = false, required Uint8List data});
}
