import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:yx_tool/src/core/crypto/symmetric/symmetric_crypto.dart';

enum AESMode {
  ///无模式
  NONE,

  ///密码分组连接模式（Cipher Block Chaining），使用块
  CBC,

  ///密文反馈模式（Cipher Feedback），使用块
  CFB_64,

  ///计数器模式（A simplification of OFB）,使用流
  CTR,

  ///电子密码本模式（Electronic CodeBook），使用块
  ECB,

  ///输出反馈模式（Output Feedback），使用块
  OFB_64,

  ///GOST 28147 OFB计数器模式，使用块
  OFB_64_GCTR,

  ///计数器模式,使用流
  SIC,

  ///伽罗瓦计数器模式，使用块
  GCM,

  ///无限乱码扩展，使用块
  IGE,

  ///带有 CBC-MAC 的计数器，使用块
  CCM,
}
enum AESPadding {
  ///无补码
  NoPadding,

  ///PKCS7/PKCS5 padding to a block
  PKCS7Padding,

  ///根据ISO 9797-1中ISO 7814-4-方案2中引用的方案添加填充物的填充器。第一个字节是0x80，其余字节是0x00
  ISO7816d4
}

class AES extends SymmetricCrypto {
  AESMode mode;
  AESPadding padding;
  BlockCipher? _blockCipher;
  StreamCipher? _streamCipher;
  Uint8List key;
  Uint8List? iv;

  AES(this.mode, this.padding, this.key, this.iv) {
    _init();
  }

  factory AES.withKey(AESMode mode, AESPadding padding, Uint8List key) {
    return AES(mode, padding, key, null);
  }

  void _init() {
    var engine = AESEngine();
    switch (mode) {
      case AESMode.NONE:
        _blockCipher = engine;
        break;
      case AESMode.CBC:
        _blockCipher = CBCBlockCipher(engine);
        break;
      case AESMode.CFB_64:
        _blockCipher = CFBBlockCipher(engine, 8);
        break;
      case AESMode.CTR:
        _streamCipher = CTRStreamCipher(engine);
        break;
      case AESMode.ECB:
        _blockCipher = ECBBlockCipher(engine);
        break;
      case AESMode.OFB_64:
        _blockCipher = OFBBlockCipher(engine, 8);
        break;
      case AESMode.OFB_64_GCTR:
        _blockCipher = GCTRBlockCipher(OFBBlockCipher(engine, 8));
        break;
      case AESMode.GCM:
        _blockCipher = GCMBlockCipher(engine);
        break;
      case AESMode.IGE:
        _blockCipher = IGEBlockCipher(engine);
        break;
      case AESMode.CCM:
        _blockCipher = CCMBlockCipher(engine);
        break;
      case AESMode.SIC:
        _streamCipher = SICStreamCipher(engine);
        break;
    }
    if (_blockCipher != null) {
      // 补码
      switch (padding) {
        case AESPadding.NoPadding:
          break;
        case AESPadding.PKCS7Padding:
          _blockCipher = PaddedBlockCipherImpl(PKCS7Padding(), _blockCipher!);
          break;
        case AESPadding.ISO7816d4:
          _blockCipher = PaddedBlockCipherImpl(ISO7816d4Padding(), _blockCipher!);
          break;
      }
    }
  }

  void _reset(bool forEncryption, {Uint8List? associatedData}) {
    if (_streamCipher != null) {
      _streamCipher!
        ..reset()
        ..init(forEncryption, _buildParams(associatedData));
    } else {
      _blockCipher!
        ..reset()
        ..init(forEncryption, _buildParams(associatedData));
    }
  }

  /// 构建参数
  CipherParameters _buildParams([Uint8List? associatedData]) {
    if (mode == AESMode.GCM) {
      return AEADParameters(KeyParameter(key), 128, iv!, associatedData ?? Uint8List.fromList([]));
    }

    if (padding != AESPadding.NoPadding) {
      if (mode == AESMode.ECB) {
        return PaddedBlockCipherParameters(KeyParameter(key), null);
      }

      return PaddedBlockCipherParameters(ParametersWithIV<KeyParameter>(KeyParameter(key), iv!), null);
    }

    if (mode == AESMode.ECB) {
      return KeyParameter(key);
    }

    return ParametersWithIV<KeyParameter>(KeyParameter(key), iv!);
  }

  @override
  Uint8List encrypt(Uint8List data, {Uint8List? associatedData}) {
    _reset(true, associatedData: associatedData);
    if (_streamCipher != null) {
      return _streamCipher!.process(data);
    } else {
      return _blockCipher!.process(data);
    }
  }

  @override
  Uint8List decrypt(Uint8List data, {Uint8List? associatedData}) {
    _reset(false, associatedData: associatedData);
    if (_streamCipher != null) {
      return _streamCipher!.process(data);
    } else {
      return _blockCipher!.process(data);
    }
  }
}
