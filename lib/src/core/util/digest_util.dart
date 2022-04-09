import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:yx_tool/src/core/extensions/string_extension.dart';
import 'package:yx_tool/src/core/security/crypto/bcrypt_password_encoder.dart';
import 'package:yx_tool/src/core/security/digest_sink.dart';
import 'package:yx_tool/src/core/util/hex_util.dart';

/// 可以加盐的md5
Uint8List _md5(Uint8List data, {Uint8List? salt, int position = 0, int repeat = 1}) {
  var md5 = crypto.md5;
  var innerSink = DigestSink();
  var outerSink = md5.startChunkedConversion(innerSink);
  // 加盐
  if (salt != null) {
    if (position <= 0) {
      outerSink.add(salt);
      outerSink.add(data);
    } else if (position >= data.length) {
      // 加盐在末尾，自动忽略空盐值
      outerSink.add(data);
      outerSink.add(salt);
    } else {
      // 加盐在中间
      outerSink.addSlice(data, 0, position, false);
      outerSink.add(salt);
      outerSink.addSlice(data, position, data.length, false);
    }
  } else {
    outerSink.add(data);
  }
  outerSink.close();
  var bytes2 = innerSink.value.bytes as Uint8List;
  if (repeat > 1) {
    for (var i = 0; i < repeat - 1; i++) {
      bytes2 = _md5(bytes2);
    }
  }
  return bytes2;
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
    return crypto.sha1.convert(data).bytes as Uint8List;
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
    return crypto.sha224.convert(data).bytes as Uint8List;
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
    return crypto.sha256.convert(data).bytes as Uint8List;
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
    return crypto.sha384.convert(data).bytes as Uint8List;
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
    return crypto.sha512.convert(data).bytes as Uint8List;
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

  /// 将数据转为SHA-512/224 FIPS哈希函数输出
  static Uint8List sha512224(Uint8List data) {
    return crypto.sha512224.convert(data).bytes as Uint8List;
  }

  /// 将字符串通过utf8编码后转为SHA-512/224 FIPS哈希函数输出
  static Uint8List sha512224Str(String data) {
    return sha512224(data.bytes);
  }

  /// 将数据转为SHA-512/224 FIPS哈希函数输出hex
  static String sha512224Hex(Uint8List data, {bool toUpperCase = false}) {
    return HexUtil.encodeHex(sha512224(data), toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA-512/224 FIPS哈希函数输出hex
  static String sha512224HexStr(String data, {bool toUpperCase = false}) {
    return sha512224Hex(data.bytes, toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA-512/256 FIPS哈希函数输出
  static Uint8List sha512256(Uint8List data) {
    return crypto.sha512256.convert(data).bytes as Uint8List;
  }

  /// 将字符串通过utf8编码后转为SHA-512/256 FIPS哈希函数输出
  static Uint8List sha512256Str(String data) {
    return sha512256(data.bytes);
  }

  /// 将数据转为SHA-512/256 FIPS哈希函数输出hex
  static String sha512256Hex(Uint8List data, {bool toUpperCase = false}) {
    return HexUtil.encodeHex(sha512256(data), toUpperCase: toUpperCase);
  }

  /// 将数据转为SHA-512/256 FIPS哈希函数输出hex
  static String sha512256HexStr(String data, {bool toUpperCase = false}) {
    return sha512256Hex(data.bytes, toUpperCase: toUpperCase);
  }

  /// An implementation of [keyed-hash method authentication codes][rfc].
  ///
  /// [rfc]: https://tools.ietf.org/html/rfc2104
  ///
  /// HMAC allows messages to be cryptographically authenticated using any
  /// iterated cryptographic hash function.
  static crypto.Hmac hmac(crypto.Hash hash, List<int> key) {
    return crypto.Hmac(hash, key);
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
