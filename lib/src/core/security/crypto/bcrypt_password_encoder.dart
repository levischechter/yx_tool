import 'dart:convert';
import 'dart:math';

import 'package:yx_tool/src/core/security/crypto/bcrypt.dart';

import 'abs_password.dart';

final bcryptPassword = BCryptPasswordEncoder();

/// Implementation of PasswordEncoder that uses the BCrypt strong hashing function. Clients
/// can optionally supply a "version" ($2a, $2b, $2y) and a "strength" (a.k.a. log rounds
/// in BCrypt) and a SecureRandom instance. The larger the strength parameter the more work
/// will have to be done (exponentially) to hash the passwords. The default value is 10.
class BCryptPasswordEncoder extends Converter<String, String> implements PasswordEncoder {

  final BCRYPT_PATTERN = RegExp(r'\$2(a|y|b)?\$(\d\d)\$[./0-9A-Za-z]{53}');

  late final int _strength;

  late final BCryptVersion _version;

  late final Random _random;

  BCryptPasswordEncoder({BCryptVersion version = BCryptVersion.$2A, int strength = -1, Random? random}) : _version = version {
    if (strength != -1 && (strength < BCrypt.MIN_LOG_ROUNDS || strength > BCrypt.MAX_LOG_ROUNDS)) {
      throw ArgumentError('Bad strength');
    }
    _strength = (strength == -1) ? 10 : strength;
    _random = random ?? Random.secure();
  }

  //
  // /// @param strength the log rounds to use, between 4 and 31
  // public BCryptPasswordEncoder(int strength) {
  // 	this(strength, null);
  // }
  //
  // /// @param version the version of bcrypt, can be 2a,2b,2y
  // public BCryptPasswordEncoder(BCryptVersion version) {
  // 	this(version, null);
  // }
  //
  // /// @param version the version of bcrypt, can be 2a,2b,2y
  // /// @param random the secure random instance to use
  // public BCryptPasswordEncoder(BCryptVersion version, SecureRandom random) {
  // 	this(version, -1, random);
  // }
  //
  // /// @param strength the log rounds to use, between 4 and 31
  // /// @param random the secure random instance to use
  // public BCryptPasswordEncoder(int strength, SecureRandom random) {
  // 	this(BCryptVersion.$2A, strength, random);
  // }
  //
  // /// @param version the version of bcrypt, can be 2a,2b,2y
  // /// @param strength the log rounds to use, between 4 and 31
  // public BCryptPasswordEncoder(BCryptVersion version, int strength) {
  // 	this(version, strength, null);
  // }
  //
  // /// @param version the version of bcrypt, can be 2a,2b,2y
  // /// @param strength the log rounds to use, between 4 and 31
  // /// @param random the secure random instance to use
  // public BCryptPasswordEncoder(BCryptVersion version, int strength, SecureRandom random) {
  // 	if (strength != -1 && (strength < BCrypt.MIN_LOG_ROUNDS || strength > BCrypt.MAX_LOG_ROUNDS)) {
  // 		throw new ArgumentError('Bad strength');
  // 	}
  // 	this._version = version;
  // 	this._strength = (strength == -1) ? 10 : strength;
  // 	this._random = random;
  // }

  @override
  String encode(String rawPassword) {
    var salt = _getSalt();
    return BCrypt.hashpwStr(rawPassword.toString(), salt);
  }

  String _getSalt() {
    return BCrypt.gensalt(_version.version, _strength, _random);
  }

  @override
  bool matches(String rawPassword, String encodedPassword) {
    if (encodedPassword.isEmpty) {
      return false;
    }
    if (!BCRYPT_PATTERN.hasMatch(encodedPassword)) {
    	return false;
    }
    return BCrypt.checkpwStr(rawPassword, encodedPassword);
  }

  @override
  bool upgradeEncoding(String encodedPassword) {
    if (encodedPassword.isEmpty) {
      return false;
    }

    if (!BCRYPT_PATTERN.hasMatch(encodedPassword)) {
      throw ArgumentError('Encoded password does not look like BCrypt: ' + encodedPassword);
    }
    var firstMatch = BCRYPT_PATTERN.firstMatch(encodedPassword);
    var strength = int.parse(firstMatch!.group(2)!);
    return strength < _strength;
  }

  @override
  String convert(String input) {
     return encode(input);
  }
}

/// Stores the default bcrypt version for use in configuration.
class BCryptVersion {
  final String version;

  const BCryptVersion(this.version);

  static const $2A = BCryptVersion(r'$2a');
  static const $2Y = BCryptVersion(r'$2y');
  static const $2B = BCryptVersion(r'$2b');
}
