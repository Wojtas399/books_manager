import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/get_all_user_books_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/domain/interfaces/mock_book_interface.dart';

void main() {
  final bookInterface = MockBookInterface();
  final useCase = GetAllUserBooksUseCase(bookInterface: bookInterface);

  test(
    'should return result of method responsible for getting user books with book status set as null',
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
      bookInterface.mockGetUserBooks(userBooks: expectedUserBooks);

      final Stream<List<Book>> userBooks$ = useCase.execute(userId: userId);

      expect(await userBooks$.first, expectedUserBooks);
    },
  );
}
