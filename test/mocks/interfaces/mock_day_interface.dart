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

  void mockAddUserReadBook() {
    _mockReadBook();
    when(
      () => addUserReadBook(
        readBook: any(named: 'readBook'),
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateReadPagesAmountOfUserReadBook() {
    when(
      () => updateReadPagesAmountOfUserReadBook(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        bookId: any(named: 'bookId'),
        updatedReadPagesAmount: any(named: 'updatedReadPagesAmount'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockReadBook() {
    registerFallbackValue(FakeReadBook());
  }
}
