import 'package:yx_tool/src/core/lang/num/number.dart';

/// 限制int为8位Byte
class Byte extends AbstractInt<Byte> {
  ///最大值
  static const maxValue = 0x7F;

  ///最小值
  static const minValue = -0x80;

  ///内部维护值
  final int _value;

  Byte(int num) : _value = num.toSigned(8);

  @override
  int get value => _value;

  @override
  int get bits => 8;

  @override
  Byte valueOf(int num) {
    return Byte(num);
  }
}
