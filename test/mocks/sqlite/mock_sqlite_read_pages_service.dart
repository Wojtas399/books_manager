import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_pages.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_read_pages_service.dart';
import 'package:mocktail/mocktail.dart';

class FakeSqliteReadPages extends Fake implements SqliteReadPages {}

class MockSqliteReadPagesService extends Mock
    implements SqliteReadPagesService {
  void mockLoadReadPages({SqliteReadPages? sqliteReadPages}) {
    when(
      () => loadReadPages(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        bookId: any(named: 'bookId'),
      ),
    ).thenAnswer((_) async => sqliteReadPages);
  }

  void mockLoadListOfReadPagesByUserId({
    required List<SqliteReadPages> listOfSqliteReadPages,
  }) async {
    when(
      () => loadListOfReadPagesByUserId(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => listOfSqliteReadPages);
  }

  void mockAddReadPages() {
    _mockSqliteReadPages();
    when(
      () => addReadPages(
        sqliteReadPages: any(named: 'sqliteReadPages'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateReadPages() {
    _mockSqliteReadPages();
    when(
      () => updateReadPages(
        updatedReadPages: any(named: 'updatedReadPages'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockSqliteReadPages() {
    registerFallbackValue(FakeSqliteReadPages());
  }
}
