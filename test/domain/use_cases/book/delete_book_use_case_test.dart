import 'package:app/domain/use_cases/book/delete_book_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/domain/interfaces/mock_book_interface.dart';
import '../../../mocks/domain/use_cases/day/mock_delete_book_from_user_days_use_case.dart';

void main() {
  final bookInterface = MockBookInterface();
  final deleteBookFromUserDaysUseCase = MockDeleteBookFromUserDaysUseCase();
  final useCase = DeleteBookUseCase(
    bookInterface: bookInterface,
    deleteBookFromUserDaysUseCase: deleteBookFromUserDaysUseCase,
  );

  test(
    'should call method responsible for deleting book and for deleting book from user days',
    () async {
      const String bookId = 'b1';
      const String userId = 'u1';
      bookInterface.mockDeleteBook();
      deleteBookFromUserDaysUseCase.mock();

      await useCase.execute(bookId: bookId, userId: userId);

      verify(
        () => bookInterface.deleteBook(
          bookId: bookId,
          userId: userId,
        ),
      ).called(1);
      verify(
        () => deleteBookFromUserDaysUseCase.execute(
          userId: userId,
          bookId: bookId,
        ),
      ).called(1);
    },
  );
}
