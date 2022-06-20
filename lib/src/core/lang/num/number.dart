import 'package:yx_tool/src/core/lang/math/decimal.dart';
import 'package:yx_tool/src/core/lang/num/integer.dart';
import 'package:yx_tool/src/core/lang/num/long.dart';
import 'package:yx_tool/src/core/lang/num/short.dart';

import 'byte.dart';

abstract class Number<T> extends Comparable<T> {
  num get value;

  /// 以byte形式返回指定数字的值
  Byte byteValue() => Byte(value.toInt());

  /// 以short形式返回指定数字的值
  Short shortValue() => Short(value.toInt());

  /// 以int形式返回指定数字的值
  Integer intValue() => Integer(value.toInt());

  /// 以long形式返回指定数字的值
  Long longValue() => Long(value.toInt());

  /// 以无符号byte形式返回指定数字的值
  int uByteValue() => value.toInt().toUnsigned(8);

  /// 以无符号short形式返回指定数字的值
  int uShortValue() => value.toInt().toUnsigned(16);

  /// 以无符号int形式返回指定数字的值
  int uIntValue() => value.toInt().toUnsigned(32);

  /// 以无符号long形式返回指定数字的值
  int uLongValue() => value.toInt().toUnsigned(64);

  /// 以double形式返回指定数字的值
  double doubleValue() => value.toDouble();

  @override
  int compareTo(T other);
}

abstract class AbstractInt<T extends Number> extends Number<T> {
  /// 返回bit位数
  int get bits;

  /// 实际值
  @override
  int get value;

  /// 创建实例
  T valueOf(int num);

  /// 负数
  T operator -() {
    return valueOf(-value);
  }

  /// 加法，结果超出[bits]时，将溢出范围，具体参考[toSigned]
  T operator +(dynamic other) {
    if (other is AbstractInt) {
      return valueOf(value + other.value);
    } else if (other is num) {
      return valueOf((value + other).toInt());
    } else if (other is BigInt) {
      return valueOf((BigInt.from(value) + other).toInt());
    } else if (other is Decimal) {
      return valueOf((Decimal.fromInt(value) + other).toBigInt().toInt());
    } else {
      throw UnsupportedError('not support argument: ${other.runtimeType}');
    }
  }

  /// 减法
  T operator -(dynamic other) {
    if (other is AbstractInt) {
      return valueOf(value - other.value);
    } else if (other is num) {
      return valueOf((value - other).toInt());
    } else if (other is BigInt) {
      return valueOf((BigInt.from(value) - other).toInt());
    } else if (other is Decimal) {
      return valueOf((Decimal.fromInt(value) - other).toBigInt().toInt());
    } else {
      throw UnsupportedError('not support argument: ${other.runtimeType}');
    }
  }

  /// 乘法，结果超出[bits]时，将溢出范围，具体参考[toSigned]
  T operator *(dynamic other) {
    if (other is AbstractInt) {
      return valueOf(value * other.value);
    } else if (other is num) {
      return valueOf((value * other).toInt());
    } else if (other is BigInt) {
      return valueOf((BigInt.from(value) * other).toInt());
    } else if (other is Decimal) {
      return valueOf((Decimal.fromInt(value) * other).toBigInt().toInt());
    } else {
      throw UnsupportedError('not support argument: ${other.runtimeType}');
    }
  }

  /// 除法
  double operator /(dynamic other) {
    if (other is AbstractInt) {
      return value / other.value;
    } else if (other is num) {
      return value / other;
    } else if (other is BigInt) {
      return BigInt.from(value) / other;
    } else if (other is Decimal) {
      return (Decimal.fromInt(value) / other).toDouble();
    } else {
      throw UnsupportedError('not support argument: ${other.runtimeType}');
    }
  }

  /// 取模
  T operator %(dynamic other) {
    if (other is AbstractInt) {
      return valueOf(value % other.value);
    } else if (other is num) {
      return valueOf((value % other).toInt());
    } else if (other is BigInt) {
      return valueOf((BigInt.from(value) % other).toInt());
    } else if (other is Decimal) {
      return valueOf((Decimal.fromInt(value) % other).toBigInt().toInt());
    } else {
      throw UnsupportedError('not support argument: ${other.runtimeType}');
    }
  }

  /// 除法取整
  T operator ~/(dynamic other) {
    if (other is AbstractInt) {
      return valueOf(value ~/ other.value);
    } else if (other is num) {
      return valueOf(value ~/ other);
    } else if (other is BigInt) {
      return valueOf((BigInt.from(value) ~/ other).toInt());
    } else if (other is Decimal) {
      return valueOf((Decimal.fromInt(value) ~/ other).toBigInt().toInt());
    } else {
      throw UnsupportedError('not support argument: ${other.runtimeType}');
    }
  }

