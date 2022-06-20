import 'package:pointycastle/digests/md5.dart';
import 'package:yx_tool/src/core/extensions/string_extension.dart';
import 'package:yx_tool/src/core/test/yx_test.dart';
import 'package:yx_tool/src/core/util/digest_util.dart';

void main() {
  testExecute(
    title: 'DigestUtil.md5Hex Salt Test',
    function: () {
      var data = 'Hex Util 集合';
      var bytes = data.bytes;
      print(DigestUtil.md5Hex(bytes,
          salt: '222', position: bytes.length, repeat: 10));
    },
    execute: true,
  );

  testExecute(
    title: 'DigestUtil.md5Hex Test',
    function: () {
      var data = 'Hex Util 集合';
      var bytes = data.bytes;
      print(DigestUtil.md5Hex(bytes));
    },
    execute: true,
  );

  testExecute(
    title: 'DigestUtil.bcryptCheckpw Test',
    function: () {
      var encodedPassword = DigestUtil.bcrypt('123456');
      print(encodedPassword);
      print(DigestUtil.bcryptCheckpw('123456', encodedPassword));
    },
    execute: true,
  );

  testExecute(
    title: 'DigestUtil.sha1HexStr Test',
    function: () {
      print(DigestUtil.sha1HexStr('Hex Util 集合', toUpperCase: true));
    },
    execute: true,
  );

  testExecute(
    title: 'DigestUtil.sha224HexStr Test',
    function: () {
      print(DigestUtil.sha224HexStr('Hex Util 集合', toUpperCase: true));
    },
    execute: true,
  );

  testExecute(
    title: 'DigestUtil.sha256HexStr Test',
    function: () {
      print(DigestUtil.sha256HexStr('Hex Util 集合', toUpperCase: true));
    },
    execute: true,
  );

  testExecute(
    title: 'DigestUtil.sha384HexStr Test',
    function: () {
      print(DigestUtil.sha384HexStr('Hex Util 集合', toUpperCase: true));
    },
    execute: true,
  );

  testExecute(
    title: 'DigestUtil.sha512HexStr Test',
    function: () {
      print(DigestUtil.sha512HexStr('Hex Util 集合', toUpperCase: true));
    },
    execute: true,
  );

  testExecute(
    title: 'DigestUtil.sha3_224HexStr Test',
    function: () {
      print(DigestUtil.sha3_224HexStr('Hex Util 集合', toUpperCase: true));
    },
    execute: true,
  );

  testExecute(
    title: 'DigestUtil.sha3_256HexStr Test',
    function: () {
      print(DigestUtil.sha3_256HexStr('Hex Util 集合', toUpperCase: true));
    },
    execute: true,
  );

  testExecute(
    title: 'DigestUtil.sha3_384HexStr Test',
    function: () {
      print(DigestUtil.sha3_384HexStr('Hex Util 集合', toUpperCase: true));
    },
    execute: true,
  );

  testExecute(
    title: 'DigestUtil.sha3_512HexStr Test',
    function: () {
      print(DigestUtil.sha3_512HexStr('Hex Util 集合', toUpperCase: true));
    },
    execute: true,
  );

  testExecute(
    title: 'DigestUtil.hmac Test',
    function: () {
      print(
          DigestUtil.hmacHex(MD5Digest(), 'Hex Util 集合'.bytes, keyStr: '123'));
    },
    execute: true,
  );

  testExecute(
    title: 'DigestUtil.sm3HexStr Test',
    function: () {
      print(DigestUtil.sm3HexStr('aaaaa'));
    },
    execute: true,
  );
}
