import 'package:app/domain/use_cases/day/delete_book_from_user_days_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockDeleteBookFromUserDaysUseCase extends Mock
    implements DeleteBookFromUserDaysUseCase {
  void mock() {
    when(
      () => execute(
        userId: any(named: 'userId'),
        bookId: any(named: 'bookId'),
      ),
    ).thenAnswer((_) async => '');
  }
}
