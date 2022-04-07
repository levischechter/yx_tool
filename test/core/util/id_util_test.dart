import 'package:yx_tool/core/test/yx_test.dart';
import 'package:yx_tool/core/util/yx_util.dart';

void main() async {
  testExecute(
    title: 'IdUtil.uuid Test',
    function: () {
      print(IdUtil.uuid());
    },
    execute: false,
  );

  await testExecute(
    title: 'IdUtil.snowflake Test',
    function: () async {
      var snowflake = await IdUtil.snowflake(workerId: 1, datacenterId: 2);
      var nextId = snowflake.nextId();
      print(nextId);
      print(snowflake.getWorkerId(nextId));
      print(snowflake.getDataCenterId(nextId));
    },
    isAsync: true,
    execute: false,
  );

  testExecute(
    title: 'IdUtil.snowflakeSync Test',
    function: () {
      var snowflake = IdUtil.snowflakeSync(workerId: 1, datacenterId: 2);
      var nextId = snowflake.nextId();
      print(nextId);
      print(snowflake.getWorkerId(nextId));
      print(snowflake.getDataCenterId(nextId));
    },
    execute: false,
  );

  testExecute(
    title: 'IdUtil.nanoId Test',
    function: () {
      var nanoId = IdUtil.nanoId();
      print(nanoId);
    },
    execute: true,
  );
}
