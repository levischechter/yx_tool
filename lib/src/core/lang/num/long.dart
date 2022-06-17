import 'package:yx_tool/src/core/lang/num/number.dart';

class Long extends AbstractInt<Long> {

  static const maxValue = 0x7FFFFFFFFFFFFFFF;
  static const minValue = -0x8000000000000000;

  final int _value;

  Long(int num) : _value = num.toSigned(64);

  @override
  int get value => _value;

  @override
  int get bits => 64;

  @override
  Long valueOf(int num) {
    return Long(num);
  }
}
