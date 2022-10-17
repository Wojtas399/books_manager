import 'package:app/domain/use_cases/book/delete_book_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/domain/interfaces/mock_book_interface.dart';

void main() {
  final bookInterface = MockBookInterface();
  final useCase = DeleteBookUseCase(bookInterface: bookInterface);

  test(
    'should call method responsible for deleting book',
    () async {
      const String bookId = 'b1';
      bookInterface.mockDeleteBook();

      await useCase.execute(bookId: bookId);

      verify(
        () => bookInterface.deleteBook(bookId: bookId),
      ).called(1);
    },
  );
}
