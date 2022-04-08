import 'dart:typed_data';

import 'package:yx_tool/core/extensions/string_extension.dart';
import 'package:yx_tool/core/lang/hash/murmur_hash.dart';
import 'package:yx_tool/core/lang/yx_math.dart';

/// Hash算法<br>
class HashUtil {
  /// 加法hash
  ///
  /// [key]   字符串<br>
  /// [prime] 一个质数<br>
  /// 返回 hash结果
  static int additiveHash(String key, int prime) {
    var hash = key.length;
    for (var i = 0; i < key.length; i++) {
      hash += key.codeUnitAt(i);
    }
    return hash % prime;
  }

  /// 旋转hash
  ///
  /// [key]   输入字符串<br>
  /// [prime] 质数<br>
  /// 返回 hash值
  static int rotatingHash(String key, int prime) {
    int hash = key.length, i;
    for (i = 0; i < key.length; ++i) {
      hash = (hash << 4) ^ (hash >> 28) ^ key.codeUnitAt(i);
    }

    // 使用：hash = (hash ^ (hash>>10) ^ (hash>>20)) & mask;
    // 替代：hash %= prime;
    // return (hash ^ (hash>>10) ^ (hash>>20));
    return hash % prime;
  }

  /// 一次一个hash
  ///
  /// [key] 输入字符串<br>
  /// 返回 输出hash值
  static int oneByOneHash(String key) {
    int hash = 0, i;
    for (i = 0; i < key.length; ++i) {
      hash += key.codeUnitAt(i);
      hash += (hash << 10);
      hash ^= (hash >> 6);
    }
    hash += (hash << 3);
    hash ^= (hash >> 11);
    hash += (hash << 15);
    // return (hash & M_MASK);
    return hash;
  }

  /// Bernstein's hash
  ///
  /// [key] 输入字节数组<br>
  /// 返回 结果hash
  static int bernstein(String key) {
    var hash = 0;
    int i;
    for (i = 0; i < key.length; ++i) {
      hash = 33 * hash + key.codeUnitAt(i);
    }
    return hash;
  }

  /// Universal Hashing
  ///
  /// [key]  字节数组<br>
  /// [mask] 掩码<br>
  /// [tab]  tab<br>
  /// 返回 hash值
  static int universal(Uint16List key, int mask, List<int> tab) {
    var hash = key.length;
    var len = key.length;
    for (var i = 0; i < (len << 3); i += 8) {
      var k = key[i >> 3];
      if ((k & 0x01) == 0) {
        hash ^= tab[i];
      }
      if ((k & 0x02) == 0) {
        hash ^= tab[i + 1];
      }
      if ((k & 0x04) == 0) {
        hash ^= tab[i + 2];
      }
      if ((k & 0x08) == 0) {
        hash ^= tab[i + 3];
      }
      if ((k & 0x10) == 0) {
        hash ^= tab[i + 4];
      }
      if ((k & 0x20) == 0) {
        hash ^= tab[i + 5];
      }
      if ((k & 0x40) == 0) {
        hash ^= tab[i + 6];
      }
      if ((k & 0x80) == 0) {
        hash ^= tab[i + 7];
      }
    }
    return (hash & mask);
  }

  /// Zobrist Hashing
  ///
  /// [key]  字节数组<br>
  /// [mask] 掩码<br>
  /// [tab]  tab<br>
  /// 返回 hash值
  static int zobrist(Uint16List key, int mask, List<List<int>> tab) {
    var hash = key.length;
    for (var i = 0; i < key.length; ++i) {
      hash ^= tab[i][key[i]];
    }
    return (hash & mask);
  }

  /// 改进的32位FNV算法1
  ///
  /// [data] 数组<br>
  /// 返回 hash结果
  static int fnvHash(Uint8List data) {
    const p = 16777619;
    var hash = 2166136261;
    for (var b in data) {
      hash = (hash ^ b) * p;
    }
    hash += hash << 13;
    hash ^= hash >> 7;
    hash += hash << 3;
    hash ^= hash >> 17;
    hash += hash << 5;
    return Math.abs(hash);
  }

