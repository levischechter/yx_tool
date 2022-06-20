import 'dart:convert';
import 'dart:typed_data';

import 'package:yx_tool/yx_util.dart';

/// 字符串工具类
class StrUtil {
  StrUtil._();

  /// 字符串是否为空白，\n, ,\r,都将视为空
  static bool isBlank(String? str) {
    if (str == null) {
      return true;
    }
    if (str.isEmpty) {
      return true;
    }

    return str.trimLeft().isEmpty;
  }

  /// 字符串是否为非空白.不为null,不为空字符串,不为空格、全角空格、制表符、换行符，等不可见字符
  static bool isNotBlank(String? str) {
    return !isBlank(str);
  }

  ///指定字符串数组中，是否包含空字符串。
  static bool hasBlank(List<String>? str) {
    if (ListUtil.isEmpty(str)) {
      return true;
    }

    for (var value in str!) {
      if (isBlank(value)) {
        return true;
      }
    }
    return false;
  }

  ///指定字符串数组中的元素，是否全部为空字符串。
  ///<p>如果指定的字符串数组的长度为 0，或者所有元素都是空字符串，则返回 true。
  static bool isAllBlank(List<String>? strs) {
    if (ListUtil.isEmpty(strs)) {
      return true;
    }
    for (var str in strs!) {
      if (isNotBlank(str)) {
        return false;
      }
    }
    return false;
  }

  ///字符串是否为空
  static bool isEmpty(String? str) {
    return str == null || str.isEmpty;
  }

  ///字符串是否不为空
  static bool isNotEmpty(String? str) {
    return !isEmpty(str);
  }

  /// 如果字符串是null或者&quot;&quot;，则返回指定默认字符串，否则返回字符串本身。
  ///
  /// ```dart
  /// emptyToDefault(null, &quot;default&quot;)  = &quot;default&quot;
  /// emptyToDefault(&quot;&quot;, &quot;default&quot;)    = &quot;default&quot;
  /// emptyToDefault(&quot;  &quot;, &quot;default&quot;)  = &quot;  &quot;
  /// emptyToDefault(&quot;bat&quot;, &quot;default&quot;) = &quot;bat&quot;
  /// ```
  static String emptyToDefault(String? str, String defaultStr) {
    return isEmpty(str) ? defaultStr : str.toString();
  }

  /// 如果字符串是{@code null}或者&quot;&quot;或者空白，则返回指定默认字符串，否则返回字符串本身。
  ///
  /// ```dart
  /// blankToDefault(null, &quot;default&quot;)  = &quot;default&quot;
  /// blankToDefault(&quot;&quot;, &quot;default&quot;)    = &quot;default&quot;
  /// blankToDefault(&quot;  &quot;, &quot;default&quot;)  = &quot;default&quot;
  /// blankToDefault(&quot;bat&quot;, &quot;default&quot;) = &quot;bat&quot;
  /// ```
  static String blankToDefault(String? str, String defaultStr) {
    return isBlank(str) ? defaultStr : str.toString();
  }

  /// 当给定字符串为空字符串时，转换为null
  static String? emptyToNull(String? str) {
    return isEmpty(str) ? null : str.toString();
  }

  /// <p>是否包含空字符串。</p>
  /// <p>如果指定的字符串数组的长度为 0，或者其中的任意一个元素是空字符串，则返回 true。</p>
  /// <br>
  ///
  /// <p>例：</p>
  /// ```dart
  /// StrUtil.hasEmpty()                  // true
  /// StrUtil.hasEmpty("", null)          // true
  /// StrUtil.hasEmpty("123", "")         // true
  /// StrUtil.hasEmpty("123", "abc")      // false
  /// StrUtil.hasEmpty(" ", "\t", "\n")   // false
  /// ```

  ///
  /// <p>注意：该方法与 [isAllEmpty] 的区别在于：</p>
  /// ```dart
  /// [hasEmpty] 等价于 [isEmpty] || [isEmpty] || ...}
  /// [isAllEmpty]等价于 [isEmpty] && [isEmpty] && ...}
  /// ```
  static bool hasEmpty(List<String>? strs) {
    if (ListUtil.isEmpty(strs)) {
      return true;
    }

    for (var str in strs!) {
      if (isEmpty(str)) {
        return true;
      }
    }
    return false;
  }

