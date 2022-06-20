import 'dart:convert';
import 'dart:typed_data';

import 'package:yx_tool/src/core/util/str_util.dart';

/// String扩展方法
extension StringExtension on String {
  /// 以相反的顺序返回字符串
  String reversed() {
    return StrUtil.reversed(this);
  }

  /// 返回第一个元素
  int get first => codeUnits.first;

  /// 返回最后一个元素
  int get last => codeUnits.last;

  /// 忽略大小写匹配
  bool equalsIgnoreCase(String other) {
    return StrUtil.equalsIgnoreCase(this, other);
  }

  /// 字符串是否为空白，\n, ,\r,都将视为空
  bool get isBlank => StrUtil.isBlank(this);

  /// 字符串是否为非空白.不为null,不为空字符串,不为空格、全角空格、制表符、换行符，等不可见字符
  bool get isNotBlank => !isBlank;

  /// 使用utf8转为无符号byte
  Uint8List get bytes => utf8.encoder.convert(this);
}
