import 'package:yx_tool/src/core/util/int_util.dart';

/// int扩展方法
extension IntExtension on int {
  /// 无符号8位整数
  int get uint8 => IntUtil.toUInt8(this);

  /// 无符号16位整数
  int get uint16 => IntUtil.toUInt16(this);

  /// 无符号32位整数
  int get uint32 => IntUtil.toUInt32(this);

  /// 无符号64位整数
  int get uint64 => IntUtil.toUInt64(this);

  /// 有符号8位整数
  int get int8 => IntUtil.toInt8(this);

  /// 有符号16位整数
  int get int16 => IntUtil.toInt16(this);

  /// 有符号32位整数
  int get int32 => IntUtil.toInt32(this);

  /// 有符号64位整数
  int get int64 => IntUtil.toInt64(this);
}
