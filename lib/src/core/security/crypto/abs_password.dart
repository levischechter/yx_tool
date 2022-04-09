import 'dart:typed_data';

import 'package:yx_tool/src/core/util/int_util.dart';

/// Service interface for encoding passwords.
///
/// The preferred implementation is [BCryptPasswordEncoder].
abstract class PasswordEncoder {
  /// Encode the raw password. Generally, a good encoding algorithm applies a SHA-1 or
  /// greater hash combined with an 8-byte or greater randomly generated salt.
  String encode(String rawPassword);

  /// Verify the encoded password obtained from storage matches the submitted raw
  /// password after it too is encoded. Returns true if the passwords match, false if
  /// they do not. The stored password itself is never decoded.
  /// @param rawPassword the raw password to encode and match
  /// @param encodedPassword the encoded password from storage to compare with
  /// @return true if the raw password, after encoding, matches the encoded password from
  /// storage
  bool matches(String rawPassword, String encodedPassword);

  /// Returns true if the encoded password should be encoded again for better security,
  /// else false. The default implementation always returns false.
  /// @param encodedPassword the encoded password to check
  /// @return true if the encoded password should be encoded again for better security,
  /// else false.
  bool upgradeEncoding(String encodedPassword) {
    return false;
  }

  /// Compares two digests for equality. Two digests are equal if they have
  /// the same length and all bytes at corresponding positions are equal.
  ///
  /// @implNote
  /// All bytes in {@code digesta} are examined to determine equality.
  /// The calculation time depends only on the length of {@code digesta}.
  /// It does not depend on the length of {@code digestb} or the contents
  /// of {@code digesta} and {@code digestb}.
  ///
  /// @param digesta one of the digests to compare.
  ///
  /// @param digestb the other digest to compare.
  ///
  /// @return true if the digests are equal, false otherwise.
  static bool isEqual(Int8List digesta, Int8List digestb) {
    if (digesta == digestb) return true;

    var lenA = digesta.length;
    var lenB = digestb.length;

    if (lenB == 0) {
      return lenA == 0;
    }

    var result = 0;
    result |= lenA - lenB;

    // time-constant comparison
    for (var i = 0; i < lenA; i++) {
      // If i >= lenB, indexB is 0; otherwise, i.
      var indexB = IntUtil.toUInt32(((i - lenB) >>> 31) * i);
      result |= digesta[i] ^ digestb[indexB];
    }
    return result == 0;
  }
}
