import 'dart:async';
import 'dart:io';

import 'package:yx_tool/src/core/util/str_util.dart';

class NetUtil {
  NetUtil._();

  /// 任意ip4地址
  static InternetAddress getLocalHost() {
    return InternetAddress.anyIPv4;
  }

  /// networkInterface
  static FutureOr<List<int>?> networkInterface() async {
    var list = await NetworkInterface.list(type: getLocalHost().type);
    if (list.isNotEmpty) {
      return StrUtil.encode(list[0].name);
    }
    return null;
  }

  /// 环回地址
  static InternetAddress loopbackIPv4() {
    return InternetAddress.loopbackIPv4;
  }

  /// 查找主机地址
  static FutureOr<List<InternetAddress>> lookup(
      [String? host,
      InternetAddressType type = InternetAddressType.IPv4]) async {
    return await InternetAddress.lookup(host ?? '', type: type);
  }
}
