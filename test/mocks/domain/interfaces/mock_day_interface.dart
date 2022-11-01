import 'package:app/domain/entities/day.dart';
import 'package:app/domain/interfaces/day_interface.dart';
import 'package:mocktail/mocktail.dart';

class FakeDay extends Fake implements Day {}

class FakeDateTime extends Fake implements DateTime {}

class MockDayInterface extends Mock implements DayInterface {
  void mockGetUserDays({required List<Day> userDays}) {
    when(
      () => getUserDays(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(userDays));
  }

  void mockAddNewDay() {
    _mockDay();
    when(
      () => addNewDay(
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
