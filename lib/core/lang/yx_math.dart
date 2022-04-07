import 'dart:math' as M;

class Math {
  ///自然对数的底。
  /// 通常写为“e”。
  static const e = M.e;

  /// 10 的自然对数。
  /// 10 的自然对数是满足 `pow(E, LN10) == 10` 的数字。
  /// 这个值并不精确，但它是最接近精确数学值的可表示双精度数。
  static const ln10 = M.ln10;

  /// 2 的自然对数。
  /// 2 的自然对数是满足 `pow(E, LN2) == 2` 的数字。
  /// 这个值并不精确，但它是最接近精确数学值的可表示双精度数。
  static const ln2 = M.ln2;

  /// [e] 的以 2 为底的对数。
  static const log2e = M.log2e;

  /// [e] 的以 10 为底的对数。
  static const log10e = M.log10e;

  /// PI 常数。
  static const pi = M.pi;

  /// 12 的平方根。
  static const sqrt1_2 = M.sqrt1_2;

  /// 2 的平方根。
  static const sqrt2 = M.sqrt2;

  /// 常数乘以以度为单位的角度值以获得以弧度为单位的角度值。
  static const double DEGREES_TO_RADIANS = 0.017453292519943295;

  /// 常数，与以弧度为单位的角度值相乘以获得以度为单位的角度值。
  static const double RADIANS_TO_DEGREES = 57.29577951308232;

  /// 返回两个数字中的较小者。
  ///
  /// Returns NaN if either argument is NaN.
  /// `-0.0` 和 `0.0` 中的较小者是 `-0.0`。
  /// 如果参数在其他方面相等（包括具有相同数学值的 int 和 doubles），则未指定返回两个参数中的哪一个。
  static T min<T extends num>(T a, T b) {
    return M.min(a, b);
  }

  /// 返回两个数字中较大的一个。
  ///
  /// Returns NaN if either argument is NaN.
  /// `-0.0` 和 `0.0` 的较大者是 `0.0`。如果参数在其他方面相等（包括具有相同数学值的 int 和 doubles），则未指定返回两个参数中的哪一个。
  static T max<T extends num>(T a, T b) {
    return M.max(a, b);
  }

  /// [atan] 的变体。
  ///
  /// 将两个参数都转换为 [double]s。
  ///
  ///返回正 x 轴和向量 ([b],[a]) 之间的弧度角。
  /// 结果在 -PI..PI 范围内。
  ///
  /// 如果 [b] 为正，则与 `atan(a/b)` 相同。
  ///
  /// 当 [a] 为负时（包括当 [a] 为双 -0.0 时），结果为负。
  ///
  /// 如果 [a] 等于 0，则向量 ([b],[a]) 被认为平行于 x 轴，即使 [b] 也等于 0。 [b] 的符号决定了向量沿 x 轴的方向。
  ///
  /// Returns NaN if either argument is NaN.
  static double atan2(num a, num b) {
    return M.atan2(a, b);
  }

  /// 返回 [x] 的 [exponent] 次方。
  ///
  /// 如果 [x] 是 [int] 并且 [exponent] 是非负 [int]，则结果是 [int]，否则两个参数首先转换为双精度数，结果是 [双精度数]。
  ///
  /// 对于整数，幂始终等于“x”的数学结果乘以“指数”的幂，仅受可用内存的限制。
  ///
  /// 对于doubles，`pow(x, y)` 处理边缘情况如下：
  ///
  /// - 如果 `y` 为零（0.0 或 -0.0），则结果始终为 1.0。
  /// - 如果 `x` 为 1.0，则结果始终为 1.0。
  /// - 否则，如果 `x` 或 `y` 为 NaN，则结果为 NaN。
  /// - 如果 `x` 为负数（但不是 -0.0）并且 `y` 是有限非整数，则结果为 NaN。
  /// - 如果 `x` 为 Infinity 并且 `y` 为负数，则结果为 0.0。
  /// - 如果 `x` 为 Infinity 并且 `y` 为正数，则结果为 Infinity。
  /// - 如果 `x` 为 0.0 且 `y` 为负数，则结果为无穷大。
  /// - 如果 `x` 为 0.0 且 `y` 为正，则结果为 0.0。
  /// - 如果 `x` 是 -Infinity 或 -0.0 并且 `y` 是奇数，则结果是 `-pow(-x ,y)`。
  /// - 如果 `x` 是 -Infinity 或 -0.0 并且 `y` 不是奇数，则结果与 `pow(-x , y)` 相同。
  /// - 如果 `y` 为 Infinity 并且 `x` 的绝对值小于 1，则结果为 0.0。
  /// - 如果 `y` 为 Infinity 并且 `x` 为 -1，则结果为 1.0。
  /// - 如果 `y` 为 Infinity 并且 `x` 的绝对值大于 1，则结果为 Infinity。
  /// - 如果 `y` 为 -Infinity，则结果为 `1pow(x, Infinity)`。
  ///
  /// 这对应于 IEEE 标准 754-2008 中定义的“pow”函数。
  ///
  /// 请注意，结果可能会溢出。如果整数表示为 64 位数字，则整数结果可能会被截断，双精度结果可能会溢出为正数或负数 [double.infinity]。
  static num pow(num x, num exponent) {
    return M.pow(x, exponent);
  }

