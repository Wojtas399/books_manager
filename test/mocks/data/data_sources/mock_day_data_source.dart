import 'package:app/data/data_sources/day_data_source.dart';
import 'package:app/domain/entities/day.dart';
import 'package:mocktail/mocktail.dart';

class FakeDay extends Fake implements Day {}

class FakeDateTime extends Fake implements DateTime {}

class MockDayDataSource extends Mock implements DayDataSource {
  void mockGetUserDays({required List<Day> userDays}) {
    when(
      () => getUserDays(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(userDays));
  }

  void mockGetUserDaysFromMonth({required List<Day> userDaysFromMonth}) {
    when(
      () => getUserDaysFromMonth(
        userId: any(named: 'userId'),
        month: any(named: 'month'),
        year: any(named: 'year'),
      ),
    ).thenAnswer((_) => Stream.value(userDaysFromMonth));
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
