import 'package:yx_tool/src/core/lang/num/number.dart';

class Short extends AbstractInt<Short> {

  static const maxValue = 0x7FFF;
  static const minValue = -0x8000;

  final int _value;

  Short(int num) : _value = num.toSigned(16);

  @override
  int get value => _value;

  @override
  int get bits => 16;

  @override
  Short valueOf(int num) {
    return Short(num);
  }
}
