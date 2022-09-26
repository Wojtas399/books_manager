import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_read_pages.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_read_pages_service.dart';
import 'package:mocktail/mocktail.dart';

class FakeSqliteReadPages extends Fake implements SqliteReadPages {}

class MockSqliteReadPagesService extends Mock
    implements SqliteReadPagesService {
  void mockLoadListOfUserReadPages({
    required List<SqliteReadPages> listOfUserReadPages,
  }) async {
    when(
      () => loadListOfUserReadPages(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    ).thenAnswer((_) async => listOfUserReadPages);
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
