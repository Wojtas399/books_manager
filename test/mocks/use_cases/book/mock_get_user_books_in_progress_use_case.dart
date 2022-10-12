import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/get_user_books_in_progress_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUserBooksInProgressUseCase extends Mock
    implements GetUserBooksInProgressUseCase {
  void mock({List<Book>? userBooksInProgress}) {
    when(
      () => execute(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(userBooksInProgress));
  }
}
