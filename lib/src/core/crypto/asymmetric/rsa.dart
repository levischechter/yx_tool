import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/export.dart';
import 'package:yx_tool/src/core/crypto/asymmetric/asymmetric.dart';
import 'package:yx_tool/src/core/util/rsa_key_util.dart';

///非对称加密填充
enum RSAEncoding {
  ///RSA 加密方案最优非对称加密填充 (RSAAES-OAEP) 由 OAEPEncoding 类实现。
  oaep,

  ///PKCS 1 版本 1.5 (RSAES-PKCS1-v1_5) 中的 RSA 加密方案由 PKCS1Encoding 类实现。
  pkcs1,
}

///RSA公钥/私钥/签名加密解密<br/>
///罗纳德·李维斯特（Ron [R]ivest）、阿迪·萨莫尔（Adi [S]hamir）和伦纳德·阿德曼（Leonard [A]dleman）<br>
///由于非对称加密速度极其缓慢，一般文件不使用它来加密而是使用对称加密，<br>
///非对称加密算法可以用来对对称加密的密钥加密，这样保证密钥的安全也就保证了数据的安全
class RSA extends Asymmetric {
  /// 非对称分组密码器
  late AsymmetricBlockCipher _cipher;

  /// 算法签名对象
  late Signer signer;

  /// 自动生成公钥、私钥对时的位大小
  int bitLength;

  factory RSA({
    RSAPublicKey? publicKey,
    RSAPrivateKey? privateKey,
    String? privateKeyText,
    String? publicKeyText,
    Digest? digest,
    RSAEncoding encoding = RSAEncoding.pkcs1,
    int bitLength = 2048,
  }) {
    return RSA._(
      publicKey: publicKey ?? (publicKeyText != null ? RSAKeyParser.parsePublic(publicKeyText) : null),
      privateKey: privateKey ?? (privateKeyText != null ? RSAKeyParser.parsePrivate(privateKeyText) : null),
      digest: digest ?? SHA256Digest(),
      encoding: encoding,
      bitLength: bitLength,
    );
  }

  RSA._({required super.digest, super.privateKey, super.publicKey, RSAEncoding encoding = RSAEncoding.pkcs1, this.bitLength = 2048}) {
    switch (encoding) {
      case RSAEncoding.oaep:
        _cipher = OAEPEncoding.withCustomDigest(() => digest, RSAEngine());
        break;
      case RSAEncoding.pkcs1:
        _cipher = PKCS1Encoding(RSAEngine());
    }
    _init();
  }

  factory RSA.oaep({RSAPrivateKey? privateKey, RSAPublicKey? publicKey, Digest? digest}) {
    return RSA._(digest: digest ?? SHA256Digest(), privateKey: privateKey, publicKey: publicKey, encoding: RSAEncoding.oaep);
  }

  factory RSA.pkcs({RSAPrivateKey? privateKey, RSAPublicKey? publicKey, Digest? digest}) {
    return RSA._(digest: digest ?? SHA256Digest(), privateKey: privateKey, publicKey: publicKey);
  }

  /// 设置私钥
  void setPrivateKey(String privateKey) {
    this.privateKey = RSAKeyParser.parsePrivate(privateKey);
  }

  // 设置公钥
  void setPublicKey(String publicKey) {
    this.publicKey = RSAKeyParser.parsePublic(publicKey);
  }

  /// 初始化秘钥
  void _init() {
    if (privateKey == null && publicKey == null) {
      var generateKeyPair = RSAKeyUtil.generateKeyPair(bitLength: bitLength);
      publicKey = generateKeyPair.publicKey;
      privateKey = generateKeyPair.privateKey;
    }
    signer = Signer('${digest.algorithmName}/RSA');
  }

  PublicKeyParameter<RSAPublicKey>? get _publicKeyParams => publicKey != null ? PublicKeyParameter(publicKey!) : null;

  PrivateKeyParameter<RSAPrivateKey>? get _privateKeyParams => privateKey != null ? PrivateKeyParameter(privateKey!) : null;

  @override
  Uint8List decrypt({bool isPublicKey = false, required Uint8List data}) {
    if (isPublicKey && publicKey == null) {
      throw StateError('Can\'t encrypt without a public key, null given.');
    } else if (!isPublicKey && privateKey == null) {
      throw StateError('Can\'t encrypt without a private key, null given.');
    }
    _cipher
      ..reset()
      ..init(false, isPublicKey ? _publicKeyParams! : _privateKeyParams!);
    return _processInBlocks(_cipher, data);
  }

  @override
  Uint8List encrypt({bool isPublicKey = true, required Uint8List data}) {
    if (isPublicKey && publicKey == null) {
      throw StateError('Can\'t encrypt without a public key, null given.');
    } else if (!isPublicKey && privateKey == null) {
      throw StateError('Can\'t encrypt without a private key, null given.');
    }
    _cipher
      ..reset()
      ..init(true, isPublicKey ? _publicKeyParams! : _privateKeyParams!);
    return _processInBlocks(_cipher, data);
  }

  /// 对传入的 [message] 进行签名（通常是哈希函数的输出）
  RSASignature generateSignature({bool isPublicKey = false, required Uint8List message}) {
    if (isPublicKey && publicKey == null) {
      throw StateError('Can\'t encrypt without a public key, null given.');
    } else if (!isPublicKey && privateKey == null) {
      throw StateError('Can\'t encrypt without a private key, null given.');
    }
    signer
      ..reset()
      ..init(true, isPublicKey ? _publicKeyParams! : _privateKeyParams!);
    return signer.generateSignature(message) as RSASignature;
  }

