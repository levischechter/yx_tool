import 'dart:typed_data';

import 'package:yx_tool/src/core/io/checksum/checksum.dart';

abstract class CRCChecksum extends Checksum {
  late int wCRCin;

  CRCChecksum() {
    reset();
  }

  @override
  void update(Uint8List b, [int off = 0, int? len]) {
    len ??= b.length;
    for (var i = off; i < off + len; i++) {
      updateInt(b[i]);
    }
  }

  @override
  void reset() {
    wCRCin = 0;
  }
}