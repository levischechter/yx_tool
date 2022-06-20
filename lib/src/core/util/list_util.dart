import 'dart:typed_data';

import 'package:yx_tool/src/core/lang/math/math.dart';

/// 数组工具集
class ListUtil {
  ListUtil._();

  /// 如果此集合中为null，或者没有元素，则返回true 。
  static bool isEmpty(Iterable<dynamic>? iterable) {
    return iterable == null || iterable.isEmpty;
  }

  /// 返回一个新列表，其中包含在start （含）和end （含）之间的索引处的元素。
  // 如果end被省略，它被设置为lastIndex 。
  static List<E> slice<E>(List<E> list, int start, [int end = -1]) {
    if (start < 0) {
      start = start + list.length;
    }
    if (end < 0) {
      end = end + list.length;
    }

    RangeError.checkValidRange(start, end, list.length);

    return list.sublist(start, end + 1);
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
  static Uint8List copyOf(List<int> original, int newLength) {
    var copy = Uint8List(newLength);
    arraycopy(original, 0, copy, 0, Math.min(original.length, newLength));
    return copy;
  }

  /// 复制指定的数组，用零截断或填充（如有必要），以便副本具有指定的长度。
  /// 对于在原始数组和副本中都有效的所有索引，这两个数组将包含相同的值。
  /// 对于在副本中有效但在原始副本中无效的任何索引，副本将包含(byte)0 。
  /// 当且仅当指定长度大于原始数组的长度时，此类索引才会存在。
  static T copyOfList<T extends List<int>>(List<int> original, T newList) {
    arraycopy(original, 0, newList, 0, Math.min(original.length, newList.length));
    return newList;
  }

  /// 将指定的值分配给指定数组的每个元素。
  static void fill<T>(List<T> a, T val) {
    for (var i = 0, len = a.length; i < len; i++) {
      a[i] = val;
    }
  }

  /// 在目标数组中插入元素,[dest]可以是新数组也可以是原数组，如果是原数组需要保证可修改
  /// [dest]中的元素将会被[source]的元素覆盖
  static void insertAll(List<int> source, List<int> dest, int index, List<int> elements) {
    if (source == dest) {
      source.insertAll(index, elements);
      return;
    }
    RangeError.checkNotNegative(dest.length - source.length - elements.length, 'length');
    RangeError.checkValidIndex(index, dest);
    if (index != 0) {
      arraycopy(source, 0, dest, 0, index);
    }
    arraycopy(elements, 0, dest, index, elements.length);
    arraycopy(source, index, dest, index + elements.length, elements.length);
  }

  /// 交换数组中两个位置的值
  /// 交换后的数组，与传入数组为同一对象
  static List<E> swap<E>(List<E> array, int index1, int index2) {
    if (isEmpty(array)) {
      throw ArgumentError("Number array must not empty !");
    }
    var tmp = array[index1];
    array[index1] = array[index2];
    array[index2] = tmp;
    return array;
  }

  ///取最大值
  static int max(List<int> data) {
    if (isEmpty(data)) {
      throw ArgumentError("Number array must not empty !");
    }
    int max = data[0];
    for (int i = 1; i < data.length; i++) {
      if (max < data[i]) {
        max = data[i];
      }
    }
    return max;
  }

  /// 取最小值
  static int min(List<int> data) {
    if (isEmpty(data)) {
      throw ArgumentError("Number array must not empty !");
    }
    int min = data[0];
    for (int i = 1; i < data.length; i++) {
      if (min > data[i]) {
        min = data[i];
      }
    }
    return min;
  }

  /// 生成一个数字列表
  static List<int> range({int includedStart = 0, required int excludedEnd, int step = 1}) {
    if (includedStart > excludedEnd) {
      int tmp = includedStart;
      includedStart = excludedEnd;
      excludedEnd = tmp;
    }

    if (step <= 0) {
      step = 1;
    }

    int deviation = excludedEnd - includedStart;
    int length = deviation ~/ step;
    if (deviation % step != 0) {
      length += 1;
    }
    List<int> range = List.filled(length, 0);
    for (int i = 0; i < length; i++) {
      range[i] = includedStart;
      includedStart += step;
    }
    return range;
  }
}
