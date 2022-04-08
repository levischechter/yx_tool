import 'dart:typed_data';

import 'package:yx_tool/src/core/text/string_builder.dart';
import 'package:yx_tool/src/core/util/random_util.dart';

/// 提供通用唯一识别码（universally unique identifier）（UUID）实现，UUID表示一个128位的值。<br>
/// <p>
/// 这些通用标识符具有不同的变体。此类的方法用于操作 Leach-Salz 变体，不过构造方法允许创建任何 UUID 变体（将在下面进行描述）。
/// <p>
/// 变体 2 (Leach-Salz) UUID 的布局如下： int 型数据的最高有效位由以下无符号字段组成：
///
/// ```dart
/// 0xFFFFFFFF00000000 time_low
/// 0x00000000FFFF0000 time_mid
/// 0x000000000000F000 version
/// 0x0000000000000FFF time_hi
/// ```
/// <p>
/// int 型数据的最低有效位由以下无符号字段组成：
///
/// ```dart
/// 0xC000000000000000 variant
/// 0x3FFF000000000000 clock_seq
/// 0x0000FFFFFFFFFFFF node
/// ```
///
/// <p>
/// variant 字段包含一个表示 UUID 布局的值。以上描述的位布局仅在 UUID 的 variant 值为 2（表示 Leach-Salz 变体）时才有效。 *
/// <p>
/// version 字段保存描述此 UUID 类型的值。有 4 种不同的基本 UUID 类型：基于时间的 UUID、DCE 安全 UUID、基于名称的 UUID 和随机生成的 UUID。<br>
/// 这些类型的 version 值分别为 1、2、3 和 4。
class UUID implements Comparable<UUID> {
  /// 此UUID的最高64有效位
  late final int mostSigBits;

  /// 此UUID的最低64有效位
  late final int leastSigBits;

  UUID(List<int> ints) {
    var msb = 0;
    var lsb = 0;
    if (ints.length != 16) {
      throw AssertionError('data must be 16 bytes in length');
    }
    for (var i = 0; i < 8; i++) {
      msb = (msb << 8) | (ints[i] & 0xff);
    }
    for (var i = 8; i < 16; i++) {
      lsb = (lsb << 8) | (ints[i] & 0xff);
    }
    mostSigBits = msb;
    leastSigBits = lsb;
  }

  /// 使用指定的数据构造新的 UUID。
  UUID.bits(this.mostSigBits, this.leastSigBits);

  /// 获取类型 4（伪随机生成的）UUID 的静态工厂。 使用加密的强伪随机数生成器生成该 UUID。
  ///
  /// [isSecure] 是否使用[SecureRandom]如果是可以获得更安全的随机码，否则可以得到更好的性能
  static UUID randomUUID([bool isSecure = true]) {
    var randomList = RandomUtil.nextInts(Uint8List(16), isSecure: true, max: 0xFF);
    randomList[6] &= 0x0f; /* clear version        */
    randomList[6] |= 0x40; /* set to version 4     */
    randomList[8] &= 0x3f; /* clear variant        */
    randomList[8] |= 0x80; /* set to IETF variant  */

    return UUID(randomList);
  }

  /// 与此 {@code UUID} 相关联的版本号. 版本号描述此 {@code UUID} 是如何生成的。
  /// <p>
  /// 版本号具有以下含意:
  /// ```dart
  /// 1 基于时间的 UUID
  /// 2 DCE 安全 UUID
  /// 3 基于名称的 UUID
  /// 4 随机生成的 UUID
  /// ```
  int get version => (mostSigBits >> 12) & 0x0f;

  /// 与此 {@code UUID} 相关联的变体号。变体号描述 {@code UUID} 的布局。
  /// <p>
  /// 变体号具有以下含意：
  /// ```dart
  /// 0 为 NCS 向后兼容保留
  /// 2 <a href="http://www.ietf.org/rfc/rfc4122.txt">IETF&nbsp;RFC&nbsp;4122</a>(Leach-Salz), 用于此类
  /// 6 保留，微软向后兼容
  /// 7 保留供以后定义使用
  /// ```
  int get variant => (leastSigBits >>> (64 - (leastSigBits >>> 62))) & (leastSigBits >> 63);

  int get timestamp {
    _checkTimeBase();
    return (mostSigBits & 0x0FFF) << 48 //
        |
        ((mostSigBits >> 16) & 0x0FFFF) << 32 //
        |
        mostSigBits >>> 32;
  }

  /// 与此 UUID 相关联的时钟序列值。
  ///
  /// <p>
  /// 14 位的时钟序列值根据此 UUID 的 clock_seq 字段构造。clock_seq 字段用于保证在基于时间的 UUID 中的时间唯一性。
  /// <p>
  /// {@code clockSequence} 值仅在基于时间的 UUID（其 version 类型为 1）中才有意义。 如果此 UUID 不是基于时间的 UUID，则此方法抛出 UnsupportedOperationException。
  int get clockSequence {
    _checkTimeBase();
    return (leastSigBits & 0x3FFF000000000000) >>> 48;
  }

  /// 与此 UUID 相关的节点值。
  ///
  /// <p>
  /// 48 位的节点值根据此 UUID 的 node 字段构造。此字段旨在用于保存机器的 IEEE 802 地址，该地址用于生成此 UUID 以保证空间唯一性。
  /// <p>
  /// 节点值仅在基于时间的 UUID（其 version 类型为 1）中才有意义。<br>
  /// 如果此 UUID 不是基于时间的 UUID，则此方法抛出 UnsupportedOperationException。
  int get node {
    _checkTimeBase();
    return leastSigBits & 0x0000FFFFFFFFFFFF;
  }

  /// 返回此{@code UUID} 的字符串表现形式。
  ///
  /// <p>
  /// UUID 的字符串表示形式由此 BNF 描述：
  ///
  /// ```dart
  /// UUID                   = time_low-time_mid-time_high_and_version-variant_and_sequence-node
  /// time_low               = 4* hexOctet
  /// time_mid               = 2* hexOctet
  /// time_high_and_version  = 2* hexOctet
  /// variant_and_sequence   = 2* hexOctet
  /// node                   = 6* hexOctet
  /// hexOctet               = hexDigit hexDigit
  /// hexDigit               = [0-9a-fA-F]
  /// ```
  @override
  String toString() {
    var builder = StringBuilder.capacity(36);
    // time_low
    builder.append(_digits(mostSigBits >> 32, 8));
    builder.append('-');
    // time_mid
    builder.append(_digits(mostSigBits >> 16, 4));
    builder.append('-');
    // time_high_and_version
    builder.append(_digits(mostSigBits, 4));
    builder.append('-');
    // variant_and_sequence
    builder.append(_digits(leastSigBits >> 48, 4));
    builder.append('-');
    // node
    builder.append(_digits(leastSigBits, 12));

    return builder.toString();
  }

  /// 返回指定数字对应的hex值
  ///
  /// @param val    值
  /// @param digits 位
  /// @return 值
  static String _digits(int val, int digits) {
    var hi = 1 << (digits * 4);
    return (hi | (val & (hi - 1))).toRadixString(16).substring(1);
  }

  void _checkTimeBase() {
    if (version != 1) {
      throw UnsupportedError('Not a time-based UUID');
    }
  }

  @override
  int compareTo(UUID val) {
    // The ordering is intentionally set up so that the UUIDs
    // can simply be numerically compared as two numbers
    var compare = mostSigBits.compareTo(val.mostSigBits);
    if (0 == compare) {
      compare = leastSigBits.compareTo(val.leastSigBits);
    }
    return compare;
  }
}
