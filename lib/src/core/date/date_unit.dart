///日期时间单位，每个单位都是以毫秒为基数
enum DateUnit {
  ///一毫秒
  ms(1),

  ///一秒的毫秒数
  second(1000),

  ///一分钟的毫秒数
  minute(1000 * 60),

  ///一小时的毫秒数
  hour(1000 * 60 * 60),

  ///一天的毫秒数
  day(1000 * 60 * 60 * 24),

  ///一周的毫秒数
  week(1000 * 60 * 60 * 24 * 7);

  final int millis;

  const DateUnit(this.millis);
}
