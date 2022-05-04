import 'dart:math';

import 'dart:typed_data';

/// 随机数工具
class RandomUtil {
  RandomUtil._();

  /// 填充随机数到集合中
  static List<int> nextInts(List<int> ints, {int max = 1 << 32, bool isSecure = false, Random? random}) {
    random ??= getRandom(isSecure);
    for (var i = 0; i < ints.length; i++) {
      ints[i] = random.nextInt(max);
    }
    return ints;
  }

  /// 获取随机生成器
  static Random getRandom([bool isSecure = false]) {
    return isSecure ? Random.secure() : Random();
  }

  /// 生成在 0.0（含）到 1.0（不含）的范围内均匀分布的非负随机浮点值
  static double randomDouble({bool round = false}) {
    var nextDouble = getRandom().nextDouble();
    if (round) {
      nextDouble = nextDouble.roundToDouble();
    }
    return nextDouble;
  }

  /// 生成一个非负随机整数，均匀分布在从 min（含）到max （不含）的范围内。
  // 实现说明：默认实现支持介于 min 和 (1<<32) 之间的max
  static int randomInt({int min = 0, int max = 1 << 32}) {
    var range = max - min;
    return getRandom().nextInt(range) + min;
  }

  /// 生成[len]个数的随机字节
  static Uint8List randomBytes(int len) {
    var bytes = Uint8List(len);
    nextInts(bytes, max: 1 << 8);
    return bytes;
  }
}