  /// 将 [radians] 转换为 [double] 并返回值的正弦值。
  ///
  /// 如果 [弧度] 不是有限数，则结果为 NaN。
  static double sin(num radians) {
    return M.sin(radians);
  }

  /// 将 [radians] 转换为 [double] 并返回值的余弦值。
  ///
  /// 如果 [弧度] 不是有限数，则结果为 NaN。
  static double cos(num radians) {
    return M.cos(radians);
  }

  /// 将 [radians] 转换为 [double] 并返回值的正切值。
  ///
  /// 正切函数等价于 `sin(radians)cos(radians)`，当 `cos(radians)` 等于 0 时，它可能是无限的（正或负）。
  /// 如果 [弧度] 不是有限数，则结果为 NaN。
  static double tan(num radians) {
    return M.tan(radians);
  }

  /// 将 [x] 转换为 [double] 并以弧度返回其反余弦值。
  ///
  /// 返回 0..PI 范围内的值，如果 [x] 超出范围 -1..1，则返回 NaN。
  static double acos(num x) {
    return M.acos(x);
  }

  /// 将 [x] 转换为 [double] 并以弧度返回其反正弦值。
  ///
  /// 返回范围 -PI2..PI2 中的值，如果 [x] 超出范围 -1..1，则返回 NaN。
  static double asin(num x) {
    return M.asin(x);
  }

  /// 将 [x] 转换为 [double] 并以弧度返回其反正切。
  ///
  /// 返回 -PI2..PI2 范围内的值，如果 [x] 为 NaN，则返回 NaN。
  static double atan(num x) {
    return M.atan(x);
  }

  /// 将 [x] 转换为 [double] 并返回值的正平方根。
  ///
  /// 如果 [x] 为 -0.0，则返回 -0.0，如果 [x] 为负数或 NaN，则返回 NaN。
  /// ```dart
  /// var result = sqrt(9.3);
  /// print(result); // 3.0495901363953815
  /// result = sqrt(2);
  /// print(result); // 1.4142135623730951
  /// result = sqrt(0);
  /// print(result); // 0.0
  /// result = sqrt(-2.2);
  /// print(result); // NaN
  /// ```
  static double sqrt(num x) {
    return M.sqrt(x);
  }

  /// 将 [x] 转换为 [double] 并将自然指数 [e] 返回到 [x] 的幂。
  ///
  /// Returns NaN if [x] is NaN.
  static double exp(num x) {
    return M.exp(x);
  }

  /// 将 [x] 转换为 [double] 并返回值的自然对数。
  ///
  /// 如果 [x] 等于 0，则返回负无穷大。
  /// 如果 [x] 为 NaN 或小于零，则返回 NaN。
  static double log(num x) {
    return M.log(x);
  }

  /// 将以度为单位的角度转换为以弧度为单位的大致等效角度。从度数到弧度的转换通常是不精确的。
  ///
  /// [angdeg] 一个角度，以度为单位
  ///
  /// return  以弧度为单位的角度 [angdeg] 的测量值。
  static double toRadians(double angdeg) {
    return angdeg * DEGREES_TO_RADIANS;
  }

  /// 将以弧度测量的角度转换为以度为单位测量的大致等效角度。从弧度到度数的转换通常是不精确的；
  /// 用户应该不期望 [cos([toRadians])] 完全等于 0.0。
  ///
  /// param   [angrad] 一个角度，以弧度为单位
  /// return  以度为单位的角度 {@code angrad} 的测量值。
  static double toDegrees(double angrad) {
    return angrad * RADIANS_TO_DEGREES;
  }

  /// 不小于[num]的最小整数。
  /// 将小数值向正无穷大舍入。
  /// 该数字必须是有限的（参见isFinite ）。
  /// 如果该值大于可表示的最大正整数，则结果为该最大正整数。如果该值小于可表示的最大负整数，则结果为最大负整数。
  static int ceil(num n) {
    return n.ceil();
  }

  ///不大于此数的最大整数。
  /// 将小数值向负无穷大舍入。
  /// 该数字必须是有限的（参见isFinite ）。
  /// 如果该值大于可表示的最大正整数，则结果为该最大正整数。如果该值小于可表示的最大负整数，则结果为最大负整数。
  static int floor(num n){
    return n.floor();
  }

  ///最接近此数字的整数。
  /// 当没有最接近的整数时从零开始舍入： (3.5).round() == 4和(-3.5).round() == -4 。
  /// 该数字必须是有限的（参见isFinite ）。
  /// 如果该值大于可表示的最大正整数，则结果为该最大正整数。如果该值小于可表示的最大负整数，则结果为最大负整数。
  static int round(num n){
    return n.round();
  }

  ///返回此整数的绝对值。
  /// 对于任何整value ，结果与value < 0 ? -value : value 。
  /// 整数溢出可能导致-value的结果保持负数。
  static int abs(int n){
    return n.abs();
  }
}
