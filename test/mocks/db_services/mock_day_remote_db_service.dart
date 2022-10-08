import 'package:app/data/data_sources/remote_db/day_remote_db_service.dart';
import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:mocktail/mocktail.dart';

class FakeReadBook extends Fake implements ReadBook {}

class MockDayRemoteDbService extends Mock implements DayRemoteDbService {
  void mockLoadUserDays({required List<Day> userDays}) {
    when(
      () => loadUserDays(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => userDays);
  }

  void mockAddUserReadBooks() {
    _mockReadBook();
    when(
      () => addUserReadBook(
        readBook: any(named: 'readBook'),
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateBookReadPagesAmountInDay() {
    _mockReadBook();
    when(
      () => updateBookReadPagesAmountInDay(
        updatedReadBook: any(named: 'updatedReadBook'),
        userId: any(named: 'userId'),
        date: any(named: 'date'),
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

  void _mockReadBook() {
    registerFallbackValue(FakeReadBook());
  }
}
