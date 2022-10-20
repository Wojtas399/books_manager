import 'package:app/domain/use_cases/book/delete_book_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockDeleteBookUseCase extends Mock implements DeleteBookUseCase {
  void mock() {
    when(
      () => execute(
        bookId: any(named: 'bookId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }
}
