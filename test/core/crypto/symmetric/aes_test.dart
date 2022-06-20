import 'package:yx_tool/src/core/crypto/symmetric/aes.dart';
import 'package:yx_tool/src/core/test/yx_test.dart';
import 'package:yx_tool/src/core/util/hex_util.dart';
import 'package:yx_tool/src/core/util/random_util.dart';

void main() {
  testExecute(
    title: 'AES.CBC TEST',
    function: () {
      var iv = RandomUtil.randomUint8s(len: 16);
      var key = RandomUtil.randomUint8s(len: 16);
      var aes = AES(AESMode.cbc, AESPadding.pkcs7Padding, key, iv);
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );

  testExecute(
    title: 'AES.CFB_64 TEST',
    function: () {
      var iv = RandomUtil.randomUint8s(len: 12);
      var key = RandomUtil.randomUint8s(len: 32);
      var aes = AES(AESMode.cfb_64, AESPadding.pkcs7Padding, key, iv);
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );

  testExecute(
    title: 'AES.CTR TEST',
    function: () {
      var iv = RandomUtil.randomUint8s(len: 12);
      var key = RandomUtil.randomUint8s(len: 32);
      var aes = AES(AESMode.ctr, AESPadding.noPadding, key, iv);
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );

  testExecute(
    title: 'AES.ECB TEST',
    function: () {
      var aes = AES.withKey(AESMode.ecb, AESPadding.pkcs7Padding,
          HexUtil.decodeHex('0102030405060708090a0b0c0d0e0f10'));
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );

  testExecute(
    title: 'AES.OFB_64 TEST',
    function: () {
      var iv = RandomUtil.randomUint8s(len: 12);
      var key = RandomUtil.randomUint8s(len: 32);
      var aes = AES(AESMode.ofb64, AESPadding.pkcs7Padding, key, iv);
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );

  testExecute(
    title: 'AES.OFB_64_GCTR TEST',
    function: () {
      var iv = RandomUtil.randomUint8s(len: 12);
      var key = RandomUtil.randomUint8s(len: 32);
      var aes = AES(AESMode.ofb64Gctr, AESPadding.pkcs7Padding, key, iv);
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );

  testExecute(
    title: 'AES.GCM TEST',
    function: () {
      var iv = RandomUtil.randomUint8s(len: 12);
      var aes = AES(AESMode.gcm, AESPadding.noPadding,
          HexUtil.decodeHex('0102030405060708090a0b0c0d0e0f10'), iv);
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );

  testExecute(
    title: 'AES.IGE TEST',
    function: () {
      var iv = RandomUtil.randomUint8s(len: 32);
      var key = RandomUtil.randomUint8s(len: 32);
      var aes = AES(AESMode.ige, AESPadding.pkcs7Padding, key, iv);
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );

  testExecute(
    title: 'AES.CCM TEST',
    function: () {
      var iv = RandomUtil.randomUint8s(len: 12);
      var key = RandomUtil.randomUint8s(len: 16);
      var aes = AES(AESMode.ccm, AESPadding.noPadding, key, iv);
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );

  testExecute(
    title: 'AES.SIC TEST',
    function: () {
      var iv = RandomUtil.randomUint8s(len: 12);
      var key = RandomUtil.randomUint8s(len: 32);
      var aes = AES(AESMode.sic, AESPadding.noPadding, key, iv);
      var encryptHex = aes.encryptHex(HexUtil.decodeHex('16c5'));
      print(encryptHex);
      print(aes.decryptHex(HexUtil.decodeHex(encryptHex)));
    },
    execute: true,
  );
}
