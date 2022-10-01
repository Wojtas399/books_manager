import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_read_book_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:mocktail/mocktail.dart';

class FakeSqliteReadBook extends Fake implements SqliteReadBook {}

class MockSqliteReadBookService extends Mock implements SqliteReadBookService {
  void mockLoadReadBook({SqliteReadBook? readBook}) {
    when(
      () => loadReadBook(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        bookId: any(named: 'bookId'),
      ),
    ).thenAnswer((_) async => readBook);
  }

  void mockLoadUserReadBooks({
    required List<SqliteReadBook> userReadBooks,
  }) async {
    _mockSyncState();
    when(
      () => loadUserReadBooks(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        syncState: any(named: 'syncState'),
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
    _mockSyncState();
    when(
      () => updateReadBook(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        bookId: any(named: 'bookId'),
        readPagesAmount: any(named: 'readPagesAmount'),
        syncState: any(named: 'syncState'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockSqliteReadBook() {
    registerFallbackValue(FakeSqliteReadBook());
  }

  void _mockSyncState() {
    registerFallbackValue(SyncState.none);
  }
}
