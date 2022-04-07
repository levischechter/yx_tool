import 'package:yx_tool/core/test/yx_test.dart';
import 'package:yx_tool/core/util/net_util.dart';

void main() {
  testExecute(
    title: 'NetUtil.getLocalHost Test',
    function: () async {
      var list = await NetUtil.lookup();
      var address = list[0];
      print(address);
      print(address.rawAddress);
    },
    execute: true,
  );
}
