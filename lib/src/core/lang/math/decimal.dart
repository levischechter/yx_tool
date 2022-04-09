import 'package:yx_tool/src/core/lang/num/number.dart';

final _pattern = RegExp(r'^([+-]?\d*)(\.\d*)?([eE][+-]?\d+)?$');

final _i0 = BigInt.zero;
final _i1 = BigInt.one;
final _i2 = BigInt.two;
final _i5 = BigInt.from(5);
final _i10 = BigInt.from(10);

final _d0 = Decimal.zero;
final _d5 = Decimal.fromInt(5);
final _d10 = Decimal.fromInt(10);

BigInt _gcd(BigInt a, BigInt b) {
  while (b != _i0) {
    final t = b;
    b = a % b;
    a = t;
  }
  return a;
}

/// A number that can be exactly written with a finite number of digits in the
/// decimal system.
class Decimal extends Number<Decimal> {

  /// The numerator of this rational number.
  final BigInt numerator;

  /// The denominator of this rational number.
  final BigInt denominator;

  /// Create a new rational number from its [numerator] and a non-zero
  /// [denominator].
  ///
  /// If the [denominator] is omitted then its value will be `1`.
  Decimal._fromCanonicalForm(this.numerator, this.denominator)
      : assert(denominator > _i0),
        assert(numerator.abs().gcd(denominator) == _i1);


  /// Create a new rational number from its [numerator] and a non-zero
  /// [denominator].
  ///
  /// If the [denominator] is omitted then its value will be `1`.
  factory Decimal._(BigInt numerator, [BigInt? denominator]) {
    if (denominator == null) return Decimal._fromCanonicalForm(numerator, _i1);
    if (denominator == _i0) {
      throw ArgumentError('zero can not be used as denominator');
    }
    if (numerator == _i0) return Decimal._fromCanonicalForm(_i0, _i1);
    if (denominator < _i0) {
      numerator = -numerator;
      denominator = -denominator;
    }
    // TODO(a14n): switch back when https://github.com/dart-lang/sdk/issues/46180 is fixed
    // final gcd = numerator.abs().gcd(denominator.abs());
    final gcd = _gcd(numerator.abs(), denominator.abs());
    return Decimal._fromCanonicalForm(numerator ~/ gcd, denominator ~/ gcd);
  }

  /// Create a new decimal from its rational value.
  // Decimal._(this._rational) : assert(_rational.hasFinitePrecision);

  /// Create a new [Decimal] from a [BigInt].
  factory Decimal.fromBigInt(BigInt value) => Decimal._(value);

  /// Create a new [Decimal] from an [int].
  factory Decimal.fromInt(int value) => Decimal.fromBigInt(BigInt.from(value));

  /// Create a new [Decimal] from its [String] representation.
  factory Decimal.fromString(String value) => Decimal.parse(value);

  /// Create a new [Decimal] from its [Double] representation.
  factory Decimal.fromDouble(double value) => Decimal.parse(value.toString());


  /// Returns a [Decimal] corresponding to `this`.
  ///
  /// Some rational like `1/3` can not be converted to decimal because they need
  /// an infinite number of digits. For those cases (where [hasFinitePrecision]
  /// is `false`) a [scaleOnInfinitePrecision] can be provided to truncate its
  /// decimal representation. Note that the returned decimal will not be exactly
  /// equal to `this`.
  Decimal _toDecimal({int? scaleOnInfinitePrecision}) {
    if (scaleOnInfinitePrecision == null || hasFinitePrecision) {
      return this;
    }
    final scaleFactor = _d10.pow(scaleOnInfinitePrecision);
    return (this * scaleFactor).truncate() / scaleFactor;
  }

  /// Returns `true` if this [Decimal] has a finite precision.
  ///
  /// Having a finite precision means that the number can be exactly represented
  /// as decimal with a finite number of fractional digits.
  bool get hasFinitePrecision {
    // the denominator should only be a product of powers of 2 and 5
    var den = denominator;
    while (den % _i5 == _i0) {
      den = den ~/ _i5;
    }
    while (den % _i2 == _i0) {
      den = den ~/ _i2;
    }
    return den == _i1;
  }

