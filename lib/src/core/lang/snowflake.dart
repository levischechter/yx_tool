import 'dart:async';

import 'package:yx_tool/src/core/util/id_util.dart';

/// Twitter的Snowflake 算法<br>
/// 分布式系统中，有一些需要使用全局唯一ID的场景，有些时候我们希望能使用一种简单一些的ID，并且希望ID能够按照时间有序生成。
///
/// <p>
/// snowflake的结构如下(每部分用-分开):<br>
///
/// ```dart
/// 符号位（1bit）- 时间戳相对值（41bit）- 数据中心标志（5bit）- 机器标志（5bit）- 递增序号（12bit）
/// 0 - 0000000000 0000000000 0000000000 0000000000 0 - 00000 - 00000 - 000000000000
/// ```
/// <p>
/// 第一位为未使用(符号位表示正数)，接下来的41位为毫秒级时间(41位的长度可以使用69年)<br>
/// 然后是5位datacenterId和5位workerId(10位的长度最多支持部署1024个节点）<br>
/// 最后12位是毫秒内的计数（12位的计数顺序号支持每个节点每毫秒产生4096个ID序号）
/// <p>
/// 并且可以通过生成的id反推出生成时间,datacenterId和workerId
/// <p>
class Snowflake {
  ///默认的起始时间，为Thu, 04 Nov 2010 01:42:54 GMT
  static const _defaultTwepoch = 1288834974657;

  ///默认回拨时间，2S
  static const _defaultTimeOffset = 2000;

  static const _workerIdBits = 5;

  ///最大支持机器节点数0~31，一共32个
  static const _maxWorkerId = -1 ^ (-1 << _workerIdBits);

  static const _dataCenterIdBits = 5;

  static const _maxDataCenterId = -1 ^ (-1 << _dataCenterIdBits);

  // 序列号12位（表示只允许workId的范围为：0-4095）
  static final int _sequenceBits = 12;

  // 机器节点左移12位
  static final int _workerIdShift = _sequenceBits;

  // 数据中心节点左移17位
  static final int _dataCenterIdShift = _sequenceBits + _workerIdBits;

  // 时间毫秒数左移22位
  static final int _timestampLeftShift = _sequenceBits + _workerIdBits + _dataCenterIdBits;

  // 序列掩码，用于限定序列最大值不能超过4095
  static final int _sequenceMask = ~(-1 << _sequenceBits); // 4095

  late final int _twepoch;
  late final int _workerId;
  late final int _dataCenterId;

  // 允许的时钟回拨数
  late final int _timeOffset;

  int _sequence = 0;
  int _lastTimestamp = -1;

  Snowflake._();

  /// 获取实例
  static Future<Snowflake> getInstance({
    DateTime? epochDate,
    int? workerId,
    int? dataCenterId,
    int timeOffset = _defaultTimeOffset,
  }) async {
    dataCenterId ??= await IdUtil.getDataCenterId(_maxDataCenterId);
    return getInstanceSync(epochDate: epochDate, workerId: workerId, timeOffset: timeOffset, dataCenterId: dataCenterId);
  }

  /// 获取实例的同步方法，此方法[dataCenterId]不能为空
  static Snowflake getInstanceSync({
    DateTime? epochDate,
    int? workerId,
    required int dataCenterId,
    int timeOffset = _defaultTimeOffset,
  }) {
    var snowflake = Snowflake._();
    if (null != epochDate) {
      snowflake._twepoch = epochDate.millisecondsSinceEpoch;
    } else {
      // Thu, 04 Nov 2010 01:42:54 GMT
      snowflake._twepoch = _defaultTwepoch;
    }
    workerId ??= IdUtil.getWorkerId(dataCenterId, _maxWorkerId);
    if (workerId > _maxWorkerId || workerId < 0) {
      throw ArgumentError("worker Id can't be greater than $_maxWorkerId or less than 0");
    }
    if (dataCenterId > _maxDataCenterId || dataCenterId < 0) {
      throw ArgumentError("datacenter Id can't be greater than $_maxDataCenterId or less than 0");
    }
    snowflake._dataCenterId = dataCenterId;
    snowflake._workerId = workerId;
    snowflake._timeOffset = timeOffset;
    return snowflake;
  }

  /// 根据Snowflake的ID，获取机器id
  int getWorkerId(int id) {
    return id >> _workerIdShift & ~(-1 << _workerIdBits);
  }

  /// 根据Snowflake的ID，获取数据中心id
  int getDataCenterId(int id) {
    return id >> _dataCenterIdShift & ~(-1 << _dataCenterIdBits);
  }

  /// 根据Snowflake的ID，获取生成时间
  int getGenerateDateTime(int id) {
    return (id >> _timestampLeftShift & ~(-1 << 41)) + _twepoch;
  }

  /// 下一个ID
  int nextId() {
    var timestamp = _genTime();
    if (timestamp < _lastTimestamp) {
      if (_lastTimestamp - timestamp < _timeOffset) {
        // 容忍指定的回拨，避免NTP校时造成的异常
        timestamp = _lastTimestamp;
      } else {
        // 如果服务器时间有问题(时钟后退) 报错。
        throw StateError('Clock moved backwards. Refusing to generate id for ${_lastTimestamp - timestamp}ms');
      }
    }

    if (timestamp == _lastTimestamp) {
      final sequence = (_sequence + 1) & _sequenceMask;
      if (sequence == 0) {
        timestamp = _tilNextMillis(_lastTimestamp);
      }
      _sequence = sequence;
    } else {
      _sequence = 0;
    }

    _lastTimestamp = timestamp;

    return ((timestamp - _twepoch) << _timestampLeftShift) | (_dataCenterId << _dataCenterIdShift) | (_workerId << _workerIdShift) | _sequence;
  }

  /// 循环等待下一个时间
  int _tilNextMillis(int lastTimestamp) {
    var timestamp = _genTime();
    // 循环直到操作系统时间戳变化
    while (timestamp == lastTimestamp) {
      timestamp = _genTime();
    }
    if (timestamp < lastTimestamp) {
      // 如果发现新的时间戳比上次记录的时间戳数值小，说明操作系统时间发生了倒退，报错
      throw StateError('Clock moved backwards. Refusing to generate id for ${lastTimestamp - timestamp}ms');
    }
    return timestamp;
  }

  /// 下一个ID（字符串形式）
  String nextIdStr() {
    return nextId().toString();
  }

  /// 生成时间戳
  int _genTime() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}
