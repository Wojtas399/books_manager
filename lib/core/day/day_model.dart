class Day {
  String id;
  Map<String, int> booksReadPages;

  Day({required this.id, required this.booksReadPages});
}

Day createDay({
  String? id,
  Map<String, int>? booksReadPages,
}) {
  return Day(id: id ?? '', booksReadPages: booksReadPages ?? Map());
}
