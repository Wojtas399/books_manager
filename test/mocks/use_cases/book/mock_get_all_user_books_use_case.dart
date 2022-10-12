import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/get_all_user_books_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllUserBooksUseCase extends Mock
    implements GetAllUserBooksUseCase {
  void mock({List<Book>? userBooks}) {
    when(
      () => execute(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(userBooks));
  }
}
