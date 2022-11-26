import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/get_books_in_progress_of_user_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetBooksInProgressOfUserUseCase extends Mock
    implements GetBooksInProgressOfUserUseCase {
  void mock({required List<Book> booksInProgressOfUser}) {
    when(
      () => execute(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(booksInProgressOfUser));
  }
}
