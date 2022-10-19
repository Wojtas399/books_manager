import 'package:app/data/data_sources/local_db/day_local_db_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:mocktail/mocktail.dart';

class FakeDay extends Fake implements Day {}

class FakeReadBook extends Fake implements ReadBook {}

class FakeDateTime extends Fake implements DateTime {}

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

  void mockAddDay() {
    _mockDay();
    _mockSyncState();
    when(
      () => addDay(
        day: any(named: 'day'),
        syncState: any(named: 'syncState'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateDay() {
    _mockDateTime();
    _mockReadBook();
    _mockSyncState();
    when(
      () => updateDay(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        readBooks: any(named: 'readBooks'),
        syncState: any(named: 'syncState'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockDeleteDay() {
    _mockDateTime();
    when(
      () => deleteDay(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockDay() {
    registerFallbackValue(FakeDay());
  }

  void _mockReadBook() {
    registerFallbackValue(FakeReadBook());
  }

  void _mockSyncState() {
    registerFallbackValue(SyncState.none);
  }

  void _mockDateTime() {
    registerFallbackValue(FakeDateTime());
  }
}
