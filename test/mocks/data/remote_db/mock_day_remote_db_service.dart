import 'package:app/data/data_sources/remote_db/day_remote_db_service.dart';
import 'package:app/domain/entities/day.dart';
import 'package:mocktail/mocktail.dart';

class FakeDay extends Fake implements Day {}

class FakeDateTime extends Fake implements DateTime {}

class MockDayRemoteDbService extends Mock implements DayRemoteDbService {
  void mockLoadUserDays({required List<Day> userDays}) {
    when(
      () => loadUserDays(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => userDays);
  }

  void mockAddDay() {
    _mockDay();
    when(
      () => addDay(
        day: any(named: 'day'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateDay() {
    _mockDay();
    when(
      () => updateDay(
        updatedDay: any(named: 'updatedDay'),
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

  void _mockDateTime() {
    registerFallbackValue(FakeDateTime());
  }
}