  /// 根据 [签名] 验证 [消息]。
  bool verifySignature({bool isPublicKey = true, required Uint8List message, required Signature signature}) {
    if (isPublicKey && publicKey == null) {
      throw StateError('Can\'t encrypt without a public key, null given.');
    } else if (!isPublicKey && privateKey == null) {
      throw StateError('Can\'t encrypt without a private key, null given.');
    }
    signer
      ..reset()
      ..init(false, isPublicKey ? _publicKeyParams! : _privateKeyParams!);
    try {
      return signer.verifySignature(message, signature);
    } on ArgumentError {
      return false;
    }
  }

  /// 执行解码块
  /// 正在加密/解密的数据必须以块的形式进行处理。每个输入块被处理成一个输出块
  Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize + ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

    final output = Uint8List(numBlocks * engine.outputBlockSize);

    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize = (inputOffset + engine.inputBlockSize <= input.length) ? engine.inputBlockSize : input.length - inputOffset;

      outputOffset += engine.processBlock(input, inputOffset, chunkSize, output, outputOffset);

      inputOffset += chunkSize;
    }

    return (output.length == outputOffset) ? output : output.sublist(0, outputOffset);
  }
}

/// RSA PEM parser.
class RSAKeyParser {
  static const String beginRsaPublicKey = '-----BEGIN RSA PUBLIC KEY-----';
  static const String beginPublicKey = '-----BEGIN PUBLIC KEY-----';
  static const String beginRsaPrivateKey = '-----BEGIN RSA PRIVATE KEY-----';
  static const String beginPrivateKey = '-----BEGIN PRIVATE KEY-----';

  /// Parses the PEM key no matter it is public or private, it will figure it out.
  static RSAAsymmetricKey parse(String key) {
    final rows = key.split(RegExp(r'\r\n?|\n'));
    final header = rows.first;

    if (header == beginRsaPublicKey || header == beginPublicKey) {
      return parsePublic(key);
    }

    if (header == beginRsaPrivateKey || header == beginPrivateKey) {
      return parsePrivate(key);
    }

    throw FormatException('Unable to parse key, invalid format.', header);
  }

  /// Parses the PEM key no matter it is public, it will figure it out.
  static RSAPublicKey parsePublic(String publicKey) {
    var index = 0;
    if ((index = publicKey.indexOf(beginRsaPublicKey)) != -1) {
      index = index + beginRsaPublicKey.length;
    } else if ((index = publicKey.indexOf(beginPublicKey)) != -1) {
      index = index + beginPublicKey.length;
    } else {
      index = 0;
    }
    return _parsePublic(_parseSequence(index, publicKey)) as RSAPublicKey;
  }

  /// Parses the PEM key no matter it is private, it will figure it out.
  static RSAPrivateKey parsePrivate(String privateKey) {
    var index = 0;
    if ((index = privateKey.indexOf(beginRsaPrivateKey)) != -1) {
      index = index + beginRsaPrivateKey.length;
    } else if ((index = privateKey.indexOf(beginPrivateKey)) != -1) {
      index = index + beginPrivateKey.length;
    } else {
      index = 0;
    }
    return _parsePrivate(_parseSequence(index, privateKey)) as RSAPrivateKey;
  }

  static RSAAsymmetricKey _parsePublic(ASN1Sequence sequence) {
    var isPublicKeyFormat = sequence.elements!.any((element) => element is! ASN1Integer);
    if (isPublicKeyFormat) {
      sequence = _pkcs8PublicSequence(sequence);
    }
    final modulus = (sequence.elements![0] as ASN1Integer).integer;
    final exponent = (sequence.elements![1] as ASN1Integer).integer;

    return RSAPublicKey(modulus!, exponent!);
  }

  static RSAAsymmetricKey _parsePrivate(ASN1Sequence sequence) {
    var isPrivateKeyFormat = sequence.elements!.any((element) => element is! ASN1Integer);
    if (isPrivateKeyFormat) {
      sequence = _pkcs8PrivateSequence(sequence);
    }
    final modulus = (sequence.elements![1] as ASN1Integer).integer;
    final exponent = (sequence.elements![3] as ASN1Integer).integer;
    final p = (sequence.elements![4] as ASN1Integer).integer;
    final q = (sequence.elements![5] as ASN1Integer).integer;

    return RSAPrivateKey(modulus!, exponent!, p, q);
  }

  static ASN1Sequence _parseSequence(int index, String key) {
    int endIndex = key.length;
    if (index != 0) {
      endIndex = key.indexOf('-----END', index);
    }
    final keyText = key.substring(index, endIndex).replaceAll(RegExp(r'\r\n?|\n'), '');

    final keyBytes = Uint8List.fromList(base64.decode(keyText));
    final asn1Parser = ASN1Parser(keyBytes);

    return asn1Parser.nextObject() as ASN1Sequence;
  }

  static ASN1Sequence _pkcs8PublicSequence(ASN1Sequence sequence) {
    final ASN1Object bitString = sequence.elements![1];
    final bytes = bitString.valueBytes!.sublist(1);
    final parser = ASN1Parser(Uint8List.fromList(bytes));

    return parser.nextObject() as ASN1Sequence;
  }

  static ASN1Sequence _pkcs8PrivateSequence(ASN1Sequence sequence) {
    final ASN1Object bitString = sequence.elements![2];
    final bytes = bitString.valueBytes;
    final parser = ASN1Parser(bytes);

    return parser.nextObject() as ASN1Sequence;
  }
}
