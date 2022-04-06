class CollectionUtil {
  /// 如果此集合中为null，或者没有元素，则返回true 。
  static bool isEmpty(Iterable<dynamic>? iterable) {
    return iterable == null || iterable.isEmpty;
  }

  /// 返回一个新列表，其中包含在start （含）和end （含）之间的索引处的元素。
  // 如果end被省略，它被设置为lastIndex 。
  static List<E> slice<E>(List<E> list, int start, [int end = -1]) {
    var _start = start;
    var _end = end;

    if (_start < 0) {
      _start = _start + list.length;
    }
    if (_end < 0) {
      _end = _end + list.length;
    }

    RangeError.checkValidRange(_start, _end, list.length);

    return list.sublist(_start, _end + 1);
  }
}
