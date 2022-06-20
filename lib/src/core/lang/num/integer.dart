import 'package:yx_tool/src/core/lang/num/number.dart';

/// 限制int为32位Integer
class Integer extends AbstractInt<Integer> {
  ///最大值
  static const maxValue = 0x7FFFFFFF;

  ///最小值
  static const minValue = -0x80000000;

  ///内部维护值
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
