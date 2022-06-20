import 'package:yx_tool/src/core/lang/num/number.dart';

/// 限制int为16位Short
class Short extends AbstractInt<Short> {
  ///最大值
  static const maxValue = 0x7FFF;

  ///最小值
  static const minValue = -0x8000;

  ///内部维护值
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