  /// 改进的32位FNV算法1
  ///
  /// [data] 字符串
  /// 返回 hash结果
  static int fnvHashStr(String data) {
    const p = 16777619;
    var hash = 2166136261;
    for (var i = 0; i < data.length; i++) {
      hash = (hash ^ data.codeUnitAt(i)) * p;
    }
    hash += hash << 13;
    hash ^= hash >> 7;
    hash += hash << 3;
    hash ^= hash >> 17;
    hash += hash << 5;
    return Math.abs(hash);
  }

  /// Thomas Wang的算法，整数hash
  ///
  /// [key] 整数
  /// 返回 hash值
  static int intHash(int key) {
    key += ~(key << 15);
    key ^= (key >>> 10);
    key += (key << 3);
    key ^= (key >>> 6);
    key += ~(key << 11);
    key ^= (key >>> 16);
    return key;
  }

  /// RS算法hash
  ///
  /// [str] 字符串
  /// 返回 hash值
  static int rsHash(String str) {
    var b = 378551;
    var a = 63689;
    var hash = 0;

    for (var i = 0; i < str.length; i++) {
      hash = hash * a + str.codeUnitAt(i);
      a = a * b;
    }

    return hash & 0x7FFFFFFF;
  }

  /// JS算法
  ///
  /// [str] 字符串
  /// 返回 hash值
  static int jsHash(String str) {
    var hash = 1315423911;

    for (var i = 0; i < str.length; i++) {
      hash ^= ((hash << 5) + str.codeUnitAt(i) + (hash >> 2));
    }

    return Math.abs(hash) & 0x7FFFFFFF;
  }

  /// PJW算法
  ///
  /// [str] 字符串
  /// 返回 hash值
  static int pjwHash(String str) {
    var bitsInUnsignedInt = 32;
    var threeQuarters = (bitsInUnsignedInt * 3) ~/ 4;
    var oneEighth = bitsInUnsignedInt ~/ 8;
    var highBits = 0xFFFFFFFF << (bitsInUnsignedInt - oneEighth);
    var hash = 0;
    int test;

    for (var i = 0; i < str.length; i++) {
      hash = (hash << oneEighth) + str.codeUnitAt(i);

      if ((test = hash & highBits) != 0) {
        hash = ((hash ^ (test >> threeQuarters)) & (~highBits));
      }
    }

    return hash & 0x7FFFFFFF;
  }

  /// ELF算法
  ///
  /// [str] 字符串
  /// 返回 hash值
  static int elfHash(String str) {
    var hash = 0;
    int x;

    for (var i = 0; i < str.length; i++) {
      hash = (hash << 4) + str.codeUnitAt(i);
      if ((x = (hash & 0xF0000000)) != 0) {
        hash ^= (x >> 24);
        hash &= ~x;
      }
    }

    return hash & 0x7FFFFFFF;
  }

  /// BKDR算法
  ///
  /// str 字符串
  /// 返回 hash值
  static int bkdrHash(String str) {
    var seed = 131; // 31 131 1313 13131 131313 etc..
    var hash = 0;

    for (var i = 0; i < str.length; i++) {
      hash = (hash * seed) + str.codeUnitAt(i);
    }

    return hash & 0x7FFFFFFF;
  }

  /// SDBM算法
  ///
  /// [str] 字符串
  /// 返回 hash值
  static int sdbmHash(String str) {
    var hash = 0;

    for (var i = 0; i < str.length; i++) {
      hash = str.codeUnitAt(i) + (hash << 6) + (hash << 16) - hash;
    }

    return hash & 0x7FFFFFFF;
  }

  /// DJB算法
  ///
  /// [str] 字符串
  /// 返回 hash值
  static int djbHash(String str) {
    var hash = 5381;

    for (var i = 0; i < str.length; i++) {
      hash = ((hash << 5) + hash) + str.codeUnitAt(i);
    }

    return hash & 0x7FFFFFFF;
  }

