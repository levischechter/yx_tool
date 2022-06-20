import 'dart:math';
import 'dart:typed_data';

import 'package:yx_tool/src/core/util/list_util.dart';

/// 随机数工具
class RandomUtil {
  RandomUtil._();

  /// 填充随机数到集合中
  static List<int> nextInts(List<int> ints, {int min = 0, int max = 1 << 32, bool isSecure = false, Random? random}) {
    random ??= getRandom(isSecure);
    for (var i = 0; i < ints.length; i++) {
      ints[i] = random.nextInt(max) + min;
    }
    return ints;
  }

  /// 获取随机生成器
  static Random getRandom([bool isSecure = false]) {
    return isSecure ? Random.secure() : Random();
  }

  /// 生成在 0.0（含）到 1.0（不含）的范围内均匀分布的非负随机浮点值
  static double randomDouble() {
    return getRandom().nextDouble();
  }

  /// 生成一个随机布尔值
  static bool randomBool() {
    return getRandom().nextBool();
  }

  /// 生成一个随机整数，均匀分布在从 min（含）到max （不含）的范围内。
  /// 实现说明：默认实现支持介于 min 和 (1<<32) 之间的max
  static int randomInt({int min = 0, int max = 1 << 32}) {
    var range = max - min;
    return getRandom().nextInt(range) + min;
  }

  /// 生成[len]个随机整数，均匀分布在从 min（含）到max （不含）的范围内。
  /// 实现说明：默认实现支持介于 min 和 (1 << 8) 之间的max
  static List<int> randomInts({required int len, int min = 0, int max = 1 << 64}) {
    var ints = List.filled(len, 0, growable: true);
    nextInts(ints, min: min, max: max);
    return ints;
  }

  /// 生成[len]个随机字节，均匀分布在从 min（含）到max （不含）的范围内。
  /// 实现说明：默认实现支持介于 min 和 (1 << 8) 之间的max
  static Uint8List randomUint8s({required int len, int min = 0, int max = 1 << 8}) {
    var int8s = Uint8List(len);
    nextInts(int8s, min: min, max: max);
    return int8s;
  }

  /// 生成[len]个随机字节，均匀分布在从 min（含）到max （不含）的范围内。
  /// 实现说明：默认实现支持介于 min(-1 << 7) 和 (1 << 7 + 1) 之间的max
  static Int8List randomInt8s({required int len, int min = -1 << 7, int max = 1 << 7 + 1}) {
    var int8s = Int8List(len);
    nextInts(int8s, min: min, max: max);
    return int8s;
  }

  /// 生成[len]个随机整数，均匀分布在从 min（含）到max （不含）的范围内。
  /// 实现说明：默认实现支持介于 min 和 (1 << 16) 之间的max
  static Uint16List randomUint16s({required int len, int min = 0, int max = 1 << 16}) {
    var int16s = Uint16List(len);
    nextInts(int16s, min: min, max: max);
    return int16s;
  }

  /// 生成[len]个随机整数，均匀分布在从 min（含）到max （不含）的范围内。
  /// 实现说明：默认实现支持介于 min(-1 << 15) 和 (1 << 15 + 1) 之间的max
  static Int16List randomInt16s({required int len, int min = -1 << 15, int max = 1 << 15 + 1}) {
    var int16s = Int16List(len);
    nextInts(int16s, min: min, max: max);
    return int16s;
  }

  /// 生成[len]个随机整数，均匀分布在从 min（含）到max （不含）的范围内。
  /// 实现说明：默认实现支持介于 min 和 (1 << 32) 之间的max
  static Uint32List randomUint32s({required int len, int min = 0, int max = 1 << 32}) {
    var int32s = Uint32List(len);
    nextInts(int32s, min: min, max: max);
    return int32s;
  }

  /// 生成[len]个随机整数，均匀分布在从 min（含）到max （不含）的范围内。
  /// 实现说明：默认实现支持介于 min(-1 << 31) 和 (1 << 31 + 1) 之间的max
  static Int32List randomInt32s({required int len, int min = -1 << 31, int max = 1 << 31 + 1}) {
    var int32s = Int32List(len);
    nextInts(int32s, min: min, max: max);
    return int32s;
  }

  /// 生成[len]个随机长整数，均匀分布在从 min（含）到max （不含）的范围内。
  /// 实现说明：默认实现支持介于 min 和 (1 << 64) 之间的max
  static Uint64List randomUint64s({required int len, int min = 0, int max = 1 << 64}) {
    var int64s = Uint64List(len);
    nextInts(int64s, min: min, max: max);
    return int64s;
  }

  /// 生成[len]个随机长整数，均匀分布在从 min（含）到max （不含）的范围内。
  /// 实现说明：默认实现支持介于 min(-1 << 63) 和 (1 << 63 + 1) 之间的max
  static Int64List randomInt64s({required int len, int min = -1 << 63, int max = 1 << 63 + 1}) {
    var int64s = Int64List(len);
    nextInts(int64s, min: min, max: max);
    return int64s;
  }

  /// 返回一个随机元素
  static E randomElement<E>(List<E> data) {
    var nextIndex = getRandom().nextInt(data.length);
    return data[nextIndex];
  }

  /// 返回一组随机元素，[repeat]可选返回下标是否可重复
  static List<E> randomElements<E>(List<E> data, int len, {bool repeat = true}) {
    var result = <E>[];
    var random = getRandom();
    if (repeat) {
      for (int i = 0; i < len; i++) {
        result.add(data[random.nextInt(data.length)]);
      }
    } else {
      if (data.length <= len) {
        return List.from(data);
      }
      final List<int> randomList = randomIndexes(data.length).sublist(0, len);
      for (int e in randomList) {
        result.add(data[e]);
      }
    }
    return result;
  }

  /// 创建指定长度的随机索引
  static List<int> randomIndexes(int length) {
    final List<int> range = ListUtil.range(excludedEnd: length);
    for (int i = 0; i < length; i++) {
      int random = randomInt(min: i, max: length);
      ListUtil.swap(range, i, random);
    }
    return range;
  }
}
