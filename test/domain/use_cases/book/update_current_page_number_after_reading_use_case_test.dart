import 'package:app/config/errors.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/update_current_page_number_after_reading_use_case.dart';
import 'package:app/models/error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/domain/interfaces/mock_book_interface.dart';
import '../../../mocks/domain/interfaces/mock_day_interface.dart';
import '../../../mocks/providers/mock_date_provider.dart';

void main() {
  final bookInterface = MockBookInterface();
  final dayInterface = MockDayInterface();
  final dateProvider = MockDateProvider();

  late UpdateCurrentPageNumberAfterReadingUseCase useCase;
  const String userId = 'u1';
  final DateTime todayDate = DateTime(2022, 9, 20);
  const String bookId = 'b1';
  final Book book = createBook(
    id: bookId,
    userId: userId,
    readPagesAmount: 20,
    allPagesAmount: 100,
  );

  setUp(() {
    useCase = UpdateCurrentPageNumberAfterReadingUseCase(
      bookInterface: bookInterface,
      dayInterface: dayInterface,
      dateProvider: dateProvider,
    );
    bookInterface.mockGetBookById(book: book);
    bookInterface.mockUpdateBookData();
    dayInterface.mockAddNewReadPages();
  });

  tearDown(() {
    reset(bookInterface);
    reset(dayInterface);
    reset(dateProvider);
  });

  test(
    'new current page number is higher than all pages amount, should throw book error',
    () async {
      const BookError expectedBookError = BookError(
        code: BookErrorCode.newCurrentPageIsTooHigh,
      );

      try {
        await useCase.execute(
          bookId: bookId,
          newCurrentPageNumber: 101,
        );
      } on BookError catch (error) {
        expect(error, expectedBookError);
      }
    },
  );

  test(
    'new current page number is lower than current page number, should throw book error',
    () async {
      const BookError expectedBookError = BookError(
        code: BookErrorCode.newCurrentPageIsLowerThanCurrentPage,
      );

      try {
        await useCase.execute(
          bookId: bookId,
          newCurrentPageNumber: 10,
        );
      } on BookError catch (error) {
        expect(error, expectedBookError);
      }
    },
  );

  test(
    'new current page number is lower than the last page number, should call method responsible for updating book with number of new current page assigned to read pages amount and should call method responsible for adding amount of new read pages with today date to days',
    () async {
      const int newCurrentPage = 50;
      dateProvider.mockGetNow(nowDateTime: todayDate);

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
      verify(
        () => dayInterface.addNewReadPages(
          userId: userId,
          date: todayDate,
          bookId: bookId,
          amountOfReadPagesToAdd: newCurrentPage - book.readPagesAmount,
        ),
      ).called(1);
    },
  );

  test(
    'new current page number is equal to the last page number, should call method responsible for updating book with number of current page assigned to read pages amount and book status set as finished and should call method responsible for adding amount of new read pages with today date to days',
    () async {
      final int newCurrentPage = book.allPagesAmount;
      dateProvider.mockGetNow(nowDateTime: todayDate);

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
      verify(
        () => dayInterface.addNewReadPages(
          userId: userId,
          date: todayDate,
          bookId: bookId,
          amountOfReadPagesToAdd: newCurrentPage - book.readPagesAmount,
        ),
      ).called(1);
    },
  );
}
