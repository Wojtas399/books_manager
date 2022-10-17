import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_book_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:mocktail/mocktail.dart';

class FakeSqliteBook extends Fake implements SqliteBook {}

class MockSqliteBookService extends Mock implements SqliteBookService {
  void mockLoadBook({required SqliteBook sqliteBook}) {
    when(
      () => loadBook(
        bookId: any(named: 'bookId'),
      ),
    ).thenAnswer((_) async => sqliteBook);
  }

  void mockLoadUserBooks({required List<SqliteBook> userSqliteBooks}) {
    _mockSyncState();
    when(
      () => loadUserBooks(
        userId: any(named: 'userId'),
        bookStatus: any(named: 'bookStatus'),
        syncState: any(named: 'syncState'),
      ),
    ).thenAnswer((_) async => userSqliteBooks);
  }

  void mockAddBook() {
    _mockSqliteBook();
    when(
      () => addBook(
        sqliteBook: any(named: 'sqliteBook'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateBook({required SqliteBook updatedSqliteBook}) {
    _mockSyncState();
    when(
      () => updateBook(
        bookId: any(named: 'bookId'),
        status: any(named: 'status'),
        title: any(named: 'title'),
        author: any(named: 'author'),
        readPagesAmount: any(named: 'readPagesAmount'),
        allPagesAmount: any(named: 'allPagesAmount'),
        syncState: any(named: 'syncState'),
      ),
    ).thenAnswer((_) async => updatedSqliteBook);
  }

  void mockDeleteBook() {
    when(
      () => deleteBook(
        bookId: any(named: 'bookId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockSqliteBook() {
    registerFallbackValue(FakeSqliteBook());
  }

  void _mockSyncState() {
    registerFallbackValue(SyncState.none);
  }
}
