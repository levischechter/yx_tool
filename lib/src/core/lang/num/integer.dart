import 'package:yx_tool/src/core/lang/num/number.dart';

class Integer extends AbstractInt<Integer> {

  static const maxValue = 0x7FFFFFFF;
  static const minValue = -0x80000000;

  final int _value;

  Integer(int num) : _value = num.toSigned(32);

  @override
  int get value => _value;

  @override
  int get bits => 32;

  @override
  Integer valueOf(int num) {
    return Integer(num);
  }
}
