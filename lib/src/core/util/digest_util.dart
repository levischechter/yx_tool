import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:yx_tool/src/core/extensions/string_extension.dart';
import 'package:yx_tool/src/core/security/crypto/bcrypt_password_encoder.dart';
import 'package:yx_tool/src/core/util/hex_util.dart';

/// 可以加盐的md5
Uint8List _md5(Uint8List data, {Uint8List? salt, int position = 0, int repeat = 1}) {
  var md5digest = MD5Digest();
  // 加盐
  if (salt != null) {
    if (position <= 0) {
      md5digest.update(salt, 0, salt.length);
      md5digest.update(data, 0, data.length);
    } else if (position >= data.length) {
      // 加盐在末尾，自动忽略空盐值
      md5digest.update(data, 0, data.length);
      md5digest.update(salt, 0, salt.length);
    } else {
      // 加盐在中间
      md5digest.update(data, 0, position);
      md5digest.update(salt, 0, salt.length);
      md5digest.update(data, position, data.length - position);
    }
  } else {
    md5digest.update(data, 0, data.length);
  }
  var out = Uint8List(md5digest.digestSize);
  md5digest.doFinal(out, 0);
  if (repeat > 1) {
    for (var i = 0; i < repeat - 1; i++) {
      out = _md5(out);
    }
  }
  return out;
}

/// 摘要算法
class DigestUtil {
  DigestUtil._();

  /// 将数据转为MD5 rfc哈希函数输出，当[isSimple]为true时，输出8位md5
  /// 使用[salt]加入盐，并且指定[position]存放的位置
  /// 使用[repeat]重复碰撞的次数
  static Uint8List md5(Uint8List data, {bool isSimple = false, String? salt, int position = 0, int repeat = 1}) {
    var bytes = _md5(data, salt: salt?.bytes, position: position, repeat: repeat);
    if (isSimple) {
      return bytes.sublist(4, 12);
    }
    return bytes;
  }

  /// 将字符串通过utf8编码后转为MD5 rfc哈希函数输出，当[isSimple]为true时，输出8位md5
  static Uint8List md5Str(String data, {bool isSimple = false, String? salt, int position = 0, int repeat = 1}) {
    return md5(data.bytes, isSimple: isSimple, salt: salt, position: position, repeat: repeat);
  }

  /// 将数据转为MD5 rfc哈希函数输出hex，当[isSimple]为true时，输出16位md5 hex值
  static String md5Hex(Uint8List data, {bool toUpperCase = false, bool isSimple = false, String? salt, int position = 0, int repeat = 1}) {
    return HexUtil.encodeHex(md5(data, isSimple: isSimple, salt: salt, position: position, repeat: repeat), toUpperCase: toUpperCase);
  }

  /// 将数据转为MD5 rfc哈希函数输出hex，当[isSimple]为true时，输出16位md5 hex值
  static String md5HexStr(String data, {bool toUpperCase = false, bool isSimple = false, String? salt, int position = 0, int repeat = 1}) {
    return md5Hex(data.bytes, isSimple: isSimple, toUpperCase: toUpperCase, salt: salt, position: position, repeat: repeat);
  }

  /// 将数据转为SHA-1 rfc哈希函数输出
  static Uint8List sha1(Uint8List data) {
    var sha1digest = SHA1Digest();
    return sha1digest.process(data);
  }

  /// 将字符串通过utf8编码后转为SHA-1 rfc哈希函数输出
  static Uint8List sha1Str(String data) {
    return sha1(data.bytes);
  }

