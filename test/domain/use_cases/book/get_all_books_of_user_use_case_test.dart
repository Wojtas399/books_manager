import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/get_all_books_of_user_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/domain/interfaces/mock_book_interface.dart';

void main() {
  final bookInterface = MockBookInterface();
  final useCase = GetAllBooksOfUserUseCase(bookInterface: bookInterface);

  test(
    'should return result of method from book interface responsible for getting books of user with book status set as null',
    () async {
      const String userId = 'u1';
      final List<Book> expectedUserBooks = [
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
      bookInterface.mockGetBooksOfUser(userBooks: expectedUserBooks);

      final Stream<List<Book>?> userBooks$ = useCase.execute(userId: userId);

      expect(await userBooks$.first, expectedUserBooks);
      verify(
        () => bookInterface.getBooksOfUser(userId: userId),
      ).called(1);
    },
  );
}
