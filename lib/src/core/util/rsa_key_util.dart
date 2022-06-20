import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/export.dart';
import 'package:yx_tool/yx_tool.dart';

/// RSA 密钥工具
class RSAKeyUtil {
  RSAKeyUtil._();

  /// 生成RSA公钥私钥.
  /// 默认使用Fortuna随机数生成器（使用安全性较低的随机种子初始化）
  /// [bitLength],位强度（例如 2048 或 4096）
  static AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateKeyPair({SecureRandom? secureRandom, int bitLength = 2048}) {
    var keyGen = RSAKeyGenerator();
    secureRandom = secureRandom ?? SecureRandom('Fortuna')
      ..seed(KeyParameter(RandomUtil.randomUint8s(len: 32)));
    // 要使用的公共指数（必须是奇数）
    var rsaKeyGeneratorParameters = RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64);
    var parametersWithRandom = ParametersWithRandom(rsaKeyGeneratorParameters, secureRandom);
    keyGen.init(parametersWithRandom);
    var generateKeyPair = keyGen.generateKeyPair();
    return AsymmetricKeyPair(generateKeyPair.publicKey as RSAPublicKey, generateKeyPair.privateKey as RSAPrivateKey);
  }

  /// 公钥转byte, 默认使用pkcs8格式
  static Uint8List publicKeyToBytes(RSAPublicKey publicKey, {bool rsaPublicKeyFormat = false}) {
    var asn1sequence = ASN1Sequence(elements: [
      ASN1Integer(publicKey.modulus),
      ASN1Integer(publicKey.exponent),
    ]);

    if (rsaPublicKeyFormat) {
      return asn1sequence.encode();
    }

    // pkcs8
    var algorithmSeq = ASN1Sequence();
    var algorithmAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList([0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
    var paramsAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
    algorithmSeq.add(algorithmAsn1Obj);
    algorithmSeq.add(paramsAsn1Obj);

    var publicKeySeqBitString = ASN1BitString(stringValues: asn1sequence.encode());

    var topLevelSeq = ASN1Sequence();
    topLevelSeq.add(algorithmSeq);
    topLevelSeq.add(publicKeySeqBitString);

    return topLevelSeq.encode();
  }

  /// 私钥转byte
  static Uint8List privateKeyToBytes(RSAPrivateKey privateKey, {bool rsaPublicKeyFormat = false}) {
    var version = ASN1Integer(BigInt.from(0));

    var privateKeySeq = ASN1Sequence(elements: [
      version, // version
      ASN1Integer(privateKey.modulus), //modulus
      ASN1Integer(privateKey.publicExponent), //publicExponent
      ASN1Integer(privateKey.privateExponent), //privateExponent
      ASN1Integer(privateKey.p), //prime1
      ASN1Integer(privateKey.q), //prime2
      ASN1Integer(privateKey.privateExponent! % (privateKey.p! - BigInt.one)), //exponent1
      ASN1Integer(privateKey.privateExponent! % (privateKey.q! - BigInt.one)), //exponent2
      ASN1Integer(privateKey.q!.modInverse(privateKey.p!)), //coefficient
    ]);

    if (rsaPublicKeyFormat) {
      return privateKeySeq.encode();
    }

    // pkcs8
    var algorithmSeq = ASN1Sequence();
    var algorithmAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList([0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
    var paramsAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
    algorithmSeq.add(algorithmAsn1Obj);
    algorithmSeq.add(paramsAsn1Obj);

    var publicKeySeqOctetString = ASN1OctetString(octets: privateKeySeq.encode());

    var topLevelSeq = ASN1Sequence();
    topLevelSeq.add(version);
    topLevelSeq.add(algorithmSeq);
    topLevelSeq.add(publicKeySeqOctetString);
    return topLevelSeq.encode();
  }

  /// 公钥转base64字符串
  static String publicKeyToString(RSAPublicKey publicKey, {bool rsaPublicKeyFormat = false}) {
    return base64Encode(publicKeyToBytes(publicKey, rsaPublicKeyFormat: rsaPublicKeyFormat));
  }

  /// 私钥转base64字符串
  static String privateKeyToString(RSAPrivateKey privateKey, {bool rsaPublicKeyFormat = false}) {
    return base64Encode(privateKeyToBytes(privateKey, rsaPublicKeyFormat: rsaPublicKeyFormat));
  }

  /// 公钥转PEM
  static String publicKeyToPem(RSAPublicKey publicKey, {bool rsaPublicKeyFormat = false}) {
    var publicKeyText = publicKeyToString(publicKey, rsaPublicKeyFormat: rsaPublicKeyFormat);
    if (rsaPublicKeyFormat) {
      return '-----BEGIN RSA PUBLIC KEY-----\r\n$publicKeyText\r\n-----END RSA PUBLIC KEY-----';
    } else {
      return '-----BEGIN PUBLIC KEY-----\r\n$publicKeyText\r\n-----END PUBLIC KEY-----';
    }
  }

  /// 私钥转PEM
  static String privateKeyToPem(RSAPrivateKey privateKey, {bool rsaPublicKeyFormat = false}) {
    var privateKeyText = privateKeyToString(privateKey, rsaPublicKeyFormat: rsaPublicKeyFormat);
    if (rsaPublicKeyFormat) {
      return '-----BEGIN RSA PRIVATE KEY-----\r\n$privateKeyText\r\n-----END RSA PRIVATE KEY-----';
    } else {
      return '-----BEGIN PRIVATE KEY-----\r\n$privateKeyText\r\n-----END PRIVATE KEY-----';
    }
  }

  /// 解析公钥字符串
  static RSAPublicKey parsePublicKey(String publicKey) {
    return RSAKeyParser.parsePublic(publicKey);
  }

  /// 解析私钥字符串
  static RSAPrivateKey parsePrivateKey(String privateKey) {
    return RSAKeyParser.parsePrivate(privateKey);
  }

  /// 私钥转公钥
  static RSAPublicKey privateKeyToPublicKey(RSAPrivateKey privateKey) {
    return RSAPublicKey(privateKey.modulus!, privateKey.publicExponent!);
  }
}
