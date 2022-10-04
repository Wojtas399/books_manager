import 'package:app/data/data_sources/remote_db/day_remote_db_service.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/data/models/db_read_book.dart';
import 'package:mocktail/mocktail.dart';

class FakeDbReadBook extends Fake implements DbReadBook {}

class MockDayRemoteDbService extends Mock implements DayRemoteDbService {
  void mockLoadUserDays({required List<DbDay> userDbDays}) {
    when(
      () => loadUserDays(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => userDbDays);
  }

  void mockAddUserReadBooks() {
    _mockDbReadBook();
    when(
      () => addUserReadBook(
        dbReadBook: any(named: 'dbReadBook'),
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateBookReadPagesAmountInDay() {
    _mockDbReadBook();
    when(
      () => updateBookReadPagesAmountInDay(
        updatedDbReadBook: any(named: 'updatedDbReadBook'),
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

  void _mockDbReadBook() {
    registerFallbackValue(FakeDbReadBook());
  }
}
