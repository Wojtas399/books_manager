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

  void mockLoadUserDays() {
    when(
      () => loadUserDays(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockAddNewReadPages() {
    when(
      () => addNewReadPages(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        bookId: any(named: 'bookId'),
        amountOfReadPagesToAdd: any(named: 'amountOfReadPagesToAdd'),
      ),
    ).thenAnswer((_) async => '');
  }
}
