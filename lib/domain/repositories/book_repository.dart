import '../../database/sqlite/entities/sqlite_book.dart';
import '../../database/sqlite/services/sqlite_book_service.dart';
import '../../interfaces/book_interface.dart';

class BookRepository implements BookInterface {
  late final SqliteBookService _sqliteBookService;

  BookRepository({
    required SqliteBookService sqliteBookService,
  }) {
    _sqliteBookService = sqliteBookService;
  }

  @override
  Future<void> addNewBook({
    required String title,
    required String author,
    required int readPagesAmount,
    required int allPagesAmount,
  }) async {
    await _sqliteBookService.addNewBook(
      SqliteBook(
        userId: 'testUser',
        title: title,
        author: author,
        readPagesAmount: readPagesAmount,
        allPagesAmount: allPagesAmount,
      ),
    );
  }
}
