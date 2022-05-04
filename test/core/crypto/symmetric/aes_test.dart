import 'package:yx_tool/src/core/crypto/symmetric/aes.dart';
import 'package:yx_tool/src/core/extensions/string_extension.dart';
import 'package:yx_tool/src/core/test/yx_test.dart';
import 'package:yx_tool/src/core/util/hex_util.dart';
import 'package:yx_tool/src/core/util/random_util.dart';

void main() {
  testExecute(
    title: 'AES.CBC TEST',
    function: () {
      var iv = RandomUtil.randomBytes(16);
      var key = RandomUtil.randomBytes(16);
      var aes = AES(AESMode.CBC, AESPadding.PKCS7Padding, key, iv);
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );

  testExecute(
    title: 'AES.CFB_64 TEST',
    function: () {
      var iv = RandomUtil.randomBytes(12);
      var key = RandomUtil.randomBytes(32);
      var aes = AES(AESMode.CFB_64, AESPadding.PKCS7Padding, key, iv);
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );

  testExecute(
    title: 'AES.CTR TEST',
    function: () {
      var iv = RandomUtil.randomBytes(12);
      var key = RandomUtil.randomBytes(32);
      var aes = AES(AESMode.CTR, AESPadding.NoPadding, key, iv);
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );

  testExecute(
    title: 'AES.ECB TEST',
    function: () {
      var aes = AES.withKey(AESMode.ECB, AESPadding.PKCS7Padding, HexUtil.decodeHex('0102030405060708090a0b0c0d0e0f10'));
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );

  testExecute(
    title: 'AES.OFB_64 TEST',
    function: () {
      var iv = RandomUtil.randomBytes(12);
      var key = RandomUtil.randomBytes(32);
      var aes = AES(AESMode.OFB_64, AESPadding.PKCS7Padding, key, iv);
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );

  testExecute(
    title: 'AES.OFB_64_GCTR TEST',
    function: () {
      var iv = RandomUtil.randomBytes(12);
      var key = RandomUtil.randomBytes(32);
      var aes = AES(AESMode.OFB_64_GCTR, AESPadding.PKCS7Padding, key, iv);
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );

  testExecute(
    title: 'AES.GCM TEST',
    function: () {
      var iv = RandomUtil.randomBytes(12);
      var aes = AES(AESMode.GCM, AESPadding.NoPadding, HexUtil.decodeHex('0102030405060708090a0b0c0d0e0f10'), iv);
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );

  testExecute(
    title: 'AES.IGE TEST',
    function: () {
      var iv = RandomUtil.randomBytes(32);
      var key = RandomUtil.randomBytes(32);
      var aes = AES(AESMode.IGE, AESPadding.PKCS7Padding, key, iv);
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );

  testExecute(
    title: 'AES.CCM TEST',
    function: () {
      var iv = RandomUtil.randomBytes(12);
      var key = RandomUtil.randomBytes(16);
      var aes = AES(AESMode.CCM, AESPadding.NoPadding, key, iv);
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );

  testExecute(
    title: 'AES.SIC TEST',
    function: () {
      var iv = RandomUtil.randomBytes(12);
      var key = RandomUtil.randomBytes(32);
      var aes = AES(AESMode.SIC, AESPadding.NoPadding, key, iv);
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );

}
