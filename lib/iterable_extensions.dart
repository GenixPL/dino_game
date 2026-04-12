extension IterableExtensions<T> on Iterable<T> {
  bool containsAny(Iterable<T> other) => other.any(contains);

  /// Just a convenience wrap around [where] and [toList].
  List<T> whereList(bool Function(T value) test) {
    final List<T> finalList = [];

    for (final T value in this) {
      if (test(value)) {
        finalList.add(value);
      }
    }

    return finalList;
  }
}