  /// 大于
  bool operator >(dynamic other) {
    if (other is AbstractInt) {
      return value > other.value;
    } else if (other is num) {
      return value > other;
    } else if (other is BigInt) {
      return BigInt.from(value) > other;
    } else if (other is Decimal) {
      return Decimal.fromInt(value) > other;
    } else {
      throw UnsupportedError('not support argument: ${other.runtimeType}');
    }
  }

  /// 大于等于
  bool operator >=(dynamic other) {
    if (other is AbstractInt) {
      return value >= other.value;
    } else if (other is num) {
      return value >= other;
    } else if (other is BigInt) {
      return BigInt.from(value) >= other;
    } else if (other is Decimal) {
      return Decimal.fromInt(value) >= other;
    } else {
      throw UnsupportedError('not support argument: ${other.runtimeType}');
    }
  }

  /// 小于
  bool operator <(dynamic other) {
    if (other is AbstractInt) {
      return value < other.value;
    } else if (other is num) {
      return value < other;
    } else if (other is BigInt) {
      return BigInt.from(value) < other;
    } else if (other is Decimal) {
      return Decimal.fromInt(value) < other;
    } else {
      throw UnsupportedError('not support argument: ${other.runtimeType}');
    }
  }

  /// 小于等于
  bool operator <=(dynamic other) {
    if (other is AbstractInt) {
      return value <= other.value;
    } else if (other is num) {
      return value <= other;
    } else if (other is BigInt) {
      return BigInt.from(value) <= other;
    } else if (other is Decimal) {
      return Decimal.fromInt(value) <= other;
    } else {
      throw UnsupportedError('not support argument: ${other.runtimeType}');
    }
  }

  /// 位和运算符。
  /// 将[this]和[other]都视为足够大的二进制分量整数，结果是一个数字，其中只有在[this]和[other]中设置的位集
  /// 如果两个操作数都为负，则结果为负，否则结果为非负
  T operator &(dynamic other) {
    if (other is AbstractInt) {
      return valueOf(value & other.value);
    } else if (other is int) {
      return valueOf(value & other);
    } else if (other is BigInt) {
      return valueOf((BigInt.from(value) & other).toInt());
    } else if (other is Decimal) {
      return valueOf((BigInt.from(value) & other.toBigInt()).toInt());
    } else {
      throw UnsupportedError('not support argument: ${other.runtimeType}');
    }
  }

  /// 按位或运算符。
  /// 将[this]和[other]都视为足够大的二进制分量整数，结果是一个数字，其位集在[this]和[other]中的任何一个中设置
  /// 如果两个操作数都是非负数，则结果为非负数，否则结果为负数
  T operator |(dynamic other) {
    if (other is AbstractInt) {
      return valueOf(value | other.value);
    } else if (other is int) {
      return valueOf((value | other).toInt());
    } else if (other is BigInt) {
      return valueOf((BigInt.from(value) | other).toInt());
    } else if (other is Decimal) {
      return valueOf((BigInt.from(value) | other.toBigInt()).toInt());
    } else {
      throw UnsupportedError('not support argument: ${other.runtimeType}');
    }
  }

  /// 按位异或运算符。
  /// 将[this]和[other]都视为足够大的二进制分量整数，结果是一个数字，其位集设置在[this]和[other]的一个中，但不是同时设置
  /// 如果操作数的符号相同，则结果为非负数，否则结果为负数
  T operator ^(dynamic other) {
    if (other is AbstractInt) {
      return valueOf(value ^ other.value);
    } else if (other is int) {
      return valueOf(value ^ other);
    } else if (other is BigInt) {
      return valueOf((BigInt.from(value) ^ other).toInt());
    } else if (other is Decimal) {
      return valueOf((BigInt.from(value) ^ other.toBigInt()).toInt());
    } else {
      throw UnsupportedError('not support argument: ${other.runtimeType}');
    }
  }

  /// 按位取反运算符。
  /// 将[this]视为足够大的二进制分量整数，结果是设置了相反位的数字。
  /// 这将任何整数x映射到-x - 1
  T operator ~() {
    return valueOf(~value);
  }

