import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/update_current_page_number_after_reading_use_case.dart';
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
  });

  tearDown(() {
    reset(bookInterface);
    reset(dayInterface);
    reset(dateProvider);
  });

  //TODO
}