  /// <p>指定字符串数组中的元素，是否全部为空字符串。</p>
  /// <p>如果指定的字符串数组的长度为 0，或者所有元素都是空字符串，则返回 true。</p>
  /// <br>
  ///
  /// <p>例：</p>
  /// ```dart
  /// StrUtil.isAllEmpty()                   // true}
  /// StrUtil.isAllEmpty("", null)          // true}
  /// StrUtil.isAllEmpty("123", "")         // false}
  /// StrUtil.isAllEmpty("123", "abc")      // false}
  /// StrUtil.isAllEmpty(" ", "\t", "\n")   // false}
  /// ```
  ///
  /// <p>注意：该方法与 {@link #hasEmpty(CharSequence...)} 的区别在于：</p>
  /// ```dart
  /// [hasEmpty]   等价于 {[isEmpty] || [isEmpty] || ...}
  /// [isAllEmpty] 等价于 {[isEmpty] && [isEmpty] && ...}
  /// ```
  static bool isAllEmpty(List<String>? strs) {
    if (ListUtil.isEmpty(strs)) {
      return true;
    }

    for (var str in strs!) {
      if (isNotEmpty(str)) {
        return false;
      }
    }
    return true;
  }

  /// <p>指定字符串数组中的元素，是否都不为空字符串。</p>
  /// <p>如果指定的字符串数组的长度不为 0，或者所有元素都不是空字符串，则返回 true。</p>
  /// <br>
  ///
  /// <p>例：</p>
  /// ```dart
  ///  {@code StrUtil.isAllNotEmpty()                  // false}
  ///  {@code StrUtil.isAllNotEmpty("", null)          // false}
  ///  {@code StrUtil.isAllNotEmpty("123", "")         // false}
  ///  {@code StrUtil.isAllNotEmpty("123", "abc")      // true}
  ///  {@code StrUtil.isAllNotEmpty(" ", "\t", "\n")   // true}
  /// ```
  ///
  /// <p>注意：该方法与 [isAllEmpty] 的区别在于：</p>
  /// ```dart
  ///  [isAllEmpty]    等价于 [isEmpty] && [isEmpty] && ...}
  ///  [isAllNotEmpty] 等价于 [isNotEmpty] && [isNotEmpty] && ...}
  /// ```
  static bool isAllNotEmpty(List<String>? args) {
    return !hasEmpty(args);
  }

  /// 是否存都不为null或空对象或空白符的对象，通过[hasBlank]判断元素
  static bool isAllNotBlank(List<String>? args) {
    return !hasBlank(args);
  }

  /// 检查字符串是否为null、空白串、“null”、“undefined”
  static bool isBlankOrUndefined(String? str) {
    if (isBlank(str)) {
      return true;
    }
    return isNullOrUndefinedStr(str!);
  }

  /// 是否为“null”、“undefined”，不做空指针检查
  static bool isNullOrUndefinedStr(String str) {
    var strString = str.trim();
    return 'null' == strString || 'undefined' == strString;
  }

  /// 给定字符串是否以任何一个字符串开始<br>
  /// 给定字符串和数组为空都返回false
  static bool startWithAny(String str, List<String> prefixes) {
    if (isEmpty(str) || ListUtil.isEmpty(prefixes)) {
      return false;
    }

    for (var prefix in prefixes) {
      if (str.startsWith(prefix)) {
        return true;
      }
    }
    return false;
  }

  /// 给定字符串是否以任何一个字符串结尾<br>
  /// 给定字符串和数组为空都返回false
  static bool endWithAny(String str, List<String> suffixes) {
    if (isEmpty(str) || ListUtil.isEmpty(suffixes)) {
      return false;
    }

    for (var suffix in suffixes) {
      if (str.endsWith(suffix)) {
        return true;
      }
    }
    return false;
  }

  /// 查找指定字符串是否包含指定字符串列表中的任意一个字符串
  static bool containsAny(String str, List<String> testStrs) {
    for (var test in testStrs) {
      if (str.contains(test)) {
        return true;
      }
    }
    return false;
  }

  /// 忽略大小写匹配
  static bool equalsIgnoreCase(String str, String str2) {
    return str.toLowerCase() == str2.toLowerCase();
  }

  /// 以相反的顺序返回字符串
  static String reversed(String str) {
    return String.fromCharCodes(str.codeUnits.reversed);
  }

  /// 返回此字符串的第一个字母为大写的副本，或原始字符串（如果它为空或已以大写字母开头）。
  ///
  /// ```dart
  /// print('abcd'.capitalize()) // Abcd
  /// print('Abcd'.capitalize()) // Abcd
  /// ```
  static String upperFirst(String str) {
    switch (str.length) {
      case 0:
        return str;
      case 1:
        return str.toUpperCase();
      default:
        return str.substring(0, 1).toUpperCase() + str.substring(1);
    }
  }