  /// DEK算法
  ///
  /// [str] 字符串
  /// 返回 hash值
  static int dekHash(String str) {
    var hash = str.length;

    for (var i = 0; i < str.length; i++) {
      hash = ((hash << 5) ^ (hash >> 27)) ^ str.codeUnitAt(i);
    }

    return hash & 0x7FFFFFFF;
  }

  /// AP算法
  ///
  /// [str] 字符串
  /// 返回 hash值
  static int apHash(String str) {
    var hash = 0;

    for (var i = 0; i < str.length; i++) {
      hash ^= ((i & 1) == 0) ? ((hash << 7) ^ str.codeUnitAt(i) ^ (hash >> 3)) : (~((hash << 11) ^ str.codeUnitAt(i) ^ (hash >> 5)));
    }

    // return (hash & 0x7FFFFFFF);
    return hash;
  }

  /// TianL Hash算法
  ///
  /// [str] 字符串
  /// 返回 Hash值
  static int tianlHash(String str) {
    late int hash;

    var iLength = str.length;
    if (iLength == 0) {
      return 0;
    }

    if (iLength <= 256) {
      hash = 16777216 * (iLength - 1);
    } else {
      hash = 4278190080;
    }

    late int i;

    late int ucChar;
    if (iLength <= 96) {
      for (i = 1; i <= iLength; i++) {
        ucChar = str.codeUnitAt(i - 1);
        if (ucChar <= 'Z'.first && ucChar >= 'A'.first) {
          ucChar = (ucChar + 32);
        }
        hash += (3 * i * ucChar * ucChar + 5 * i * ucChar + 7 * i + 11 * ucChar) % 16777216;
      }
    } else {
      for (i = 1; i <= 96; i++) {
        ucChar = str.codeUnitAt(i + iLength - 96 - 1);
        if (ucChar <= 'Z'.first && ucChar >= 'A'.first) {
          ucChar = (ucChar + 32);
        }
        hash += (3 * i * ucChar * ucChar + 5 * i * ucChar + 7 * i + 11 * ucChar) % 16777216;
      }
    }
    if (hash < 0) {
      hash *= -1;
    }
    return hash;
  }

  /// hash默认算法
  ///
  /// [str] 字符串
  /// 返回 hash值
  static int defaultHash(String str) {
    var h = 0;
    var off = 0;
    var len = str.length;
    for (var i = 0; i < len; i++) {
      h = 31 * h + str.codeUnitAt(off++);
    }
    return h;
  }

  /// 混合hash算法，输出64位的值
  ///
  /// [str] 字符串
  /// 返回 hash值
  static int mixHash(String str) {
    var hash = str.hashCode;
    hash <<= 32;
    hash |= fnvHashStr(str);
    return hash;
  }

  /// 根据对象的内存地址生成相应的Hash值
  ///
  /// [obj] 对象
  /// 返回 hash值
  static int identityHashCode(Object obj) {
    return identityHashCode(obj);
  }

  /// MurmurHash算法32-bit实现
  ///
  /// data 数据
  /// 返回 hash值
  static int murmur(String key, [int seed = 0]) {
    return MurmurHash.v3(key, seed);
  }

  /// HF Hash算法
  ///
  /// [data] 字符串<br>
  /// 返回 hash结果
  static int hfHash(String data) {
    var length = data.length;
    var hash = 0;

    for (var i = 0; i < length; i++) {
      hash += data.codeUnitAt(i) * 3 * i;
    }

    if (hash < 0) {
      hash = -hash;
    }

    return hash;
  }

  /// HFIP Hash算法
  ///
  /// [data] 字符串<br>
  /// 返回 hash结果
  static int hfIpHash(String data) {
    var length = data.length;
    var hash = 0;
    for (var i = 0; i < length; i++) {
      hash += data.codeUnitAt(i % 4) ^ data.codeUnitAt(i);
    }
    return hash;
  }
}
