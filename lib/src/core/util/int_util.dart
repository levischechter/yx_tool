import 'dart:collection';
import 'dart:math' as math;

/// int整型工具类
class IntUtil {
  IntUtil._();

  /// 罗马数字对照Map
  static final LinkedHashMap<String, int> _symbolValues = LinkedHashMap.of({
    'M': 1000,
    'CM': 900,
    'D': 500,
    'CD': 400,
    'C': 100,
    'XC': 90,
    'L': 50,
    'XL': 40,
    'X': 10,
    'IX': 9,
    'V': 5,
    'IV': 4,
    'I': 1
  });

  /// 是否是num
  static bool isNumber(String str) {
    return num.tryParse(str) != null;
  }

  // 整数反转
  static int reverse(int x) {
    var rev = 0;
    while (x != 0) {
      final digit = x % 10;
      x = x ~/ 10;
      rev = rev * 10 + digit;
      if (rev < math.pow(-2, 31) || rev > math.pow(2, 31) - 1) {
        return 0;
      }
    }
    return rev;
  }

  /// 整数转罗马数字
  static String intToRoman(int num) {
    var roman = StringBuffer();
    for (var entrie in _symbolValues.entries) {
      var value = entrie.value;
      var symbol = entrie.key;
      while (num >= value) {
        num -= value;
        roman.write(symbol);
      }
      if (num == 0) {
        break;
      }
    }
    return roman.toString();
  }

  /// 罗马数字转整数
  static int romanToInt(String roman) {
    var ans = 0;
    final n = roman.length;
    for (var i = 0; i < n; ++i) {
      var value = _symbolValues[roman[i]]!;
      if (i < n - 1 && value < _symbolValues[roman[i + 1]]!) {
        ans -= value;
      } else {
        ans += value;
      }
    }
    return ans;
  }

  /// 斐波那契数
  int fib(int n) {
    if (n < 2) {
      return n;
    }
    var p = 0, q = 0, r = 1;
    for (var i = 2; i <= n; ++i) {
      p = q;
      q = r;
      r = p + q;
    }
    return r;
  }

  ///以数字方式比较两个int值。返回的值与通过以下方式返回的值相同：
  ///           a.compareTo(b)
  ///
  /// 参形：
  /// x – 要比较的第一个long
  /// y – 要比较的第二个long
  /// 返回值：
  /// 如果x == y则值为0 ；如果x < y则小于0的值；如果x > y ，则值大于0
  static int compare(int a, int b) {
    return a.compareTo(b);
  }

  /// 转为8位无符号整数
  static int toUInt8(int num) {
    return num & maxUInt8;
  }

  /// 转为16位无符号整数
  static int toUInt16(int num) {
    return num & maxUInt16;
  }

  /// 转为32位无符号整数
  static int toUInt32(int num) {
    return num & maxUInt32;
  }

  /// 转为64位无符号整数
  static int toUInt64(int num) {
    return num & maxUInt64;
  }

  /// 转为8位有符号整数
  static int toInt8(int num) {
    return num.toSigned(8);
  }

  /// 转为16位有符号整数
  static int toInt16(int num) {
    return num.toSigned(16);
  }

  /// 转为32位有符号整数
  static int toInt32(int num) {
    return num.toSigned(32);
  }

  /// 转为64位有符号整数
  static int toInt64(int num) {
    return num.toSigned(64);
  }

  ///无符号8位整数最大值
  static const maxUInt8 = 0xFF;

  ///无符号16位整数最大值
  static const maxUInt16 = 0xFFFF;

  ///无符号32位整数最大值
  static const maxUInt32 = 0xFFFFFFFF;

  ///无符号64位整数最大值
  static const maxUInt64 = 0xFFFFFFFFFFFFFFFF;

  /// 有符号8位整数最大值
  static const maxInt8 = 0x7F;

  /// 有符号16位整数最大值
  static const maxInt16 = 0x7FFF;

  /// 有符号32位整数最大值
  static const maxInt32 = 0x7FFFFFFF;

  /// 有符号64位整数最大值
  static const maxInt64 = 0x7FFFFFFFFFFFFFFF;

  /// 有符号8位整数最小值
  static const minInt8 = -0x80;

  /// 有符号16位整数最小值
  static const minInt16 = -0x8000;

  /// 有符号32位整数最小值
  static const minInt32 = -0x80000000;

  /// 有符号64位整数最小值
  static const minInt64 = -0x8000000000000000;
}
