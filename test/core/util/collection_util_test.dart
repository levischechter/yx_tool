import 'package:yx_tool/src/core/test/yx_test.dart';
import 'package:yx_tool/src/core/util/collection_util.dart';

void main() {
  testExecute(
    title: 'CollectionUtil.reverse Test',
    function: () {
      var list = [1, 2, 3, 4, 5, 6];
      CollectionUtil.reverse(list);
      print(list);
    },
    execute: true,
  );
}
