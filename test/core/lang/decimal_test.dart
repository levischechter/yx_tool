import 'package:yx_tool/src/core/lang/math/decimal.dart';
import 'package:yx_tool/src/core/test/yx_test.dart';

void main() {
  testExecute(
    title: 'Decimal Test',
    function: () {
      var d = Decimal.parse("1.23");
      print(d);
      print(d += Decimal.fromDouble(3.21));
      // print(d *= Decimal.fromBigInt(BigInt.from(3)));
      print(d /= Decimal.fromInt(3));
      print(d -= Decimal.fromInt(3));
      print(d %= Decimal.fromInt(3));
      print(d ~/= Decimal.fromInt(3));
    },
    execute: true,
  );
}