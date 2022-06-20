import 'dart:convert';
import 'dart:typed_data';

import 'package:yx_tool/src/core/util/int_util.dart';
import 'package:yx_tool/src/core/util/list_util.dart';

/// 可变的字符序列。字符串缓冲区类似于String ，但可以修改
class StringBuilder implements Comparable<StringBuilder>, Pattern {
  /// 该值用于字符存储,使用UTF-16存储字符串。
  late Uint16List value;

  /// 计数是使用的字符数。
  int count = 0;

  static final Uint16List _emptyValue = Uint16List(0);

  /// 以指定的初始容量[capacity]与编码器，初始化StringBuilder
  StringBuilder([int capacity = 0]) {
    RangeError.checkNotNegative(capacity, 'capacity');
    if (capacity == 0) {
      value = _emptyValue;
    } else {
      value = Uint16List(capacity << 1);
    }
  }

  /// 指定容量[capacity]
  factory StringBuilder.capacity(int capacity) {
    return StringBuilder(capacity);
  }

  /// 指定字符[str]
  factory StringBuilder.from(String str) {
    var sb = StringBuilder(str.length);
    sb.append(str);
    return sb;
  }

  ///追加对象，对象会被转换为字符串
  /// 参数[obj]，从索引[start] ，按顺序附加到此序列的内容，直到（独占）索引[end] 。该序列的长度增加了[end] - [start]的值。
  StringBuilder append(dynamic obj, [int start = 0, int? end]) {
    if (obj == null) {
      _appendNull();
    }
    var units = _convert(obj);
    end ??= units.length;
    _checkRange(start, end, units.length);
    var len = end - start;
    _expandCapacity(count + len);
    ListUtil.arraycopy(units, start, value, count, len);
    count += len;
    return this;
  }

  ///追加对象，对象会被转换为字符串
  ///对象之间会按照[separator]分割
  StringBuilder appendAll(Iterable<dynamic> objects,
      {String? before, String? separator, String? suffix}) {
    // 计算扩展容量
    var len = (before?.length ?? 0) + (suffix?.length ?? 0);
    for (var i = 0; i < objects.length; ++i) {
      var o = objects.elementAt(i);
      var units = _convert(o);
      len += units.length;
      if (separator != null && i != objects.length - 1) {
        len += separator.length;
      }
    }
    _expandCapacity(count + len);
    // 追加数据
    if (before != null) {
      append(before);
    }
    for (var i = 0; i < objects.length; ++i) {
      var o = objects.elementAt(i);
      append(o);
      if (separator != null && i != objects.length - 1) {
        append(separator);
      }
    }
    if (suffix != null) {
      append(suffix);
    }
    return this;
  }

  ///追加无符号int16
  StringBuilder appendUint(int uInt16) {
    _expandCapacity(count + 1);
    value[count] = uInt16;
    count += 1;
    return this;
  }

  ///追加有符号int16
  StringBuilder appendInt(int int16) {
    _expandCapacity(count + 1);
    value[count] = IntUtil.toUInt16(int16);
    count += 1;
    return this;
  }

  /// 内置转换对象为coding
  List<int> _convert(dynamic obj) {
    if (obj is StringBuilder) {
      return obj.codePoints();
    }
    return obj.toString().codeUnits;
  }

  /// 插入空字符串
  StringBuilder _appendNull() {
    _expandCapacity(this.count + 4);
    var count = this.count;
    ListUtil.arraycopy('null'.codeUnits, 0, value, count, 4);
    this.count += 4;
    return this;
  }

  ///在指定下标处插入对象，对象会被转换为字符串
  StringBuilder insert(int index, dynamic obj, [int offset = 0, int? len]) {
    _checkIndex(index);
    var list = _convert(obj);
    len ??= list.length;
    var end = len + offset;
    _checkRange(offset, end, length);

    _expandCapacity(count + len);
    _shift(index, len);
    count += len;
    ListUtil.arraycopy(list, offset, value, index, len);
    return this;
  }

  /// 删除此序列的子字符串中的字符。
  /// 子字符串从指定的start ，并延伸到索引end - 1处的字符，如果不存在这样的字符，则延伸到序列的末尾。
  /// 如果start等于end ，则不进行任何更改
  StringBuilder delete(int start, int end) {
    if (end > count) {
      end = count;
    }
    _checkRange(start, end, count);

    var len = end - start;
    if (len > 0) {
      _shift(end, -len);
      count -= len;
    }
    return this;
  }

  /// 移动数据
  void _shift(int offset, int n) {
    ListUtil.arraycopy(value, offset, value, (offset + n), (count - offset));
  }