  /// 将此整数的位向左[shiftAmount] 。
  /// 向左移动会使数字变大，有效地将数字乘以pow(2, shiftIndex) 。
  /// 结果的大小没有限制。通过使用带有合适掩码的“and”运算符来限制中间值可能是相关的。
  /// 如果[shiftAmount]为负数，则为错误
  /// 结果超出[bits]时，将溢出范围，具体参考[toSigned]
  T operator <<(dynamic other) {
    if (other is AbstractInt) {
      return valueOf(value << other.value);
    } else if (other is int) {
      return valueOf(value << other);
    } else if (other is BigInt) {
      return valueOf(value << other.toInt());
    } else if (other is Decimal) {
      return valueOf(value << other.toBigInt().toInt());
    } else {
      throw UnsupportedError('not support argument: ${other.runtimeType}');
    }
  }

  /// 将此整数的位向右[shiftAmount] 。
  /// 向右移动会使数字变小并丢弃最低有效位，从而有效地进行pow(2, shiftIndex)的整数除法。
  /// 如果[shiftAmount]为负数，则为错误
  T operator >>(dynamic other) {
    if (other is AbstractInt) {
      return valueOf(value >> other.value);
    } else if (other is int) {
      return valueOf(value >> other);
    } else if (other is BigInt) {
      return valueOf(value >> other.toInt());
    } else if (other is Decimal) {
      return valueOf(value >> other.toBigInt().toInt());
    } else {
      throw UnsupportedError('not support argument: ${other.runtimeType}');
    }
  }

  /// 按位无符号右移[shiftAmount]位。
  /// 最不重要的[shiftAmount]位被删除，其余位（如果有）被向下移动，并且零位被移入作为新的最高有效位。
  /// [shiftAmount]必须为非负数
  T operator >>>(dynamic other) {
    if (other is AbstractInt) {
      return valueOf(value >>> other.value);
    } else if (other is int) {
      return valueOf(value >>> other);
    } else if (other is BigInt) {
      return valueOf(value >>> other.toInt());
    } else if (other is Decimal) {
      return valueOf(value >>> other.toBigInt().toInt());
    } else {
      throw UnsupportedError('not support argument: ${other.runtimeType}');
    }
  }

  /// Returns this integer to the power of [exponent] modulo [modulus].
  ///
  /// The [exponent] must be non-negative and [modulus] must be
  /// positive.
  T modPow(int exponent, int modulus) =>
      valueOf(value.modPow(exponent, modulus));

  /// Returns the modular multiplicative inverse of this integer
  /// modulo [modulus].
  ///
  /// The [modulus] must be positive.
  ///
  /// It is an error if no modular inverse exists.
  T modInverse(int modulus) => valueOf(value.modInverse(modulus));

  /// Returns the greatest common divisor of this integer and [other].
  ///
  /// If either number is non-zero, the result is the numerically greatest
  /// integer dividing both `this` and `other`.
  ///
  /// The greatest common divisor is independent of the order,
  /// so `x.gcd(y)` is  always the same as `y.gcd(x)`.
  ///
  /// For any integer `x`, `x.gcd(x)` is `x.abs()`.
  ///
  /// If both `this` and `other` is zero, the result is also zero.
  ///
  /// Example:
  /// ```dart
  /// print(4.gcd(2)); // 2
  /// print(8.gcd(4)); // 4
  /// print(10.gcd(12)); // 2
  /// print(10.gcd(0)); // 10
  /// print((-2).gcd(-3)); // 1
  /// ```
  T gcd(int other) => valueOf(value.gcd(other));

  /// Returns true if and only if this integer is even.
  bool get isEven => value.isEven;

  /// Returns true if and only if this integer is odd.
  bool get isOdd => value.isOdd;

  /// Returns the minimum number of bits required to store this integer.
  ///
  /// The number of bits excludes the sign bit, which gives the natural length
  /// for non-negative (unsigned) values.  Negative values are complemented to
  /// return the bit position of the first bit that differs from the sign bit.
  ///
  /// To find the number of bits needed to store the value as a signed value,
  /// add one, i.e. use `x.bitLength + 1`.
  /// ```dart
  /// x.bitLength == (-x-1).bitLength;
  ///
  /// 3.bitLength == 2;     // 00000011
  /// 2.bitLength == 2;     // 00000010
  /// 1.bitLength == 1;     // 00000001
  /// 0.bitLength == 0;     // 00000000
  /// (-1).bitLength == 0;  // 11111111
  /// (-2).bitLength == 1;  // 11111110
  /// (-3).bitLength == 2;  // 11111101
  /// (-4).bitLength == 2;  // 11111100
  /// ```
  int get bitLength => value.bitLength;

