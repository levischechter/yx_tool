import 'package:yx_tool/src/core/lang/num/number.dart';

class Short extends AbstractInt<Short> {

  static const MAX_VALUE = 0x7FFF;
  static const MIN_VALUE = -0x8000;

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
