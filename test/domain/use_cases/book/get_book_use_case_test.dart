import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/get_book_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/domain/interfaces/mock_book_interface.dart';

void main() {
  final bookInterface = MockBookInterface();
  final useCase = GetBookUseCase(bookInterface: bookInterface);

  test(
    'should return result of method from book interface responsible for getting book',
    () async {
      const String bookId = 'b1';
      const String userId = 'u1';
      final Book expectedBook = createBook(id: bookId, userId: userId);
      bookInterface.mockGetBook(book: expectedBook);

      final Stream<Book?> book$ = useCase.execute(
        bookId: bookId,
        userId: userId,
      );

      expect(await book$.first, expectedBook);
    },
  );
}
