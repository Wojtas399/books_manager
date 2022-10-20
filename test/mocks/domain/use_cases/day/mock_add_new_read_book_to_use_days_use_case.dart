import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/use_cases/day/add_new_read_book_to_user_days_use_case.dart';
import 'package:mocktail/mocktail.dart';

class FakeReadBook extends Fake implements ReadBook {}

class MockAddNewReadBookToUserDaysUseCase extends Mock
    implements AddNewReadBookToUserDaysUseCase {
  void mock() {
    _mockReadBook();
    when(
      () => execute(
        userId: any(named: 'userId'),
        readBook: any(named: 'readBook'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockReadBook() {
    registerFallbackValue(FakeReadBook());
  }
}
