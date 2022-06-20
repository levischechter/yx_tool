import 'dart:io';

/// 系统工具
class SystemUtil {
  SystemUtil._();

  /// 所有环境变量
  static Map<String, String> get env => Platform.environment;

  /// 系统分隔符
  static String get pathSeparator => Platform.pathSeparator;

  /// dart版本号
  static String get version => Platform.version;

  /// 语言环境
  static String get localeName => Platform.localeName;

  /// 本地主机名称
  static String get localHostname => Platform.localHostname;

  /// 逻辑处理器数量
  static int get numberOfProcessors => Platform.numberOfProcessors;

  /// 操作系统版本号（例如：Windows 10 Pro" 10.0 (Build 19043)）
  static String get operatingSystemVersion => Platform.operatingSystemVersion;

  /// 操作系统名称。 linux、windows、macos、android、fuchsia、ios
  static String get operatingSystem => Platform.operatingSystem;

  /// 获取环境变量[key]
  static String? getEnv(String key) {
    return env[key];
  }

  /// 获取环境变量[key]分割集合
  static List<String>? getEnvList(String key) {
    var envValue = env[key];
    if (envValue != null) {
      return envValue.split(';');
    }
    return null;
  }
}
