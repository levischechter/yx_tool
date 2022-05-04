import 'dart:typed_data';

import 'package:yx_tool/src/core/crypto/symmetric/aead_chacha20_poly1305.dart';
import 'package:yx_tool/src/core/test/yx_test.dart';
import 'package:yx_tool/src/core/util/hex_util.dart';

void main() {
  testExecute(
    title: 'AEADChaCha20Poly1305',
    function: () {
      var key = Uint8List.fromList([22, 72, 33, -4, 82, 11, 4, 51, -100, 10, -101, 2, 24, -10, -77, -5, 77, -24, -70, -64, -87, 59, -2, -40, 96, -83, -50, -14, 12, 89, 99, -89]);
      var iv = Uint8List.fromList([57, -7, 84, 105, -30, -28, 90, 47, 68, -18, 40, 56]);
      print(key);
      print(iv);
      var chaCha20 = AEADChaCha20Poly1305.withIV(key, iv);
      var encode1 = chaCha20.encryptStr('test中文');
      print(HexUtil.encodeHex(encode1));
      var encode2 = chaCha20.encryptStr('test中文111');
      print(HexUtil.encodeHex(encode2));
      print(chaCha20.decryptStr(encode1));
      print(chaCha20.decryptStr(encode2));
    },
    execute: true,
  );
}