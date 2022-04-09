import 'dart:convert';
import 'dart:typed_data';

import 'package:yx_tool/src/core/text/string_builder.dart';

/// 十六进制（简写为hex或下标16）在数学中是一种逢16进1的进位制，一般用数字0到9和字母A到F表示（其中:A~F即10~15）。<br>
/// 例如十进制数57，在二进制写作111001，在16进制写作39。<br>
/// 像java,c这样的语言为了区分十六进制和十进制数值,会在十六进制数的前面加上 0x,比如0x20是十进制的32,而不是十进制的20<br>
/// <p>
class HexUtil {
  HexUtil._();

  static bool isHexNumber(String value) {
    return false;
  }

  /// 集合数据会看作utf16对待，先转为String对象，
  /// 然后由utf8编码为byte,最后将数组转为16进制字符
  static String encodeHexInt(List<int> list, {bool toUpperCase = false, String delimiter = ''}) {
    return encodeHexStr(String.fromCharCodes(list), toUpperCase: toUpperCase, delimiter: delimiter);
  }

  /// 将数组转为16进制字符
  static String encodeHex(Uint8List bytes, {bool toUpperCase = false, String delimiter = ''}) {
    var result = StringBuilder(bytes.length << 1);
    for (var i = 0; i < bytes.length; i++) {
      var part = bytes[i];
      var s1 = part < 16 ? '0' : '';
      var s2 = part.toRadixString(16);
      result.append('$s1$s2');
      if (delimiter.isNotEmpty && i != bytes.length - 1) {
        result.append(delimiter);
      }
    }
    var string = result.toString();
    if (toUpperCase) {
      return string.toUpperCase();
    }
    return string;
  }

  /// 将字符串转为16进制字符
  static String encodeHexStr(String str, {bool toUpperCase = false, String delimiter = ''}) {
    return encodeHex(utf8.encoder.convert(str), toUpperCase: toUpperCase, delimiter: delimiter);
  }

  /// 解码为字符串
  static String decodeHexStr(String hexStr, {String delimiter = ''}) {
    return utf8.decode(decodeHex(hexStr, delimiter: delimiter));
  }

  /// 16进制解码为数组
  static Uint8List decodeHexInt(List<int> list, {String delimiter = ''}) {
    return decodeHex(String.fromCharCodes(list), delimiter: delimiter);
  }

  /// 16进制解码为数组
  static Uint8List decodeHex(String hexStr, {String delimiter = ''}) {
    if (hexStr.startsWith('0x')) {
      hexStr = hexStr.substring(2);
    } else if (hexStr.startsWith('#')) {
      hexStr = hexStr.substring(1);
    }
    if (delimiter.isNotEmpty) {
      hexStr = hexStr.split(delimiter).join();
    }
    var len = hexStr.length;
    if ((len & 0x01) != 0) {
      throw FormatException('Odd number of characters.');
    }
    var out = Uint8List(len >> 1);
    for (var i = 0; i < hexStr.length; i += 2) {
      var num = hexStr.substring(i, i + 2);
      var byte = int.parse(num, radix: 16);
      out[i ~/ 2] = byte;
    }
    return out;
  }

  /// 将Color编码为Hex形式
  static String encodeColor({required int red, required int green, required int blue, String prefix = '#'}) {
    var builder = StringBuilder.from(prefix);
    String colorHex;
    colorHex = red.toRadixString(16);
    if (1 == colorHex.length) {
      builder.append('0');
    }
    builder.append(colorHex);
    colorHex = green.toRadixString(16);
    if (1 == colorHex.length) {
      builder.append('0');
    }
    builder.append(colorHex);
    colorHex = blue.toRadixString(16);
    if (1 == colorHex.length) {
      builder.append('0');
    }
    builder.append(colorHex);
    return builder.toString();
  }

  /// 颜色解码
  static HexColor decodeColor(String hexColor) {
    if (hexColor.startsWith('#')) {
      hexColor = hexColor.substring(1);
    }
    var i = int.parse(hexColor, radix: 16);
    return HexColor(red: (i >> 16) & 0xFF, green: (i >> 8) & 0xFF, blue: i & 0xFF);
  }
}

/// 三原色
class HexColor {
  int red;
  int green;
  int blue;

  HexColor({
    required this.red,
    required this.green,
    required this.blue,
  });

  @override
  String toString() {
    return 'HexColor{red: $red, green: $green, blue: $blue}';
  }
}
