import 'package:yx_tool/src/core/lang/num/number.dart';

/// 限制int为64位Long
class Long extends AbstractInt<Long> {
  ///最大值
  static const maxValue = 0x7FFFFFFFFFFFFFFF;

  ///最小值
  static const minValue = -0x8000000000000000;

  ///内部维护值
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
