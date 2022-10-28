import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/update_current_page_number_after_reading_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/domain/interfaces/mock_book_interface.dart';
import '../../../mocks/domain/use_cases/day/mock_add_new_read_book_to_use_days_use_case.dart';

void main() {
  final bookInterface = MockBookInterface();
  final addNewReadBookToUserDaysUseCase = MockAddNewReadBookToUserDaysUseCase();
  late UpdateCurrentPageNumberAfterReadingUseCase useCase;
  const String userId = 'u1';
  const String bookId = 'b1';
  final Book book = createBook(
    id: bookId,
    userId: userId,
    readPagesAmount: 50,
    allPagesAmount: 300,
  );

  Future<void> useCaseCall(int newCurrentPageNumber) async {
    await useCase.execute(
      userId: userId,
      bookId: bookId,
      newCurrentPageNumber: newCurrentPageNumber,
    );
  }

  setUp(() {
    useCase = UpdateCurrentPageNumberAfterReadingUseCase(
      bookInterface: bookInterface,
      addNewReadBookToUserDaysUseCase: addNewReadBookToUserDaysUseCase,
    );
    // bookInterface.mockGetBookById(book: book);
  });

  tearDown(() {
    reset(bookInterface);
    reset(addNewReadBookToUserDaysUseCase);
  });

  // test(
  //   'should throw book error if new current page is higher than all pages amount from the book',
  //   () async {
  //     final int newCurrentPageNumber = book.allPagesAmount + 1;
  //     const BookError expectedBookError = BookError(
  //       code: BookErrorCode.newCurrentPageIsTooHigh,
  //     );
  //     Object? error;
  //
  //     try {
  //       await useCaseCall(newCurrentPageNumber);
  //     } catch (useCaseError) {
  //       error = useCaseError;
  //     }
  //
  //     expect(error, expectedBookError);
  //   },
  // );
  //
  // test(
  //   'should throw book error if new current page number is lower or equal to read pages amount from the book',
  //   () async {
  //     final int newCurrentPageNumber = book.readPagesAmount;
  //     const BookError expectedBookError = BookError(
  //       code: BookErrorCode.newCurrentPageIsLowerThanReadPagesAmount,
  //     );
  //     Object? error;
  //
  //     try {
  //       await useCaseCall(newCurrentPageNumber);
  //     } catch (useCaseError) {
  //       error = useCaseError;
  //     }
  //
  //     expect(error, expectedBookError);
  //   },
  // );
  //
  // test(
  //   'should update book with new read pages amount set to given new current page number and should add read pages amount to user days',
  //   () async {
  //     const int newCurrentPageNumber = 120;
  //     final ReadBook readBook = createReadBook(
  //       bookId: bookId,
  //       readPagesAmount: newCurrentPageNumber - book.readPagesAmount,
  //     );
  //     bookInterface.mockUpdateBookData();
  //     addNewReadBookToUserDaysUseCase.mock();
  //
  //     await useCase.execute(
  //       bookId: bookId,
  //       userId: userId,
  //       newCurrentPageNumber: newCurrentPageNumber,
  //     );
  //
  //     verify(
  //       () => bookInterface.updateBookData(
  //         bookId: bookId,
  //         readPagesAmount: newCurrentPageNumber,
  //       ),
  //     ).called(1);
  //     verify(
  //       () => addNewReadBookToUserDaysUseCase.execute(
  //         userId: userId,
  //         readBook: readBook,
  //       ),
  //     ).called(1);
  //   },
  // );
}
