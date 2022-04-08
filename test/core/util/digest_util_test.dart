import 'package:crypto/crypto.dart';
import 'package:yx_tool/src/core/extensions/string_extension.dart';
import 'package:yx_tool/src/core/test/yx_test.dart';
import 'package:yx_tool/src/core/util/digest_util.dart';

void main() {
  testExecute(
    title: 'DigestUtil.md5HexStr Test',
    function: () {
      var data = 'Hex Util 集合';
      var bytes = data.bytes;
      print(DigestUtil.md5Hex(bytes,salt: '222',position: bytes.length,repeat: 10));
    },
    execute: true,
  );

  testExecute(
    title: 'DigestUtil.sha1HexStr Test',
    function: () {
      print(DigestUtil.sha1HexStr('Hex Util 集合', toUpperCase: true));
    },
    execute: false,
  );

  testExecute(
    title: 'DigestUtil.sha224HexStr Test',
    function: () {
      print(DigestUtil.sha224HexStr('Hex Util 集合', toUpperCase: true));
    },
    execute: false,
  );

  testExecute(
    title: 'DigestUtil.sha256HexStr Test',
    function: () {
      print(DigestUtil.sha256HexStr('Hex Util 集合', toUpperCase: true));
    },
    execute: false,
  );

  testExecute(
    title: 'DigestUtil.sha384HexStr Test',
    function: () {
      print(DigestUtil.sha384HexStr('Hex Util 集合', toUpperCase: true));
    },
    execute: false,
  );

  testExecute(
    title: 'DigestUtil.sha512HexStr Test',
    function: () {
      print(DigestUtil.sha512HexStr('Hex Util 集合', toUpperCase: true));
    },
    execute: false,
  );

  testExecute(
    title: 'DigestUtil.sha512224HexStr Test',
    function: () {
      print(DigestUtil.sha512224HexStr('Hex Util 集合', toUpperCase: true));
    },
    execute: false,
  );

  testExecute(
    title: 'DigestUtil.sha512256HexStr Test',
    function: () {
      print(DigestUtil.sha512256HexStr('Hex Util 集合', toUpperCase: true));
    },
    execute: false,
  );

  testExecute(
    title: 'DigestUtil.sha512256HexStr Test',
    function: () {
      var hmac = DigestUtil.hmac(md5, [123]);
      print(hmac.convert('Hex Util 集合'.bytes));
    },
    execute: false,
  );
}
