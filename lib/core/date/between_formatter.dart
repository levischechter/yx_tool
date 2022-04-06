import 'date_unit.dart';

///格式化等级
class Level {
  final String name;
  final int index;

  const Level._(this.name, this.index);

  static const Level DAY = Level._('天', 0);
  static const Level HOUR = Level._('小时', 1);
  static const Level MINUTE = Level._('分', 2);
  static const Level SECOND = Level._('秒', 3);
  static const Level MILLISECOND = Level._('毫秒', 4);
}

/// 时长格式化器，用于格式化输出两个日期相差的时长<br>
/// 根据{@link Level}不同，调用{@link #format()}方法后返回类似于：
/// <ul>
///    <li>XX小时XX分XX秒</li>
///    <li>XX天XX小时</li>
///    <li>XX月XX天XX小时</li>
/// </ul>
class BetweenFormatter {
  /// 时长毫秒数
  int betweenMs;

  /// 格式化级别，按照天、小时、分、秒、毫秒分为5个等级，根据传入等级，格式化到相应级别
  Level level;

  /// 格式化级别的最大个数
  final int levelMaxCount;

  BetweenFormatter({
    required this.betweenMs,
    required this.level,
    this.levelMaxCount = 0,
  });

  /// 格式化日期间隔输出<br>
  String format() {
    final sb = StringBuffer();
    if (betweenMs > 0) {
      var day = betweenMs ~/ DateUnit.DAY.millis;
      var hour = betweenMs ~/ DateUnit.HOUR.millis - day * 24;
      var minute = betweenMs ~/ DateUnit.MINUTE.millis - day * 24 * 60 - hour * 60;

      final BetweenOfSecond = ((day * 24 + hour) * 60 + minute) * 60;
      var second = betweenMs ~/ DateUnit.SECOND.millis - BetweenOfSecond;
      var millisecond = betweenMs - (BetweenOfSecond + second) * 1000;

      final level = this.level.index;
      var levelCount = 0;

      if (_isLevelCountValid(levelCount) && 0 != day && level >= Level.DAY.index) {
        sb.writeAll([day, Level.DAY.name]);
        levelCount++;
      }
      if (_isLevelCountValid(levelCount) && 0 != hour && level >= Level.HOUR.index) {
        sb.writeAll([hour, Level.HOUR.name]);
        levelCount++;
      }
      if (_isLevelCountValid(levelCount) && 0 != minute && level >= Level.MINUTE.index) {
        sb.writeAll([minute, Level.MINUTE.name]);
        levelCount++;
      }
      if (_isLevelCountValid(levelCount) && 0 != second && level >= Level.SECOND.index) {
        sb.writeAll([second, Level.SECOND.name]);
        levelCount++;
      }
      if (_isLevelCountValid(levelCount) && 0 != millisecond && level >= Level.MILLISECOND.index) {
        sb.writeAll([millisecond, Level.MILLISECOND.name]);
        // levelCount++;
      }
    }

    if (sb.isEmpty) {
      sb.writeAll([0, level.name]);
    }

    return sb.toString();
  }

  /// 获得 时长毫秒数
  ///
  /// return 时长毫秒数
  int getBetweenMs() {
    return betweenMs;
  }

  /// 设置 时长毫秒数
  ///
  /// [betweenMs] 时长毫秒数
  void setBetweenMs(int betweenMs) {
    this.betweenMs = betweenMs;
  }

  /// 获得 格式化级别
  ///
  /// 格式化级别
  Level getLevel() {
    return level;
  }

  /// 设置格式化级别
  ///
  /// [level] 格式化级别
  void setLevel(Level level) {
    this.level = level;
  }

  @override
  String toString() {
    return format();
  }

  /// 等级数量是否有效<br>
  /// 有效的定义是：levelMaxCount大于0（被设置），当前等级数量没有超过这个最大值
  ///
  /// [levelCount] 登记数量
  bool _isLevelCountValid(int levelCount) {
    return levelMaxCount <= 0 || levelCount < levelMaxCount;
  }
}