class DateUnit {
  final int millis;

  const DateUnit._(this.millis);

  ///一毫秒
  static const DateUnit MS = DateUnit._(1);

  ///一秒的毫秒数
  static const DateUnit SECOND = DateUnit._(1000);

  ///一分钟的毫秒数
  static const DateUnit MINUTE = DateUnit._(1000 * 60);

  ///一小时的毫秒数
  static const DateUnit HOUR = DateUnit._(1000 * 60 * 60);

  ///一天的毫秒数
  static const DateUnit DAY = DateUnit._(1000 * 60 * 60 * 24);

  ///一周的毫秒数
  static const DateUnit WEEK = DateUnit._(1000 * 60 * 60 * 24 * 7);

  DateUnit operator *(int num) {
    return DateUnit._(millis * num);
  }
}
