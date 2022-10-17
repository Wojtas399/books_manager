import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/get_user_books_in_progress_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/interfaces/mock_book_interface.dart';

void main() {
  final bookInterface = MockBookInterface();
  final useCase = GetUserBooksInProgressUseCase(bookInterface: bookInterface);

  test(
    'should return stream which contains books in progress',
    () async {
      const String userId = 'u1';
      final List<Book> userBooks = [
        createBook(id: 'b1', status: BookStatus.unread),
        createBook(id: 'b2', status: BookStatus.inProgress),
        createBook(id: 'b3', status: BookStatus.finished),
        createBook(id: 'b4', status: BookStatus.inProgress),
      ];
      final List<Book> expectedBooks = [userBooks[1], userBooks[3]];
      bookInterface.mockGetBooksByUserId(books: userBooks);

      final Stream<List<Book>?> books$ = useCase.execute(userId: userId);

      expect(await books$.first, expectedBooks);
    },
  );
}
