import 'dart:typed_data';

import 'package:yx_tool/src/core/lang/yx_math.dart';

class CollectionUtil {
  /// 如果此集合中为null，或者没有元素，则返回true 。
  static bool isEmpty(Iterable<dynamic>? iterable) {
    return iterable == null || iterable.isEmpty;
  }

  /// 返回一个新列表，其中包含在start （含）和end （含）之间的索引处的元素。
  // 如果end被省略，它被设置为lastIndex 。
  static List<E> slice<E>(List<E> list, int start, [int end = -1]) {
    var _start = start;
    var _end = end;

    if (_start < 0) {
      _start = _start + list.length;
    }
    if (_end < 0) {
      _end = _end + list.length;
    }

    RangeError.checkValidRange(_start, _end, list.length);

    return list.sublist(_start, _end + 1);
  }

  /// 在原集合操作元素顺序反转,默认的[len]长度为集合的长度
  static void reverse(List collection, [int? len]) {
    len ??= collection.length;
    for (var i = 0; i < len ~/ 2; i++) {
      var next = len - 1 - i;
      if (i != next) {
        var b1 = collection[i];
        collection[i] = collection[next];
        collection[next] = b1;
      }
    }
  }

  /// 数组拷贝
  static void arraycopy(List<dynamic> src, int srcPos, List<dynamic> dest, int destPos, int length) {
    var sublist = src.sublist(srcPos, srcPos + length);
    for (var i = 0; i < length; i++) {
      dest[destPos + i] = sublist[i];
    }
  }

  /// 复制指定的数组，用零截断或填充（如有必要），以便副本具有指定的长度。
  /// 对于在原始数组和副本中都有效的所有索引，这两个数组将包含相同的值。
  /// 对于在副本中有效但在原始副本中无效的任何索引，副本将包含(byte)0 。
  /// 当且仅当指定长度大于原始数组的长度时，此类索引才会存在。
  static Uint8List copyOf(Uint8List original,int newLength) {
    var copy = Uint8List(newLength);
    arraycopy(original, 0, copy, 0, Math.min(original.length, newLength));
    return copy;
  }
}
