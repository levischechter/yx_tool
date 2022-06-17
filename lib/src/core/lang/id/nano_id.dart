import 'dart:math';
import 'dart:typed_data';

import 'package:yx_tool/src/core/lang/math/math.dart';
import 'package:yx_tool/src/core/text/string_builder.dart';
import 'package:yx_tool/src/core/util/random_util.dart';

/// NanoId，一个小型、安全、对 URL友好的唯一字符串 ID 生成器，特点：
///
/// <ul>
///     <li>安全：它使用加密、强大的随机 API，并保证符号的正确分配</li>
///     <li>体积小：只有 258 bytes 大小（压缩后）、无依赖</li>
///     <li>紧凑：它使用比 UUID (A-Za-z0-9_~)更多的符号</li>
/// </ul>
///
/// <p>
/// 此实现的逻辑基于JavaScript的NanoId实现，见：https://github.com/ai/nanoid
class NanoId {
  ///默认随机数生成器，使用[Random.secure]确保健壮性
  static final Random _defaultNumberGenerator = Random.secure();

  /// 默认随机字母表，使用URL安全的Base64字符
  static final Uint8List _defaultAlphabet = Uint8List.fromList('_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.codeUnits);

  /// 默认长度
  static const int defaultSize = 21;

  /// 生成伪随机的NanoId字符串
  ///
  /// @param random   随机数生成器
  /// @param alphabet 随机字母表
  /// @param size     ID长度
  /// @return 伪随机的NanoId字符串
  static String randomNanoId({Random? random, Uint8List? alphabet, int size = defaultSize}) {
    random ??= _defaultNumberGenerator;

    alphabet ??= _defaultAlphabet;

    if (alphabet.isEmpty || alphabet.length >= 256) {
      throw ArgumentError('Alphabet must contain between 1 and 255 symbols.');
    }

    if (size <= 0) {
      throw ArgumentError('Size must be greater than zero.');
    }

    final mask = (2 << Math.floor(log(alphabet.length - 1) / log(2))) - 1;
    final step = Math.ceil(1.6 * mask * size / alphabet.length);

    final idBuilder = StringBuilder();

    while (true) {
      var bytes = RandomUtil.nextInts(Uint8List(step), max: 0XFF, random: random);
      for (var i = 0; i < step; i++) {
        final alphabetIndex = bytes[i] & mask;
        if (alphabetIndex < alphabet.length) {
          idBuilder.appendUint(alphabet[alphabetIndex]);
          if (idBuilder.length == size) {
            return idBuilder.toString();
          }
        }
      }
    }
  }
}
