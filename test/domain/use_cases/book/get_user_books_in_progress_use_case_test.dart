import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/get_user_books_in_progress_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/domain/interfaces/mock_book_interface.dart';

void main() {
  final bookInterface = MockBookInterface();
  final useCase = GetUserBooksInProgressUseCase(bookInterface: bookInterface);

  test(
    'should return result of method from book interface responsible for getting user books with book status set as in progress',
    () async {
      const String userId = 'u1';
      final List<Book> expectedUserBooks = [
        createBook(id: 'b2', status: BookStatus.inProgress),
        createBook(id: 'b4', status: BookStatus.inProgress),
      ];
      bookInterface.mockGetUserBooks(userBooks: expectedUserBooks);

      final Stream<List<Book>?> userBooks$ = useCase.execute(userId: userId);

      expect(await userBooks$.first, expectedUserBooks);
      verify(
        () => bookInterface.getUserBooks(
          userId: userId,
          bookStatus: BookStatus.inProgress,
        ),
      ).called(1);
    },
  );
}