  /// Returns the least significant [width] bits of this integer as a
  /// non-negative number (i.e. unsigned representation).  The returned value has
  /// zeros in all bit positions higher than [width].
  /// ```dart
  /// (-1).toUnsigned(5) == 31   // 11111111  ->  00011111
  /// ```
  /// This operation can be used to simulate arithmetic from low level languages.
  /// For example, to increment an 8 bit quantity:
  /// ```dart
  /// q = (q + 1).toUnsigned(8);
  /// ```
  /// `q` will count from `0` up to `255` and then wrap around to `0`.
  ///
  /// If the input fits in [width] bits without truncation, the result is the
  /// same as the input.  The minimum width needed to avoid truncation of `x` is
  /// given by `x.bitLength`, i.e.
  /// ```dart
  /// x == x.toUnsigned(x.bitLength);
  /// ```
  int toUnsigned(int width) => value.toUnsigned(width);

  /// Returns the least significant [width] bits of this integer, extending the
  /// highest retained bit to the sign. This is the same as truncating the value
  /// to fit in [width] bits using an signed 2-s complement representation. The
  /// returned value has the same bit value in all positions higher than [width].
  ///
  /// ```dart
  ///                          //     V--sign bit-V
  /// 16.toSigned(5) == -16;   //  00010000 -> 11110000
  /// 239.toSigned(5) == 15;   //  11101111 -> 00001111
  ///                          //     ^           ^
  /// ```
  /// This operation can be used to simulate arithmetic from low level languages.
  /// For example, to increment an 8 bit signed quantity:
  /// ```dart
  /// q = (q + 1).toSigned(8);
  /// ```
  /// `q` will count from `0` up to `127`, wrap to `-128` and count back up to
  /// `127`.
  ///
  /// If the input value fits in [width] bits without truncation, the result is
  /// the same as the input.  The minimum width needed to avoid truncation of `x`
  /// is `x.bitLength + 1`, i.e.
  /// ```dart
  /// x == x.toSigned(x.bitLength + 1);
  /// ```
  int toSigned(int width) => value.toSigned(width);

  /// 相等
  @override
  bool operator ==(Object other) {
    if (other is AbstractInt) {
      return value == other.value;
    } else {
      return value == other;
    }
  }

  /// Returns the absolute value of this integer.
  ///
  /// For any integer `value`,
  /// the result is the same as `value < 0 ? -value : value`.
  ///
  /// Integer overflow may cause the result of `-value` to stay negative.
  T abs() => valueOf(value.abs());

  /// Returns the sign of this integer.
  ///
  /// Returns 0 for zero, -1 for values less than zero and
  /// +1 for values greater than zero.
  int get sign => value.sign;

  /// Returns `this`.
  T round() => valueOf(value.round());

  /// Returns `this`.
  T floor() => valueOf(value.floor());

  /// Returns `this`.
  T ceil() => valueOf(value.ceil());

  /// Returns `this`.
  T truncate() => valueOf(value.truncate());

  /// Returns `this.toDouble()`.
  double roundToDouble() => value.roundToDouble();

  /// Returns `this.toDouble()`.
  double floorToDouble() => value.floorToDouble();

  /// Returns `this.toDouble()`.
  double ceilToDouble() => value.ceilToDouble();

  /// Returns `this.toDouble()`.
  double truncateToDouble() => value.truncateToDouble();

  /// Returns a string representation of this integer.
  ///
  /// The returned string is parsable by [parse].
  /// For any `int` `i`, it is guaranteed that
  /// `i == int.parse(i.toString())`.
  @override
  String toString() => value.toString();

  /// Converts [this] to a string representation in the given [radix].
  ///
  /// In the string representation, lower-case letters are used for digits above
  /// '9', with 'a' being 10 and 'z' being 35.
  ///
  /// The [radix] argument must be an integer in the range 2 to 36.
  ///
  /// Example:
  /// ```dart
  /// // Binary (base 2).
  /// print(12.toRadixString(2)); // 1100
  /// print(31.toRadixString(2)); // 11111
  /// print(2021.toRadixString(2)); // 11111100101
  /// print((-12).toRadixString(2)); // -1100
  /// // Octal (base 8).
  /// print(12.toRadixString(8)); // 14
  /// print(31.toRadixString(8)); // 37
  /// print(2021.toRadixString(8)); // 3745
  /// // Hexadecimal (base 16).
  /// print(12.toRadixString(16)); // c
  /// print(31.toRadixString(16)); // 1f
  /// print(2021.toRadixString(16)); // 7e5
  /// // Base 36.
  /// print((35 * 36 + 1).toRadixString(36)); // z1
  /// ```
  String toRadixString(int radix) => value.toRadixString(radix);

  @override
  int compareTo(T other) {
    return value.compareTo(other.value);
  }

  @override
  int get hashCode => value.hashCode;
}
