import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/interfaces/day_interface.dart';
import 'package:mocktail/mocktail.dart';

class FakeReadBook extends Fake implements ReadBook {}

class MockDayInterface extends Mock implements DayInterface {
  void mockGetUserDays({required List<Day> userDays}) {
    when(
      () => getUserDays(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(userDays));
  }

  void mockInitializeForUser() {
    when(
      () => initializeForUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockLoadUserDaysFromMonth() {
    when(
      () => loadUserDaysFromMonth(
        userId: any(named: 'userId'),
        month: any(named: 'month'),
        year: any(named: 'year'),
      ),
    ).thenAnswer((_) async => '');
  }
}
