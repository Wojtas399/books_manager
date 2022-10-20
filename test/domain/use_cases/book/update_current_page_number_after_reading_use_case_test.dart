import 'package:app/domain/entities/book.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/use_cases/book/update_current_page_number_after_reading_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/domain/interfaces/mock_book_interface.dart';
import '../../../mocks/domain/use_cases/day/mock_add_new_read_book_to_use_days_use_case.dart';

void main() {
  final bookInterface = MockBookInterface();
  final addNewReadBookToUserDaysUseCase = MockAddNewReadBookToUserDaysUseCase();
  final useCase = UpdateCurrentPageNumberAfterReadingUseCase(
    bookInterface: bookInterface,
    addNewReadBookToUserDaysUseCase: addNewReadBookToUserDaysUseCase,
  );

  test(
    'should update book with new read pages amount set to given new current page number and should add read pages amount to user days',
    () async {
      const String bookId = 'b1';
      const String userId = 'u1';
      const int newCurrentPageNumber = 120;
      final Book book = createBook(
        id: bookId,
        userId: userId,
        readPagesAmount: 50,
      );
      final ReadBook readBook = createReadBook(
        bookId: bookId,
        readPagesAmount: newCurrentPageNumber - book.readPagesAmount,
      );
      bookInterface.mockGetBookById(book: book);
      bookInterface.mockUpdateBookData();
      addNewReadBookToUserDaysUseCase.mock();

      await useCase.execute(
        bookId: bookId,
        userId: userId,
        newCurrentPageNumber: newCurrentPageNumber,
      );

      verify(
        () => bookInterface.updateBookData(
          bookId: bookId,
          readPagesAmount: newCurrentPageNumber,
        ),
      ).called(1);
      verify(
        () => addNewReadBookToUserDaysUseCase.execute(
          userId: userId,
          readBook: readBook,
        ),
      ).called(1);
    },
  );
}
