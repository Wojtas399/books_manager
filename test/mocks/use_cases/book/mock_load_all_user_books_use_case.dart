import 'package:app/domain/use_cases/book/load_all_user_books_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadAllUserBooksUseCase extends Mock
    implements LoadAllUserBooksUseCase {
  void mock() {
    when(
      () => execute(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }
}
