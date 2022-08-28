import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/get_books_by_user_id_use_case.dart';
import 'package:app/interfaces/book_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookInterface extends Mock implements BookInterface {}

void main() {
  final bookInterface = MockBookInterface();
  final useCase = GetBooksByUserIdUseCase(bookInterface: bookInterface);

  test(
    'should return stream which contains books belonging to user',
    () async {
      const String userId = 'u1';
      final List<Book> books = [
        createBook(
          userId: userId,
          title: 'book1',
          author: 'author1',
        ),
        createBook(
          userId: userId,
          title: 'book2',
          author: 'author2',
        ),
      ];
      when(
        () => bookInterface.getBooksByUserId(userId: userId),
      ).thenAnswer((_) => Stream.value(books));

      final Stream<List<Book>> books$ = useCase.execute(userId: userId);

      expect(await books$.first, books);
    },
  );
}
