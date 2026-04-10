extension IterableExtensions<T> on Iterable<T> {
  bool containsAny(Iterable<T> other) => other.any(contains);
}
