import 'package:app/config/errors.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/use_cases/book/update_current_page_number_in_book_use_case.dart';
import 'package:app/models/error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookInterface extends Mock implements BookInterface {}

void main() {
  final bookInterface = MockBookInterface();
  late UpdateCurrentPageNumberInBookUseCase useCase;
  const String bookId = 'b1';
  final Book book = createBook(id: bookId, allPagesAmount: 100);

  setUp(() {
    useCase = UpdateCurrentPageNumberInBookUseCase(
      bookInterface: bookInterface,
    );
    when(
      () => bookInterface.getBookById(bookId: bookId),
    ).thenAnswer((_) => Stream.value(book));
    when(
      () => bookInterface.updateBookData(
        bookId: bookId,
        bookStatus: any(named: 'bookStatus'),
        readPagesAmount: any(named: 'readPagesAmount'),
      ),
    ).thenAnswer((_) async => '');
  });

  tearDown(() {
    reset(bookInterface);
  });

  test(
    'new current page number is higher than all pages amount, should throw book error',
    () async {
      const BookError expectedBookError = BookError(
        code: BookErrorCode.newCurrentPageIsTooHigh,
      );

      try {
        await useCase.execute(bookId: bookId, newCurrentPageNumber: 101);
      } on BookError catch (error) {
        expect(error, expectedBookError);
      }
    },
  );

  test(
    'new current page number is lower than the last page number, should call method responsible for updating book with number of new current page assigned to read pages amount',
    () async {
      const int newCurrentPage = 20;

      await useCase.execute(
        bookId: bookId,
        newCurrentPageNumber: newCurrentPage,
      );

      verify(
        () => bookInterface.updateBookData(
          bookId: bookId,
          readPagesAmount: newCurrentPage,
        ),
      ).called(1);
    },
  );

  test(
    'new current page number is equal to the last page number, should call method responsible for updating book with number of current page assigned to read pages amount and book status set as finished',
    () async {
      final int newCurrentPage = book.allPagesAmount;

      await useCase.execute(
        bookId: bookId,
        newCurrentPageNumber: newCurrentPage,
      );

      verify(
        () => bookInterface.updateBookData(
          bookId: bookId,
          readPagesAmount: newCurrentPage,
          bookStatus: BookStatus.finished,
        ),
      ).called(1);
    },
  );
}
