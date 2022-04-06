import 'between_formatter.dart';
import 'date_unit.dart';

/// 分组计时器<br>
//  计算某几个过程花费的时间，精确到毫秒或纳秒
class TimeInterval {
  /// 默认id
  static const _DEFAULT_ID = '';

  /// 是否是微秒计时
  final bool isMicrosecond;

  /// 分组
  final Map<String, int> groupMap;

  TimeInterval([this.isMicrosecond = false]) : groupMap = {} {
    start();
  }

  /// 清空所有定时记录
  TimeInterval clear() {
    groupMap.clear();
    return this;
  }

  /// 使用分组[id],开始计时并返回当前时间
  int start([String id = _DEFAULT_ID]) {
    final time = _getTime();
    groupMap[id] = time;
    return time;
  }

  /// 重新计时并返回从开始到当前的持续时间秒
  /// 如果此分组下没有记录，则返回0;
  int intervalRestart([String id = _DEFAULT_ID]) {
    final now = _getTime();
    var t = groupMap[id] ?? now;
    groupMap[id] = now;
    return now - t;
  }

  //----------------------------------------------------------- Interval

  /// 从开始到当前的间隔时间（毫秒数）<br>
  /// 如果使用纳秒计时，返回纳秒差，否则返回毫秒差<br>
  /// 如果分组下没有开始时间，返回{@code null}<br>
  /// 可以使用时间间隔控制返回的差值单位
  int interval({String id = _DEFAULT_ID, DateUnit? dateUnit}) {
    var lastTime = groupMap[id];
    if (lastTime == null) {
      return 0;
    }

    if (dateUnit == null) {
      return _getTime() - lastTime;
    } else {
      return (_getTime() - lastTime) ~/ dateUnit.millis;
    }
  }

  /// 从开始到当前的间隔时间（毫秒数）
  int intervalMs([String id = _DEFAULT_ID]) {
    return interval(id: id, dateUnit: DateUnit.MS);
  }

  /// 从开始到当前的间隔秒数，取绝对值
  int intervalSecond([String id = _DEFAULT_ID]) {
    return interval(id: id, dateUnit: DateUnit.SECOND);
  }

  /// 从开始到当前的间隔分钟数，取绝对值
  int intervalMinute([String id = _DEFAULT_ID]) {
    return interval(id: id, dateUnit: DateUnit.MINUTE);
  }

  /// 从开始到当前的间隔小时数，取绝对值
  int intervalHour([String id = _DEFAULT_ID]) {
    return interval(id: id, dateUnit: DateUnit.HOUR);
  }

  /// 从开始到当前的间隔天数，取绝对值
  int intervalDay([String id = _DEFAULT_ID]) {
    return interval(id: id, dateUnit: DateUnit.DAY);
  }

  /// 从开始到当前的间隔周数，取绝对值
  int intervalWeek([String id = _DEFAULT_ID]) {
    return interval(id: id, dateUnit: DateUnit.WEEK);
  }

  /// 从开始到当前的间隔时间（毫秒数），返回XX天XX小时XX分XX秒XX毫秒
  ///
  /// [id] 分组ID
  /// @return 从开始到当前的间隔时间（毫秒数）
  String intervalPretty(String id) {
    return BetweenFormatter(betweenMs: intervalMs(id), level: Level.MILLISECOND).format();
  }

  /// 获取时间的毫秒或纳秒数，纳秒非时间戳
  ///
  /// @return 时间
  int _getTime() {
    return isMicrosecond ? DateTime.now().microsecondsSinceEpoch : DateTime.now().millisecondsSinceEpoch;
  }
}
