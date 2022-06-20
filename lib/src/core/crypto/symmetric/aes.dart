import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:yx_tool/src/core/crypto/symmetric/symmetric_crypto.dart';

enum AESMode {
  ///无模式
  none,

  ///密码分组连接模式（Cipher Block Chaining），使用块
  cbc,

  ///密文反馈模式（Cipher Feedback），使用块
  cfb_64,

  ///计数器模式（A simplification of OFB）,使用流
  ctr,

  ///电子密码本模式（Electronic CodeBook），使用块
  ecb,

  ///输出反馈模式（Output Feedback），使用块
  ofb64,

  ///GOST 28147 OFB计数器模式，使用块
  ofb64Gctr,

  ///计数器模式,使用流
  sic,

  ///伽罗瓦计数器模式，使用块
  gcm,

  ///无限乱码扩展，使用块
  ige,

  ///带有 CBC-MAC 的计数器，使用块
  ccm,
}

enum AESPadding {
  ///无补码
  noPadding,

  ///PKCS7/PKCS5 padding to a block
  pkcs7Padding,

  ///根据ISO 9797-1中ISO 7814-4-方案2中引用的方案添加填充物的填充器。第一个字节是0x80，其余字节是0x00
  iso7816d4
}

///AES加密算法实现<br>
///高级加密标准（英语：Advanced Encryption Standard，缩写：AES），在密码学中又称Rijndael加密法<br>
///相关概念说明：<br>
/// mode:    加密算法模式，是用来描述加密算法（此处特指分组密码，不包括流密码，）在加密时对明文分组的模式，它代表了不同的分组方式<br>
/// padding: 补码方式是在分组密码中，当明文长度不是分组长度的整数倍时，需要在最后一个分组中填充一些数据使其凑满一个分组的长度。<br>
/// iv:      在对明文分组加密时，会将明文分组与前一个密文分组进行XOR运算（即异或运算），但是加密第一个明文分组时不存在“前一个密文分组”，<br>
///因此需要事先准备一个与分组长度相等的比特序列来代替，这个比特序列就是偏移量。
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
      case AESMode.none:
        _blockCipher = engine;
        break;
      case AESMode.cbc:
        _blockCipher = CBCBlockCipher(engine);
        break;
      case AESMode.cfb_64:
        _blockCipher = CFBBlockCipher(engine, 8);
        break;
      case AESMode.ctr:
        _streamCipher = CTRStreamCipher(engine);
        break;
      case AESMode.ecb:
        _blockCipher = ECBBlockCipher(engine);
        break;
      case AESMode.ofb64:
        _blockCipher = OFBBlockCipher(engine, 8);
        break;
      case AESMode.ofb64Gctr:
        _blockCipher = GCTRBlockCipher(OFBBlockCipher(engine, 8));
        break;
      case AESMode.gcm:
        _blockCipher = GCMBlockCipher(engine);
        break;
      case AESMode.ige:
        _blockCipher = IGEBlockCipher(engine);
        break;
      case AESMode.ccm:
        _blockCipher = CCMBlockCipher(engine);
        break;
      case AESMode.sic:
        _streamCipher = SICStreamCipher(engine);
        break;
    }
    if (_blockCipher != null) {
      // 补码
      switch (padding) {
        case AESPadding.noPadding:
          break;
        case AESPadding.pkcs7Padding:
          _blockCipher = PaddedBlockCipherImpl(PKCS7Padding(), _blockCipher!);
          break;
        case AESPadding.iso7816d4:
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
    if (mode == AESMode.gcm) {
      return AEADParameters(KeyParameter(key), 128, iv!, associatedData ?? Uint8List.fromList([]));
    }

    if (padding != AESPadding.noPadding) {
      if (mode == AESMode.ecb) {
        return PaddedBlockCipherParameters(KeyParameter(key), null);
      }

      return PaddedBlockCipherParameters(ParametersWithIV<KeyParameter>(KeyParameter(key), iv!), null);
    }

    if (mode == AESMode.ecb) {
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
