import 'package:app/data/data_sources/local_db/day_local_db_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:mocktail/mocktail.dart';

class FakeReadBook extends Fake implements ReadBook {}

class MockDayLocalDbService extends Mock implements DayLocalDbService {
  void mockLoadUserDays({required List<Day> userDays}) {
    _mockSyncState();
    when(
      () => loadUserDays(
        userId: any(named: 'userId'),
        syncState: any(named: 'syncState'),
      ),
    ).thenAnswer((_) async => userDays);
  }

  void mockLoadUserDaysFromMonth({required List<Day> userDaysFromMonth}) {
    when(
      () => loadUserDaysFromMonth(
        userId: any(named: 'userId'),
        month: any(named: 'month'),
        year: any(named: 'year'),
      ),
    ).thenAnswer((_) async => userDaysFromMonth);
  }

  void mockAddUserReadBook() {
    _mockReadBook();
    _mockSyncState();
    when(
      () => addUserReadBook(
        readBook: any(named: 'readBook'),
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        syncState: any(named: 'syncState'),
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

  void mockAddNewReadPages({required Day updatedDay}) {
    _mockSyncState();
    when(
      () => addNewReadPages(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        bookId: any(named: 'bookId'),
        amountOfReadPagesToAdd: any(named: 'amountOfReadPagesToAdd'),
        withModifiedSyncState: any(named: 'withModifiedSyncState'),
      ),
    ).thenAnswer((_) async => updatedDay);
  }

  void _mockReadBook() {
    registerFallbackValue(FakeReadBook());
  }

  void _mockSyncState() {
    registerFallbackValue(SyncState.none);
  }
}
