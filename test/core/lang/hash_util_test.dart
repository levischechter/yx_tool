import 'package:yx_tool/core/test/yx_test.dart';
import 'package:yx_tool/core/util/hash_util.dart';

void main() {
  testExecute(
    title: 'CollectionUtil.reverse Test',
    function: () {
      var s='12345';
      var murmur32 = HashUtil.hfIpHash(s);
      print(murmur32);
    },
    execute: true,
  );
}