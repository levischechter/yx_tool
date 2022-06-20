import 'date_unit.dart';

///格式化等级
enum Level {
  /// 天
  day('天'),

  /// 小时
  hour('小时'),

  /// 分
  minute('分'),

  /// 秒
  second('秒'),

  /// 毫秒
  millisecond('毫秒');

  /// 单位名称
  final String name;

  const Level(this.name);
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
      var day = betweenMs ~/ DateUnit.day.millis;
      var hour = betweenMs ~/ DateUnit.hour.millis - day * 24;
      var minute =
          betweenMs ~/ DateUnit.minute.millis - day * 24 * 60 - hour * 60;

      final betweenOfSecond = ((day * 24 + hour) * 60 + minute) * 60;
      var second = betweenMs ~/ DateUnit.second.millis - betweenOfSecond;
      var millisecond = betweenMs - (betweenOfSecond + second) * 1000;

      final level = this.level.index;
      var levelCount = 0;

      if (_isLevelCountValid(levelCount) &&
          0 != day &&
          level >= Level.day.index) {
        sb.writeAll([day, Level.day.name]);
        levelCount++;
      }
      if (_isLevelCountValid(levelCount) &&
          0 != hour &&
          level >= Level.hour.index) {
        sb.writeAll([hour, Level.hour.name]);
        levelCount++;
      }
      if (_isLevelCountValid(levelCount) &&
          0 != minute &&
          level >= Level.minute.index) {
        sb.writeAll([minute, Level.minute.name]);
        levelCount++;
      }
      if (_isLevelCountValid(levelCount) &&
          0 != second &&
          level >= Level.second.index) {
        sb.writeAll([second, Level.second.name]);
        levelCount++;
      }
      if (_isLevelCountValid(levelCount) &&
          0 != millisecond &&
          level >= Level.millisecond.index) {
        sb.writeAll([millisecond, Level.millisecond.name]);
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
