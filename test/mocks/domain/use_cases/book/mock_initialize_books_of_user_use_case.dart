import 'package:app/domain/use_cases/book/initialize_books_of_user_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockInitializeBooksOfUserUseCase extends Mock
    implements InitializeBooksOfUserUseCase {
  void mock() {
    when(
      () => execute(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }
}