  /// 返回此字符串的第一个字母为小写的副本，或原始字符串（如果它为空或已以小写字母开头）。
  ///
  /// ```dart
  /// print('abcd'.capitalize()) // abcd
  /// print('Abcd'.capitalize()) // abcd
  /// ```
  static String lowerFirst(String str) {
    switch (str.length) {
      case 0:
        return str;
      case 1:
        return str.toLowerCase();
      default:
        return str.substring(0, 1).toLowerCase() + str.substring(1);
    }
  }

  /// 补充字符串以满足最小长度，如果提供的字符串大于指定长度，截断之
  /// 同：leftPad (org.apache.commons.lang3.leftPad)
  ///
  /// ```dart
  /// StrUtil.padLeft("1", 3, '0');//"001"
  /// StrUtil.padLeft("123", 2, '0');//"12"
  /// ```
  /// param [str]     字符串
  /// param [length]  长度
  /// param [padChar] 补充的字符
  static String padLeft(String str, int length, String padChar) {
    final strLen = str.length;
    if (strLen == length) {
      return str.toString();
    } else if (strLen > length) {
      //如果提供的字符串大于指定长度，截断之
      return str.substring(0, length);
    }

    return repeat(padChar, length - strLen) + str.toString();
  }

  /// 重复某个字符
  ///
  /// ```dart
  /// StrUtil.repeat('e', 0)  = ""
  /// StrUtil.repeat('e', 3, ',')  = "e,e,e"
  /// StrUtil.repeat('e', -2) = ""
  /// ```
  static String repeat(String str, int count, [String delimiter = '']) {
    if (count <= 0) {
      return '';
    }
    var sb = StringBuffer();
    sb.writeAll(List.generate(count, (index) => str), delimiter);
    return sb.toString();
  }

  /// 转为无符号8位数组
  static Uint8List uint8List(String str) {
    return Uint8List.fromList(str.codeUnits);
  }

  /// 比较版本号<br>
  /// 版本号由一个或多个修订号组成，各修订号由一个 '.' 连接。每个修订号由 多位数字 组成，可能包含 前导零 。每个版本号至少包含一个字符。修订号从左到右编号，下标从 0 开始，最左边的修订号下标为 0 ，下一个修订号下标为 1 ，以此类推。例如，2.5.33 和 0.1 都是有效的版本号。
  ///
  /// return:<br>
  /// 如果 version1 > version2 返回 1，<br>
  /// 如果 version1 < version2 返回 -1，<br>
  /// 除此之外返回 0。
  int compareVersion(String version1, String version2) {
    var v1 = version1.split('\\.');
    var v2 = version2.split('\\.');
    for (var i = 0; i < v1.length || i < v2.length; ++i) {
      var x = 0, y = 0;
      if (i < v1.length) {
        x = int.parse(v1[i]);
      }
      if (i < v2.length) {
        y = int.parse(v2[i]);
      }
      if (x > y) {
        return 1;
      }
      if (x < y) {
        return -1;
      }
    }
    return 0;
  }

  /// 给定字符串中的字母是否全部为大写
  static bool isUpperCase(String str) {
    if (str.isEmpty) {
      return false;
    }

    for (var i = 0; i < str.length; i++) {
      if (str[i].toUpperCase() != str[i]) {
        return false;
      }
    }
    return true;
  }

  /// 给定字符串中的字母是否全部为小写
  static bool isLowerCase(String str) {
    return !isUpperCase(str);
  }

  /// 切换给定字符串中的大小写。
  /// 首字符小写转大写，首字符大写转小写
  static String swapCase(String str) {
    if (str.isEmpty) {
      return str;
    }

    // 如果小写相等，则为大写
    if (str[0].toLowerCase() == str[0]) {
      return str.toUpperCase();
    } else {
      return str.toLowerCase();
    }
  }

  /// 字符串转为小写
  static String? toLowerCase(String? str) {
    if (isEmpty(str)) {
      return str;
    }
    return str!.toLowerCase();
  }

  /// 字符串转为大写
  static String? toUpperCase(String? str) {
    if (isEmpty(str)) {
      return str;
    }
    return str!.toUpperCase();
  }

  /// 按照char方式比较是否是number
  static bool charIsNumber(String? str) {
    if (isEmpty(str)) {
      return false;
    }
    var code0 = '0'.codeUnitAt(0);
    var code9 = '9'.codeUnitAt(0);
    var codeUnit = str!.codeUnitAt(0);
    return codeUnit >= code0 && codeUnit <= code9;
  }

