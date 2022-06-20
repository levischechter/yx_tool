/// Murmur3 哈希算法实现<br>
class MurmurHash {
  static const int _c1 = 0xcc9e2d51;
  static const int _c2 = 0x1b873593;

  static const defaultSeed = 0;

  /// Ported from: https://github.com/garycourt/murmurhash-js/blob/master/murmurhash3_gc.js
  static int v3(String key, [int seed = defaultSeed]) {
    var remainder = key.length & 3;
    var bytes = key.length - remainder;
    var h1 = seed;
    var i = 0;
    int k1, h1b;
    while (i < bytes) {
      k1 = ((key.codeUnitAt(i) & 0xff)) |
          ((key.codeUnitAt(++i) & 0xff) << 8) |
          ((key.codeUnitAt(++i) & 0xff) << 16) |
          ((key.codeUnitAt(++i) & 0xff) << 24);
      ++i;
      k1 = ((((k1 & 0xffff) * _c1) + ((((k1 >>> 16) * _c1) & 0xffff) << 16))) &
          0xffffffff;
      k1 = (k1 << 15) | (k1 >>> 17);
      k1 = ((((k1 & 0xffff) * _c2) + ((((k1 >>> 16) * _c2) & 0xffff) << 16))) &
          0xffffffff;

      h1 ^= k1;
      h1 = (h1 << 13) | (h1 >>> 19);
      h1b = ((((h1 & 0xffff) * 5) + ((((h1 >>> 16) * 5) & 0xffff) << 16))) &
          0xffffffff;
      h1 = (((h1b & 0xffff) + 0x6b64) +
          ((((h1b >>> 16) + 0xe654) & 0xffff) << 16));
    }
    k1 = 0;

    switch (remainder) {
      case 3:
        k1 ^= (key.codeUnitAt(i + 2) & 0xff) << 16;
        continue case2;
      case2:
      case 2:
        k1 ^= (key.codeUnitAt(i + 1) & 0xff) << 8;
        continue case1;
      case1:
      case 1:
        k1 ^= (key.codeUnitAt(i) & 0xff);

        k1 = (((k1 & 0xffff) * _c1) + ((((k1 >>> 16) * _c1) & 0xffff) << 16)) &
            0xffffffff;
        k1 = (k1 << 15) | (k1 >>> 17);
        k1 = (((k1 & 0xffff) * _c2) + ((((k1 >>> 16) * _c2) & 0xffff) << 16)) &
            0xffffffff;
        h1 ^= k1;
    }
    h1 ^= key.length;

    h1 ^= h1 >>> 16;
    h1 = (((h1 & 0xffff) * 0x85ebca6b) +
            ((((h1 >>> 16) * 0x85ebca6b) & 0xffff) << 16)) &
        0xffffffff;
    h1 ^= h1 >>> 13;
    h1 = ((((h1 & 0xffff) * 0xc2b2ae35) +
            ((((h1 >>> 16) * 0xc2b2ae35) & 0xffff) << 16))) &
        0xffffffff;
    h1 ^= h1 >>> 16;

    return h1 >>> 0;
  }
}
