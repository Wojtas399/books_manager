import 'package:app/data/data_sources/local_db/day_local_db_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/data/models/db_read_book.dart';
import 'package:mocktail/mocktail.dart';

class FakeDbReadBook extends Fake implements DbReadBook {}

class MockDayLocalDbService extends Mock implements DayLocalDbService {
  void mockLoadUserDays({required List<DbDay> userDbDays}) {
    when(
      () => loadUserDays(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => userDbDays);
  }

  void mockAddUserReadBook() {
    _mockDbReadBook();
    _mockSyncState();
    when(
      () => addUserReadBook(
        dbReadBook: any(named: 'dbReadBook'),
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        syncState: any(named: 'syncState'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateReadBook({required DbReadBook updatedDbReadBook}) {
    _mockSyncState();
    when(
      () => updateReadBook(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        bookId: any(named: 'bookId'),
        readPagesAmount: any(named: 'readPagesAmount'),
        syncState: any(named: 'syncState'),
      ),
    ).thenAnswer((_) async => updatedDbReadBook);
  }

  void _mockDbReadBook() {
    registerFallbackValue(FakeDbReadBook());
  }

  void _mockSyncState() {
    registerFallbackValue(SyncState.none);
  }
}
