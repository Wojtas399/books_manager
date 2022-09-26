import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_read_book_service.dart';
import 'package:mocktail/mocktail.dart';

class FakeSqliteReadBook extends Fake implements SqliteReadBook {}

class MockSqliteReadBookService extends Mock implements SqliteReadBookService {
  void mockLoadUserReadBooks({
    required List<SqliteReadBook> userReadBooks,
  }) async {
    when(
      () => loadUserReadBooks(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    ).thenAnswer((_) async => userReadBooks);
  }

  void mockAddReadBook() {
    _mockSqliteReadBook();
    when(
      () => addReadBook(
        sqliteReadBook: any(named: 'sqliteReadBook'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateReadBook() {
    _mockSqliteReadBook();
    when(
      () => updateReadBook(
        updatedSqliteReadBook: any(named: 'updatedSqliteReadBook'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockSqliteReadBook() {
    registerFallbackValue(FakeSqliteReadBook());
  }
}