  /// 将数据转为SHA-1 rfc哈希函数输出hex
  static String sha1Hex(Uint8List data, {bool toUpperCase = false}) {
    return HexUtil.encodeHex(sha1(data), toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA-1 rfc哈希函数输出hex
  static String sha1HexStr(String data, {bool toUpperCase = false}) {
    return sha1Hex(data.bytes, toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA-224 rfc哈希函数输出
  static Uint8List sha224(Uint8List data) {
    var sha224digest = SHA224Digest();
    return sha224digest.process(data);
  }

  /// 将字符串通过utf8编码后转为SHA-224 rfc哈希函数输出
  static Uint8List sha224Str(String data) {
    return sha224(data.bytes);
  }

  /// 将数据转为SHA-224 rfc哈希函数输出hex
  static String sha224Hex(Uint8List data, {bool toUpperCase = false}) {
    return HexUtil.encodeHex(sha224(data), toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA-224 rfc哈希函数输出hex
  static String sha224HexStr(String data, {bool toUpperCase = false}) {
    return sha224Hex(data.bytes, toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA-256 rfc哈希函数输出
  static Uint8List sha256(Uint8List data) {
    var sha256digest = SHA256Digest();
    return sha256digest.process(data);
  }

  /// 将字符串通过utf8编码后转为SHA-256 rfc哈希函数输出
  static Uint8List sha256Str(String data) {
    return sha256(data.bytes);
  }

  /// 将数据转为SHA-256 rfc哈希函数输出hex
  static String sha256Hex(Uint8List data, {bool toUpperCase = false}) {
    return HexUtil.encodeHex(sha256(data), toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA-256 rfc哈希函数输出hex
  static String sha256HexStr(String data, {bool toUpperCase = false}) {
    return sha256Hex(data.bytes, toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA-384 rfc哈希函数输出
  static Uint8List sha384(Uint8List data) {
    return SHA384Digest().process(data);
  }

  /// 将字符串通过utf8编码后转为SHA-384 rfc哈希函数输出
  static Uint8List sha384Str(String data) {
    return sha384(data.bytes);
  }

  /// 将数据转为SHA-384 rfc哈希函数输出hex
  static String sha384Hex(Uint8List data, {bool toUpperCase = false}) {
    return HexUtil.encodeHex(sha384(data), toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA-384 rfc哈希函数输出hex
  static String sha384HexStr(String data, {bool toUpperCase = false}) {
    return sha384Hex(data.bytes, toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA-512 rfc哈希函数输出
  static Uint8List sha512(Uint8List data) {
    return SHA512Digest().process(data);
  }

  /// 将字符串通过utf8编码后转为SHA-512 rfc哈希函数输出
  static Uint8List sha512Str(String data) {
    return sha512(data.bytes);
  }

  /// 将数据转为SHA-512 rfc哈希函数输出hex
  static String sha512Hex(Uint8List data, {bool toUpperCase = false}) {
    return HexUtil.encodeHex(sha512(data), toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA-512 rfc哈希函数输出hex
  static String sha512HexStr(String data, {bool toUpperCase = false}) {
    return sha512Hex(data.bytes, toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA3-224 FIPS哈希函数输出
  static Uint8List sha3_224(Uint8List data) {
    return SHA3Digest(224).process(data);
  }

  /// 将字符串通过utf8编码后转为SHA3-224 FIPS哈希函数输出
  static Uint8List sha3_224Str(String data) {
    return sha3_224(data.bytes);
  }

  /// 将数据转为SHA3-224 FIPS哈希函数输出hex
  static String sha3_224Hex(Uint8List data, {bool toUpperCase = false}) {
    return HexUtil.encodeHex(sha3_224(data), toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA3-224 FIPS哈希函数输出hex
  static String sha3_224HexStr(String data, {bool toUpperCase = false}) {
    return sha3_224Hex(data.bytes, toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA3-256 FIPS哈希函数输出
  static Uint8List sha3_256(Uint8List data) {
    return SHA3Digest(256).process(data);
  }

  /// 将字符串通过utf8编码后转为SHA3-256 FIPS哈希函数输出
  static Uint8List sha3_256Str(String data) {
    return sha3_256(data.bytes);
  }

  /// 将数据转为SHA3-256 FIPS哈希函数输出hex
  static String sha3_256Hex(Uint8List data, {bool toUpperCase = false}) {
    return HexUtil.encodeHex(sha3_256(data), toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA3-256 FIPS哈希函数输出hex
  static String sha3_256HexStr(String data, {bool toUpperCase = false}) {
    return sha3_256Hex(data.bytes, toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA3-384 FIPS哈希函数输出
  static Uint8List sha3_384(Uint8List data) {
    return SHA3Digest(384).process(data);
  }

  /// 将字符串通过utf8编码后转为SHA3-384 FIPS哈希函数输出
  static Uint8List sha3_384Str(String data) {
    return sha3_384(data.bytes);
  }

  /// 将数据转为SHA3-384 FIPS哈希函数输出hex
  static String sha3_384Hex(Uint8List data, {bool toUpperCase = false}) {
    return HexUtil.encodeHex(sha3_384(data), toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA3-384 FIPS哈希函数输出hex
  static String sha3_384HexStr(String data, {bool toUpperCase = false}) {
    return sha3_384Hex(data.bytes, toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA3-512 FIPS哈希函数输出
  static Uint8List sha3_512(Uint8List data) {
    return SHA3Digest(512).process(data);
  }

  /// 将字符串通过utf8编码后转为SHA3-512 FIPS哈希函数输出
  static Uint8List sha3_512Str(String data) {
    return sha3_512(data.bytes);
  }

  /// 将数据转为SHA3-512 FIPS哈希函数输出hex
  static String sha3_512Hex(Uint8List data, {bool toUpperCase = false}) {
    return HexUtil.encodeHex(sha3_512(data), toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA3-512 FIPS哈希函数输出hex
  static String sha3_512HexStr(String data, {bool toUpperCase = false}) {
    return sha3_512Hex(data.bytes, toUpperCase: toUpperCase);
  }

  /// 国密摘要签名算法
  static Uint8List sm3(Uint8List data) {
    return SM3Digest().process(data);
  }

  /// 将字符串通过utf8编码后转为国密摘要签名算法输出
  static Uint8List sm3Str(String data) {
    return sm3(data.bytes);
  }

  /// 将数据转为国密摘要签名算法哈希函数输出hex
  static String sm3Hex(Uint8List data, {bool toUpperCase = false}) {
    return HexUtil.encodeHex(sm3(data), toUpperCase: toUpperCase);
  }

  /// 将数据转为国密摘要签名算法哈希函数输出hex
  static String sm3HexStr(String data, {bool toUpperCase = false}) {
    return sm3Hex(data.bytes, toUpperCase: toUpperCase);
  }

  /// HMAC implementation based on RFC2104
  ///
  /// H(K XOR opad, H(K XOR ipad, text))
  static Uint8List hmac(Digest digest, Uint8List data, {Uint8List? key, String? keyStr}) {
    var hMac = HMac.withDigest(digest);
    if (key != null) {
      hMac.init(KeyParameter(key));
    } else if (keyStr != null) {
      hMac.init(KeyParameter(utf8.encoder.convert(keyStr)));
    }
    return hMac.process(data);
  }

  /// HMAC implementation based on RFC2104
  ///
  /// H(K XOR opad, H(K XOR ipad, text))
  static String hmacHex(Digest digest, Uint8List data, {Uint8List? key, String? keyStr, bool toUpperCase = false}) {
    return HexUtil.encodeHex(hmac(digest, data, key: key, keyStr: keyStr), toUpperCase: toUpperCase);
  }

  ///生成Bcrypt加密后的密文
  static String bcrypt(String password) {
    return bcryptPassword.convert(password);
  }

  ///验证[rawPassword]是否与Bcrypt加密后的[encodedPassword]匹配
  static bool bcryptCheckpw(String rawPassword, String encodedPassword) {
    return bcryptPassword.matches(rawPassword, encodedPassword);
  }
}