  ///将驼峰式命名的字符串转换为下划线方式。如果转换前的驼峰式命名的字符串为空，则返回空字符串。
  static String toUnderlineCase(String str, [String symbol = '_']) {
    if (str.isEmpty) {
      return str;
    }
    var length = str.length;
    if (length == 1) {
      return str.toLowerCase();
    }

    var sb = StringBuffer();
    String? c;
    for (var i = 0; i < length; i++) {
      c = str[i];
      if (isUpperCase(c)) {
        var preChar = (i > 0) ? str[i - 1] : null;
        var nextChar = (i < length - 1) ? str[i + 1] : null;

        if (null != preChar) {
          if (symbol == preChar) {
            // 前一个为分隔符
            if (null == nextChar || isLowerCase(nextChar)) {
              //普通首字母大写，如_Abb -> _abb
              c = toLowerCase(c);
            }
            //后一个为大写，按照专有名词对待，如_AB -> _AB
          } else if (isLowerCase(preChar)) {
            // 前一个为小写
            sb.write(symbol);
            if (null == nextChar || isLowerCase(nextChar) || charIsNumber(nextChar)) {
              //普通首字母大写，如aBcc -> a_bcc
              c = toLowerCase(c);
            }
            // 后一个为大写，按照专有名词对待，如aBC -> a_BC
          } else {
            //前一个为大写
            if (null != nextChar && isLowerCase(nextChar)) {
              // 普通首字母大写，如ABcc -> A_bcc
              sb.write(symbol);
              c = toLowerCase(c);
            }
            // 后一个为大写，按照专有名词对待，如ABC -> ABC
          }
        } else {
          // 首字母，需要根据后一个判断是否转为小写
          if (null == nextChar || isLowerCase(nextChar)) {
            // 普通首字母大写，如Abc -> abc
            c = toLowerCase(c);
          }
          // 后一个为大写，按照专有名词对待，如ABC -> ABC
        }
      }
      sb.write(c);
    }
    return sb.toString();
  }

  /// 将连接符方式命名的字符串转换为驼峰式。如果转换前的下划线大写方式命名的字符串为空，则返回空字符串。
  static String toCamelCase(String name, [String symbol = '_']) {
    if (isBlank(name)) {
      return name;
    }
    final name2 = name.toString();
    if (name2.contains(symbol)) {
      final length = name2.length;
      final sb = StringBuffer();
      var upperCase = false;
      for (var i = 0; i < length; i++) {
        var c = name2[i];
        if (c == symbol) {
          upperCase = true;
        } else if (upperCase) {
          sb.write(toUpperCase(c));
          upperCase = false;
        } else {
          sb.write(toLowerCase(c));
        }
      }
      return sb.toString();
    } else {
      return name2;
    }
  }

  /// 将下划线方式命名的字符串转换为帕斯卡式
  static String toPascalCase(String name) {
    return upperFirst(toCamelCase(name));
  }

  /// 字符串匹配的所有下标
  static List<int> indicesOf(String str, Pattern pattern, [int start = 0]) {
    var indices = <int>[];
    var index = -1;
    do {
      index = str.indexOf(pattern, start);
      if (index != -1) {
        indices.add(index);
        start = index + 1;
      }
    } while (index != -1);
    return indices;
  }

  /// 遍历给定的字符串并按顺序拼接它们
  static String join(List<String> strs, [String separator = '']) {
    var sb = StringBuffer();
    sb.writeAll(strs);
    return sb.toString();
  }

  /// 使用默认的utf8转换List<int>数据为字符串
  static String decode(List<int> codeUnits, [Encoding encoding = utf8]) {
    return encoding.decode(codeUnits);
  }

  /// 使用默认的utf8转换字符串数据为List<int>
  static List<int> encode(String str, [Encoding encoding = utf8]) {
    return encoding.encoder.convert(str);
  }

  /// 使用utf8转换字符串数据为Uint8List
  static Uint8List encodeUtf8(String str) {
    return utf8.encoder.convert(str);
  }

  /// 使用ascii转换字符串数据为Uint8List
  static Uint8List encodeAscii(String str) {
    return ascii.encoder.convert(str);
  }

  /// 使用ISO-8859-1转换字符串数据为Uint8List
  static Uint8List encodeISO_8859_1(String str) {
    return latin1.encoder.convert(str);
  }

  /// 是否存在utf16编码字符
  static bool isUtf16(String str) {
    for (var code in str.codeUnits) {
      if (code > 255) {
        return true;
      }
    }
    return false;
  }
}
