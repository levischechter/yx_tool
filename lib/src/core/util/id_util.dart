import 'dart:io';

import 'package:yx_tool/src/core/lang/id/nano_id.dart';
import 'package:yx_tool/src/core/lang/snowflake.dart';
import 'package:yx_tool/src/core/lang/uuid.dart';
import 'package:yx_tool/src/core/text/string_builder.dart';
import 'package:yx_tool/src/core/util/net_util.dart';

/// ID生成器工具类
class IdUtil {
  /// 生成uuid
  static String uuid([bool isSecure = true]) {
    return UUID.randomUUID().toString();
  }

  /// 获取数据中心ID<br>
  /// 数据中心ID依赖于本地网卡MAC地址。
  /// <p>
  /// 此算法来自于mybatis-plus#Sequence
  /// </p>
  static Future<int> getDataCenterId(int maxDatacenterId) async {
    if (maxDatacenterId <= 0) {
      throw AssertionError('maxDatacenterId must be > 0');
    }
    var id = 1;
    List<int>? mac;
    var list = await NetUtil.lookup();
    if (list.isNotEmpty) {
      var address = list[0];
      mac = address.rawAddress;
    }
    if (null != mac) {
      id = ((0x000000FF & mac[mac.length - 2]) | (0x0000FF00 & ((mac[mac.length - 1]) << 8))) >> 6;
      id = id % (maxDatacenterId + 1);
    }
    return id;
  }

  /// 获取机器ID，使用进程ID配合数据中心ID生成<br>
  /// 机器依赖于本进程ID或进程名的Hash值。
  static int getWorkerId(int datacenterId, int maxWorkerId) {
    final mpid = StringBuilder();
    mpid.append(datacenterId);
    mpid.append(pid);
    /*
		 * MAC + PID 的 hashcode 获取16个低位
		 */
    return (mpid.toString().hashCode & 0xffff) % (maxWorkerId + 1);
  }

  /// 获取雪花算法
  static Future<Snowflake> snowflake({int? workerId, int? datacenterId}) async {
    return await Snowflake.getInstance(workerId: workerId, dataCenterId: datacenterId);
  }

  /// 获取雪花算法
  static Snowflake snowflakeSync({int? workerId, required int datacenterId}) {
    return Snowflake.getInstanceSync(workerId: workerId, dataCenterId: datacenterId);
  }

  /// 获取随机NanoId
  static String nanoId() {
    return NanoId.randomNanoId();
  }
}