  /// Parses [source] as a decimal literal and returns its value as [Decimal].
  static Decimal parse(String source) {
    final match = _pattern.firstMatch(source);
    if (match == null) {
      throw FormatException('$source is not a valid format');
    }
    final group1 = match.group(1);
    final group2 = match.group(2);
    final group3 = match.group(3);

    var numerator = _i0;
    var denominator = _i1;
    if (group2 != null) {
      for (var i = 1; i < group2.length; i++) {
        denominator = denominator * _i10;
      }
      numerator = BigInt.parse('$group1${group2.substring(1)}');
    } else {
      numerator = BigInt.parse(group1!);
    }
    if (group3 != null) {
      var exponent = int.parse(group3.substring(1));
      if (exponent > 0) {
        numerator *= _i10.pow(exponent);
      }
      if (exponent < 0) {
        denominator *= _i10.pow(exponent.abs());
      }
    }
    return Decimal._(numerator, denominator)._toDecimal();
  }

  /// Parses [source] as a decimal literal and returns its value as [Decimal].
  static Decimal? tryParse(String source) {
    try {
      return Decimal.parse(source);
    } on FormatException {
      return null;
    }
  }

  /// The [Decimal] corresponding to `0`.
  static Decimal zero = Decimal.fromInt(0);

  /// The [Decimal] corresponding to `1`.
  static Decimal one = Decimal.fromInt(1);

  /// The [Decimal] corresponding to `10`.
  static Decimal ten = Decimal.fromInt(10);

  /// Returns `true` if `this` is an integer.
  bool get isInteger => denominator == _i1;

  /// Returns a [Decimal] corresponding to `1/this`.
  Decimal get inverse => Decimal._(denominator, numerator);

  @override
  bool operator ==(Object other) =>
      other is Decimal &&
          numerator == other.numerator &&
          denominator == other.denominator;

  @override
  int get hashCode => Object.hash(numerator, denominator);

  /// Returns a [String] representation of `this`.
  @override
  String toString() {
    if (isInteger) return _toString();
    var value = toStringAsFixed(scale);
    while (
    value.contains('.') && (value.endsWith('0') || value.endsWith('.'))) {
      value = value.substring(0, value.length - 1);
    }
    return value;
  }

  String _toString() {
    if (numerator == _i0) return '0';
    if (isInteger) {
      return '$numerator';
    } else {
      return '$numerator/$denominator';
    }
  }

  @override
  int compareTo(Decimal other) =>
      (numerator * other.denominator).compareTo(other.numerator * denominator);

  /// Addition operator.
  Decimal operator +(Decimal other) => Decimal._(
    numerator * other.denominator + other.numerator * denominator,
    denominator * other.denominator,
  )._toDecimal();

  /// Subtraction operator.
  Decimal operator -(Decimal other) => Decimal._(
    numerator * other.denominator - other.numerator * denominator,
    denominator * other.denominator,
  )._toDecimal();

  /// Multiplication operator.
  Decimal operator *(Decimal other) => Decimal._(
    numerator * other.numerator,
    denominator * other.denominator,
  )._toDecimal();

  /// Euclidean modulo operator.
  ///
  /// See [num.operator%].
  Decimal operator %(Decimal other) {
    final remainder = this.remainder(other);
    if (remainder == _d0) return _d0;
    return remainder + (isNegative ? other.abs() : _d0);
  }

  bool get isNegative => numerator.isNegative;

  /// Division operator.
  Decimal operator /(Decimal other) => Decimal._(
    numerator * other.denominator,
    denominator * other.numerator,
  );

  /// Truncating division operator.
  ///
  /// See [num.operator~/].
  Decimal operator ~/(Decimal other) => (this / other).truncate();

  /// Returns the negative value of this rational.
  Decimal operator -() => Decimal._(-numerator, denominator)._toDecimal();

  /// Returns the remainder from dividing this [Decimal] by [other].
  Decimal remainder(Decimal other) =>
      (this - (this ~/ other) * other)._toDecimal();

