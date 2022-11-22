import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/get_all_books_of_user_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllBooksOfUserUseCase extends Mock
    implements GetAllBooksOfUserUseCase {
  void mock({required List<Book> booksOfUser}) {
    when(
      () => execute(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(booksOfUser));
  }
}
