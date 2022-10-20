import 'package:app/domain/entities/read_book.dart';
import 'package:app/extensions/list_of_read_books_extensions.dart';
import 'package:test/test.dart';

void main() {
  final List<ReadBook> readBooks = [
    createReadBook(bookId: 'b1', readPagesAmount: 100),
    createReadBook(bookId: 'b2', readPagesAmount: 120),
  ];

  test(
    'contains book, should return true if list of read books contains read book with given book id',
    () {
      final String bookId = readBooks.first.bookId;

      final bool result = readBooks.containsBook(bookId);

      expect(result, true);
    },
  );

  test(
    'contains book, should return false if list of read books does not contain read book with given book id',
    () {
      const String bookId = 'b3';

      final bool result = readBooks.containsBook(bookId);

      expect(result, false);
    },
  );

  test(
    'does not contain book, should return true if list of read books does not contain read book with given book id',
    () {
      const String bookId = 'b3';

      final bool result = readBooks.doesNotContainBook(bookId);

      expect(result, true);
    },
  );

  test(
    'does not contain book, should return false if list of read books contains read book with given book id',
    () {
      const String bookId = 'b2';

      final bool result = readBooks.doesNotContainBook(bookId);

      expect(result, false);
    },
  );

  test(
    'select read book index by book id, should return index of book matching to given book id',
    () {
      final String bookId = readBooks.last.bookId;

      final int index = readBooks.selectReadBookIndexByBookId(bookId);

      expect(index, 1);
    },
  );
}
