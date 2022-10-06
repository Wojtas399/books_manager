import 'package:app/domain/use_cases/book/load_user_books_in_progress_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadUserBooksInProgressUseCase extends Mock
    implements LoadUserBooksInProgressUseCase {
  void mock() {
    when(
      () => execute(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }
}