  /// 删除此序列中指定位置的uint8 。这个序列缩短了一个uint8 。
  StringBuilder deleteCharAt(int index) {
    delete(index, index + 1);
    return this;
  }

  ///将此序列的子字符串中的字符替换为指定String中的字符。
  ///子字符串从指定的start ，并延伸到索引end - 1处的字符，如果不存在这样的字符，则延伸到序列的末尾。
  ///首先删除子字符串中的字符，然后在start处插入指定的String 。
  StringBuilder replace(int start, int end, dynamic obj) {
    if (end > count) {
      end = count;
    }
    _checkRange(start, end, count);
    var units = _convert(obj);
    var len = units.length;
    var newCount = count + len - (end - start);
    _ensureCapacity(newCount);
    _shift(end, newCount - count);
    count = newCount;

    ListUtil.arraycopy(units, 0, value, start, len);
    return this;
  }

  /// if out of bounds
  void _checkIndex(int index) {
    RangeError.checkValidIndex(index, value, null, count);
  }

  /// if out of bounds
  void _checkRange(int start, int end, length) {
    RangeError.checkValidRange(start, end, length);
  }

  /// 返回一个新String ，其中包含当前包含在此字符序列中的字符子序列。
  /// 子字符串从指定的索引开始并延伸到此序列的末尾。
  String substring(int start, [int? end]) {
    _checkRange(start, end ?? count, count);
    return String.fromCharCodes(value.sublist(start, end));
  }

  /// 返回此字符串中第一次出现指定子字符串的索引。
  int indexOf(Pattern pattern) {
    return toString().indexOf(pattern);
  }

  /// 返回此字符串中最后一个匹配pattern的起始位置，从start向后搜索
  int lastIndexOf(Pattern pattern, [int? start]) {
    return toString().lastIndexOf(pattern, start);
  }

  StringBuilder reverse() {
    ListUtil.reverse(value, count);
    return this;
  }

  /// 清空字符串
  StringBuilder clear() {
    delete(0, count);
    trimToSize();
    return this;
  }

  /// 尝试减少用于字符序列的存储空间。如果缓冲区大于保存其当前字符序列所需的大小，则可以调整其大小以提高空间效率。
  void trimToSize() {
    var length = count << 1;
    if (length < value.length) {
      value = value.sublist(0, length);
    }
  }

  /// 返回指定索引处的int值
  int codeUnitAt(int index) {
    _checkIndex(index);
    return value[index];
  }

  /// 返回指定索引处的String值
  String charAt(int index) {
    _checkIndex(index);
    return String.fromCharCode(value[index]);
  }

  /// 获取内部集合
  List<int> codePoints() {
    return value.sublist(0, count);
  }

  /// 对象相加
  StringBuilder operator +(StringBuilder strBuffer) {
    append(strBuffer);
    return this;
  }

  /// 字符串长度
  int get length => count;

  int get capacity => value.length;

  /// 是否为空
  bool get isEmpty => count == 0;

  /// 是否不为空
  bool get isNotEmpty => !isEmpty;

  /// 确认容量是否够用，不够用则扩展容量
  void _ensureCapacity(int minimumCapacity) {
    if (minimumCapacity - value.length > 0) {
      _expandCapacity(minimumCapacity);
    }
  }

  /// 扩展容量<br>
  /// 首先对容量进行二倍扩展，如果小于最小容量，则扩展为最小容量
  void _expandCapacity(int minimumCapacity) {
    var oldCapacity = value.length;
    if (minimumCapacity < oldCapacity) {
      return;
    }
    var newCapacity = (oldCapacity << 1) + 2;
    if (newCapacity < minimumCapacity) {
      newCapacity = minimumCapacity;
    }
    if (newCapacity < 0) {
      throw OutOfMemoryError();
    }
    var dest = Uint16List(newCapacity);
    ListUtil.arraycopy(value, 0, dest, 0, count);
    value = dest;
  }

  /// 默认使用utf8将字符串转为无符号字节数组
  /// 可选ending [ascii]、[utf8]、[latin1]、[systemEncoding]
  List<int> bytes([Encoding encoding = utf8]) {
    return encoding.encode(toString());
  }

  @override
  String toString() {
    return String.fromCharCodes(value.sublist(0, count));
  }

  @override
  int compareTo(StringBuilder other) {
    return toString().compareTo(other.toString());
  }

  @override
  Iterable<Match> allMatches(String string, [int start = 0]) {
    return toString().allMatches(string, start);
  }

  @override
  Match? matchAsPrefix(String string, [int start = 0]) {
    return toString().matchAsPrefix(string, start);
  }

  @override
  int get hashCode {
    return toString().hashCode;
  }

  @override
  bool operator ==(Object other) {
    return toString() == other.toString();
  }
}