  /// Whether this number is numerically smaller than [other].
  bool operator <(Decimal other) => compareTo(other) < 0;

  /// Whether this number is numerically smaller than or equal to [other].
  bool operator <=(Decimal other) => compareTo(other) <= 0;

  /// Whether this number is numerically greater than [other].
  bool operator >(Decimal other) => compareTo(other) > 0;

  /// Whether this number is numerically greater than or equal to [other].
  bool operator >=(Decimal other) => compareTo(other) >= 0;

  /// Returns the absolute value of `this`.
  Decimal abs() => (isNegative ? (-this) : this)._toDecimal();

  /// The signum function value of `this`.
  ///
  /// E.e. -1, 0 or 1 as the value of this [Decimal] is negative, zero or positive.
  int get signum {
    final v = compareTo(_d0);
    if (v < 0) return -1;
    if (v > 0) return 1;
    return 0;
  }

  /// Returns the greatest [Decimal] value no greater than this [Decimal].
  ///
  /// An optional [scale] value can be provided as parameter to indicate the
  /// digit used as reference for the operation.
  ///
  /// ```
  /// var x = Decimal.parse('123.4567');
  /// x.floor(); // 123
  /// x.floor(scale: 1); // 123.4
  /// x.floor(scale: 2); // 123.45
  /// x.floor(scale: -1); // 120
  /// ```
  Decimal floor({int scale = 0}) => _scaleAndApply(scale, (e) => e._floor());

  /// The [BigInt] obtained by discarding any fractional digits from `this`.
  BigInt _truncate() => numerator ~/ denominator;

  /// Returns the greatest [BigInt] value no greater than this [Decimal].
  BigInt _floor() => isInteger
      ? _truncate()
      : isNegative
      ? (_truncate() - _i1)
      : _truncate();

  /// Returns the least [Decimal] value that is no smaller than this [Decimal].
  ///
  /// An optional [scale] value can be provided as parameter to indicate the
  /// digit used as reference for the operation.
  ///
  /// ```
  /// var x = Decimal.parse('123.4567');
  /// x.ceil(); // 124
  /// x.ceil(scale: 1); // 123.5
  /// x.ceil(scale: 2); // 123.46
  /// x.ceil(scale: -1); // 130
  /// ```
  Decimal ceil({int scale = 0}) => _scaleAndApply(scale, (e) => e._ceil());

  /// Returns the least [BigInt] value that is no smaller than this [Decimal].
  BigInt _ceil() => isInteger
      ? _truncate()
      : isNegative
      ? _truncate()
      : (_truncate() + _i1);

  /// Returns the [Decimal] value closest to this number.
  ///
  /// Rounds away from zero when there is no closest integer:
  /// `(3.5).round() == 4` and `(-3.5).round() == -4`.
  ///
  /// An optional [scale] value can be provided as parameter to indicate the
  /// digit used as reference for the operation.
  ///
  /// ```
  /// var x = Decimal.parse('123.4567');
  /// x.round(); // 123
  /// x.round(scale: 1); // 123.5
  /// x.round(scale: 2); // 123.46
  /// x.round(scale: -1); // 120
  /// ```
  Decimal round({int scale = 0}) => _scaleAndApply(scale, (e) => e._round());

  /// Returns the [BigInt] value closest to this number.
  ///
  /// Rounds away from zero when there is no closest integer:
  /// `(3.5).round() == 4` and `(-3.5).round() == -4`.
  BigInt _round() {
    final abs = this.abs();
    final absBy10 = abs * _d10;
    var r = abs._truncate();
    if (absBy10 % _d10 >= _d5) r += _i1;
    return isNegative ? -r : r;
  }

  Decimal _scaleAndApply(int scale, BigInt Function(Decimal) f) {
    final scaleFactor = ten.pow(scale);
    return (Decimal._(f(this * scaleFactor)) / scaleFactor)._toDecimal();
  }

  /// The [BigInt] obtained by discarding any fractional digits from `this`.
  Decimal truncate({int scale = 0}) =>
      _scaleAndApply(scale, (e) => e._truncate());

