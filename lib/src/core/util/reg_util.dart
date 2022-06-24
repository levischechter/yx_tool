/// 正则表达式工具
class RegUtil {
  RegUtil._();

  /// 换行字符正则
  static final newlineRegExp = RegExp('[\r\n]');

  /// 空白字符正则
  static final emptyStrRegExp = RegExp(r'\s');

  /// 非空白字符正则
  static final notEmptyStrRegExp = RegExp(r'\S');
}
