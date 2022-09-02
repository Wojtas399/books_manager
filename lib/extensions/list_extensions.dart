extension ListExtensions<T> on List<T> {
  bool doesNotContain(Object? element) {
    return !contains(element);
  }

  List<T> removeRepetitions() {
    return toSet().toList();
  }
}
