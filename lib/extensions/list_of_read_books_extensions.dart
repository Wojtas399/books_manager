import 'package:app/domain/entities/read_book.dart';

extension ListOfReadBooksExtensions on List<ReadBook> {
  bool containsBook(String bookId) {
    final List<String> booksIds = _getReadBooksIds();
    return booksIds.contains(bookId);
  }

  bool doesNotContainBook(String bookId) {
    final List<String> booksIds = _getReadBooksIds();
    return !booksIds.contains(bookId);
  }

  int selectReadBookIndexByBookId(String bookId) {
    return indexWhere((ReadBook readBook) => readBook.bookId == bookId);
  }

  List<String> _getReadBooksIds() {
    return map((ReadBook readBook) => readBook.bookId).toList();
  }
}