  /// Shift the decimal point on the right for positive [value] or on the left
  /// for negative one.
  ///
  /// ```dart
  /// var x = Decimal.parse('123.4567');
  /// x.shift(1); // 1234.567
  /// x.shift(-1); // 12.34567
  /// ```
  Decimal shift(int value) => this * ten.pow(value);

  /// Clamps `this` to be in the range [lowerLimit]-[upperLimit].
  Decimal clamp(Decimal lowerLimit, Decimal upperLimit) {
    return (this < lowerLimit
        ? lowerLimit
        : this > upperLimit
        ? upperLimit
        : this)._toDecimal();
  }

  /// The [BigInt] obtained by discarding any fractional digits from `this`.
  BigInt toBigInt() => _truncate();

  /// Returns `this` as a [double].
  ///
  /// If the number is not representable as a [double], an approximation is
  /// returned. For numerically large integers, the approximation may be
  /// infinite.
  double toDouble() => numerator / denominator;

  /// The precision of this [Decimal].
  ///
  /// The precision is the number of digits in the unscaled value.
  ///
  /// ```dart
  /// Decimal.parse('0').precision; // => 1
  /// Decimal.parse('1').precision; // => 1
  /// Decimal.parse('1.5').precision; // => 2
  /// Decimal.parse('0.5').precision; // => 2
  /// ```
  int get precision {
    final value = abs();
    return value.scale + value.toBigInt().toString().length;
  }

  /// The scale of this [Decimal].
  ///
  /// The scale is the number of digits after the decimal point.
  ///
  /// ```dart
  /// Decimal.parse('1.5').scale; // => 1
  /// Decimal.parse('1').scale; // => 0
  /// ```
  int get scale {
    var i = 0;
    var x = this;
    while (!x.isInteger) {
      i++;
      x *= _d10;
    }
    return i;
  }

  /// A decimal-point string-representation of this number with [fractionDigits]
  /// digits after the decimal point.
  String toStringAsFixed(int fractionDigits) {
    assert(fractionDigits >= 0);
    if (fractionDigits == 0) return round().toBigInt().toString();
    final value = round(scale: fractionDigits);
    final intPart = value.toBigInt().abs();
    final decimalPart =
    (one + value.abs() - Decimal._(intPart)._toDecimal()).shift(fractionDigits);
    return '${value < zero ? '-' : ''}$intPart.${decimalPart.toString().substring(1)}';
  }

  /// An exponential string-representation of this number with [fractionDigits]
  /// digits after the decimal point.
  String toStringAsExponential([int fractionDigits = 0]) {
    assert(fractionDigits >= 0);

    final negative = this < zero;
    var value = abs();
    var eValue = 0;
    while (value < one && value > zero) {
      value *= ten;
      eValue--;
    }
    while (value >= ten) {
      value = (value / ten)._toDecimal();
      eValue++;
    }
    return <String>[
      if (negative) '-',
      value.round(scale: fractionDigits).toStringAsFixed(fractionDigits),
      'e',
      if (eValue >= 0) '+',
      '$eValue',
    ].join();
  }

  /// A string representation with [precision] significant digits.
  String toStringAsPrecision(int precision) {
    assert(precision > 0);

    if (this == zero) {
      return <String>[
        '0',
        if (precision > 1) '.',
        for (var i = 1; i < precision; i++) '0',
      ].join();
    }

    final limit = ten.pow(precision);

    var shift = one;
    final absValue = abs();
    var pad = 0;
    while (absValue * shift < limit) {
      pad++;
      shift *= ten;
    }
    while (absValue * shift >= limit) {
      pad--;
      shift = (shift / ten)._toDecimal();
    }
    final value = ((this * shift).round() / shift)._toDecimal();
    return pad <= 0 ? value.toString() : value.toStringAsFixed(pad);
  }

  /// Returns `this` to the power of [exponent].
  ///
  /// Returns [one] if the [exponent] equals `0`.
  Decimal pow(int exponent) => exponent.isNegative
      ? inverse.pow(-exponent)
      : Decimal._(
    numerator.pow(exponent),
    denominator.pow(exponent),
  )._toDecimal();

  @override
  double get value => toDouble();
}